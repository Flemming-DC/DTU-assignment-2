import chisel3._
import chisel3.util._
import org.scalacheck.Prop.False



class CPUTop extends Module {
  val io = IO(new Bundle {
    val run = Input(Bool ())

    val done = Output(Bool ())

    // These signals are used by the tester for loading and dumping the memory content, do not touch
    val testerDataMemEnable = Input(Bool ())
    val testerDataMemAddress = Input(UInt (16.W))
    val testerDataMemDataRead = Output(UInt (32.W))
    val testerDataMemWriteEnable = Input(Bool ())
    val testerDataMemDataWrite = Input(UInt (32.W))
    // These signals are used by the tester for loading and dumping the memory content, do not touch
    val testerProgMemEnable = Input(Bool ())
    val testerProgMemAddress = Input(UInt (16.W))
    val testerProgMemDataRead = Output(UInt (32.W))
    val testerProgMemWriteEnable = Input(Bool ())
    val testerProgMemDataWrite = Input(UInt (32.W))
  })

  // Creating components
  private val programCounter = Module(new ProgramCounter())
  private val dataMemory = Module(new DataMemory())
  private val programMemory = Module(new ProgramMemory())
  private val registerFile = Module(new RegisterFile())
  private val controlUnit = Module(new ControlUnit())
  private val alu = Module(new ALU())
  // ----------------------- OUR CODE BEGIN ----------------------- //

  io.done := false.B
  private val (opCode, operand_1, operand_2, operand_3) = splitInstruction(programMemory.io.instructionRead)

  // --- into programCounter --- //
  programCounter.io.run := io.run
  programCounter.io.stop := io.done
  programCounter.io.jump := jump(alu, opCode)
  programCounter.io.programCounterJump := operand_1 // target destination reg_or_mem

  // --- into programMemory --- //
  programMemory.io.address := programCounter.io.programCounter
  // --- into controlUnit --- //
  controlUnit.io.instruction := opCode

  // --- into register --- //
  private val from_memory_or_calc = Mux(
    controlUnit.io.memToReg,
    dataMemory.io.dataRead, //.asSInt,
    alu.io.result
  )
  // val reg_load_or_immediate = Mux(
  //   controlUnit.io.regDst, _, _) // = load immediate, ?, ?
  registerFile.io.aSel := operand_2 // = aSel = regSrc_1
  registerFile.io.bSel := operand_3 // = bSel = regSrc_2 or immediate value
  registerFile.io.writeData := from_memory_or_calc
  registerFile.io.writeSel := operand_1 // regDst
  registerFile.io.writeEnable := controlUnit.io.regWriteEnable

  // --- into ALU --- //
  private val alu_load_or_immediate = Mux(
    controlUnit.io.aluSrc,
    operand_3, // immediate value
    registerFile.io.b
  )
  alu.io.x := registerFile.io.a
  alu.io.y := alu_load_or_immediate
  alu.io.sel := controlUnit.io.aluOp

  // --- into Data Memory --- //
  dataMemory.io.address := alu.io.result // why alu result rather than register?
  dataMemory.io.writeEnable := controlUnit.io.memWriteEnable
  dataMemory.io.dataWrite := registerFile.io.b



  private def splitInstruction(instruction: UInt): (UInt, UInt, UInt, UInt) = {
    // instruction is UInt(32.W)
    //  operation ---- inputs -------- //
    val LI   = 0.U(4.W); // reg, value
    val LD   = 1.U(4.W); // regDst, reg_or_mem
    val SD   = 2.U(4.W); // reg_or_mem, regSrc
    val ADDI = 3.U(4.W); // regDst, regSrc, value
    val ADD  = 4.U(4.W); // regDst, regSrc_1, regSrc_2
    val MULT = 5.U(4.W); // regDst, regSrc_1, regSrc_2
    val JNEQ = 6.U(4.W); // prog_mem_dst, regSrc_1, regSrc_1
    val JLT  = 7.U(4.W); // prog_mem_dst, regSrc_1, regSrc_1
    val JR   = 8.U(4.W); // prog_mem_dst
    val END  = 9.U(4.W); //
    val SUB  = 10.U(4.W);// regDst, regSrc, regSrc


    val opCode = instruction(3, 0);
    val operand_1 = Wire(UInt(8.W));
    val operand_2 = Wire(UInt(10.W));
    val operand_3 = Wire(UInt(10.W));
    operand_1 := 0.U;
    operand_2 := 0.U;
    operand_3 := 0.U;

    when (opCode === END) {
    } .elsewhen (opCode === JR) {
      operand_1 := instruction(7, 4);
    } .elsewhen(opCode === LI || opCode === LD || opCode === SD) {
      operand_1 := instruction(11, 4);
      operand_2 := instruction(21, 12);
    } .otherwise {
      operand_1 := instruction(11, 4);
      operand_2 := instruction(21, 12);
      operand_3 := instruction(31, 22);
    }

    return (opCode, operand_1, operand_2, operand_3)

  }

  private def jump(alu: ALU, opCode: UInt): Bool = {
    val JNEQ = 6.U; // prog_mem_dst, regSrc_1, regSrc_1
    val JLT = 7.U;  // prog_mem_dst, regSrc_1, regSrc_1
    val JR = 8.U;   // prog_mem_dst

    val out = Wire(Bool())
    out := false.B;
    switch(opCode) {
      is(JR)  { out := true.B}
      is(JLT) { out := alu.io.result < 0.U}
      is(JNEQ){ out := !alu.io.zero}
    }

    return out
  }

  // ----------------------- OUR CODE END ----------------------- //
  //These signals are used by the tester for loading the program to the program memory, do not touch
  programMemory.io.testerAddress := io.testerProgMemAddress
  io.testerProgMemDataRead := programMemory.io.testerDataRead
  programMemory.io.testerDataWrite := io.testerProgMemDataWrite
  programMemory.io.testerEnable := io.testerProgMemEnable
  programMemory.io.testerWriteEnable := io.testerProgMemWriteEnable
  //These signals are used by the tester for loading and dumping the data memory content, do not touch
  dataMemory.io.testerAddress := io.testerDataMemAddress
  io.testerDataMemDataRead := dataMemory.io.testerDataRead
  dataMemory.io.testerDataWrite := io.testerDataMemDataWrite
  dataMemory.io.testerEnable := io.testerDataMemEnable
  dataMemory.io.testerWriteEnable := io.testerDataMemWriteEnable




}



























