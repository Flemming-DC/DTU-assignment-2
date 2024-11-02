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
  programCounter.io.jump := jump(alu, opCode, operand_1, operand_2, operand_3)
  programCounter.io.programCounterJump := operand_1 // target destination reg_or_mem

  // --- into programMemory --- //
  programMemory.io.address := programCounter.io.programCounter
  // --- into controlUnit --- //
  controlUnit.io.instruction := opCode

  // --- into register --- //
  private val from_memory_or_calc = Mux(
    controlUnit.io.memToReg,
    dataMemory.io.dataRead,
    alu.io.result
  )
  // val reg_load_or_immediate = Mux(
  //   controlUnit.io.regDst, _, _) // = load immediate, ?, ?
  registerFile.io.aSel := operand_2 // = aSel = regSrc_1
  registerFile.io.aSel := operand_3 // = bSel = regSrc_2 or immediate value
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
  dataMemory.io.address := alu.io.result
  dataMemory.io.writeEnable := controlUnit.io.memWriteEnable
  dataMemory.io.dataWrite := registerFile.io.b



  private def splitInstruction(instruction: UInt): (UInt, UInt, UInt, UInt) = {
    // instruction is UInt(32.W)
    //  operation ---- inputs -------- //
    val LI   = 0.U(4.W); // reg, value
    val LD   = 1.U(4.W); // regDst, reg_or_mem
    val SD   = 9.U(4.W); // reg_or_mem, regSrc
    val ADDI = 2.U(4.W); // regDst, regSrc, value
    val ADD  = 3.U(4.W); // regDst, regSrc_1, regSrc_2
    val MULT = 4.U(4.W); // regDst, regSrc_1, regSrc_2
    val JNEQ = 5.U(4.W); // prog_mem_dst, regSrc_1, regSrc_1
    val JLT  = 6.U(4.W); // prog_mem_dst, regSrc_1, regSrc_1
    val JR   = 7.U(4.W); // prog_mem_dst
    val END  = 8.U(4.W); //


    val opCode = instruction(3, 0);
    val unused = 0.U;
    val operand_1 = UInt();
    val operand_2 = UInt();
    val operand_3 = UInt();

    when (opCode === END) {
      //return (opCode, unused , unused, unused);
    } .elsewhen (opCode === JR) {
      operand_1 := instruction(31, 4);
      // return (opCode, instruction(31, 4), unused, unused);
    } .elsewhen(opCode === LI || opCode === LD || opCode === SD) {
      operand_1 := instruction(31, 4);
      operand_2 := instruction(31, 8);
      // return (opCode, instruction(7, 4), instruction(31, 8), unused);
    } .otherwise {
      operand_1 := instruction(31, 4);
      operand_2 := instruction(11, 8);
      operand_3 := instruction(31, 12);
      // return (opCode, instruction(7, 4), instruction(11, 8), instruction(31, 12));
    }

    return (opCode, operand_1, operand_2, operand_3)

  }

  private def jump(alu: ALU, opCode: UInt, operand_1: UInt, operand_2: UInt, operand_3: UInt): Bool = {
    val JNEQ = 5.U; // prog_mem_dst, regSrc_1, regSrc_1
    val JLT = 6.U;  // prog_mem_dst, regSrc_1, regSrc_1
    val JR = 7.U;   // prog_mem_dst

    switch(opCode) {
      is(JR)  { return true.B}
      is(JLT) { return alu.io.result < 0.S}
      is(JNEQ)  {return !alu.io.zero}
    }

    return false.B
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



























