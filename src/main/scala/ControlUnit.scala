import chisel3._
import chisel3.util._

class ControlUnit extends Module {
  val io = IO(new Bundle {
    val instruction = Input(UInt(4.W)) // opCode

    //val regDst = Output(Bool()) // load immediate
    val regWriteEnable = Output(Bool()) // regWrite

    val aluOp = Output(UInt(2.W))
    val aluSrc = Output(Bool())

    val memToReg = Output(Bool()) // take data from memory, not alu
    val memWriteEnable = Output(Bool())

    //val branch = Output(Bool())
  })

  //Implement this module here

  // opCodes
  val LI = 0.U;
  val LD = 1.U;
  val SD = 9.U;
  val ADDI = 2.U;
  val ADD = 3.U;
  val MULT = 4.U;
  val JNEQ = 5.U;
  val JLT = 6.U;
  val JR = 7.U;
  val END = 8.U;

  // default


  // aluOp
  io.aluOp := 0.U
  switch(io.instruction) {
    is(ADD)  {io.aluOp := 0.U}
    is(ADDI) {io.aluOp := 0.U}
    is(MULT) {io.aluOp := 1.U}
    is(JNEQ) {io.aluOp := 2.U}
    is(JLT)  {io.aluOp := 2.U}
  }
  // aluSrc (vælg om vi bruger Immediate eller load fra register)
  // aluSrc = load immediate
  io.aluSrc := false.B
  switch(io.instruction) {
    is(ADD)  {io.aluSrc := false.B}
    is(ADDI) {io.aluSrc := true.B}
    is(MULT) {io.aluSrc := false.B}
    is(JNEQ) {io.aluSrc := false.B}
    is(JLT)  {io.aluSrc := false.B}
  }

  io.regWriteEnable := false.B
  switch(io.instruction) {
    is(ADD)  {io.regWriteEnable := true.B}
    is(ADDI) {io.regWriteEnable := true.B}
    is(MULT) {io.regWriteEnable := true.B}
  }
  /*
  io.regDst := false.B // regDst = load immediate
  switch(io.instruction) {
    is(ADD)  {io.regDst := false.B}
    is(ADDI) {io.regDst := true.B}
    is(MULT) {io.regDst := false.B}
    is(JNEQ) {io.regDst := false.B}
    is(JLT)  {io.regDst := false.B}
  }
  */

  io.memToReg := false.B // take data from memory rather than from calculation
  switch(io.instruction) {
    is(LD) {io.memToReg := true.B}
    is(ADDI) {io.memToReg := false.B}
    is(ADD) {io.memToReg := false.B}
    is(MULT)  {io.memToReg := false.B}
  }

  io.memWriteEnable := false.B
  switch(io.instruction) {
    is(SD) {io.memWriteEnable := true.B}
  }
/*
  io.branch := false.B
  switch(io.instruction) {
    is(JR) {io.branch := true.B}
    is(JLT) {io.branch := true.B}
    is(JNEQ) {io.branch := true.B}
  }
 */
}