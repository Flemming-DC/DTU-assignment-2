import chisel3._
import chisel3.util._



class CPUTop extends Module {
  val io = IO(new Bundle {
    val run = Input(Bool ())

    val done = Output(Bool ())

    //This signals are used by the tester for loading and dumping the memory content, do not touch
    val testerDataMemEnable = Input(Bool ())
    val testerDataMemAddress = Input(UInt (16.W))
    val testerDataMemDataRead = Output(UInt (32.W))
    val testerDataMemWriteEnable = Input(Bool ())
    val testerDataMemDataWrite = Input(UInt (32.W))
    //This signals are used by the tester for loading and dumping the memory content, do not touch
    val testerProgMemEnable = Input(Bool ())
    val testerProgMemAddress = Input(UInt (16.W))
    val testerProgMemDataRead = Output(UInt (32.W))
    val testerProgMemWriteEnable = Input(Bool ())
    val testerProgMemDataWrite = Input(UInt (32.W))
  })

  //Creating components
  val programCounter = Module(new ProgramCounter())
  val dataMemory = Module(new DataMemory())
  val programMemory = Module(new ProgramMemory())
  val registerFile = Module(new RegisterFile())
  val controlUnit = Module(new ControlUnit())
  val alu = Module(new ALU())


  val opCode, _ = splitInstruction(programMemory.io.instructionRead)

  // make minimodules
  val memory_or_calc = Mux(
    controlUnit.io.memToReg,
    dataMemory.io.dataRead,
    alu.io.result
  )
  val alu_load_or_immediate = Mux(
    controlUnit.io.aluSrc,
    _, // literal
    registerFile.io.b
  )
  val reg_load_or_immediate = Mux(
    controlUnit.io.regDst,
    _,
    _
  )
  // output of minimodules
  registerFile.io.writeData := memory_or_calc
  alu.io.y := alu_load_or_immediate
  registerFile.io.writeSel := reg_load_or_immediate

  //Connecting the modules
  programCounter.io.run := io.run
  programMemory.io.address := programCounter.io.programCounter

  dataMemory.io.writeEnable := controlUnit.io.memWriteEnable
  registerFile.io.writeEnable := controlUnit.io.regWriteEnable
  alu.io.sel := controlUnit.io.aluOp




  //This signals are used by the tester for loading the program to the program memory, do not touch
  programMemory.io.testerAddress := io.testerProgMemAddress
  io.testerProgMemDataRead := programMemory.io.testerDataRead
  programMemory.io.testerDataWrite := io.testerProgMemDataWrite
  programMemory.io.testerEnable := io.testerProgMemEnable
  programMemory.io.testerWriteEnable := io.testerProgMemWriteEnable
  //This signals are used by the tester for loading and dumping the data memory content, do not touch
  dataMemory.io.testerAddress := io.testerDataMemAddress
  io.testerDataMemDataRead := dataMemory.io.testerDataRead
  dataMemory.io.testerDataWrite := io.testerDataMemDataWrite
  dataMemory.io.testerEnable := io.testerDataMemEnable
  dataMemory.io.testerWriteEnable := io.testerDataMemWriteEnable



  private def splitInstruction(instruction: UInt): (UInt, Int) = {
    // instruction is UInt(32.W)
    val opCode = instruction(0, 6)

    // pieces
    return (opCode, 0)
  }

}


