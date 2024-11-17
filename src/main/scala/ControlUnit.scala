import chisel3._
import chisel3.util._

class ControlUnit extends Module {
  val io = IO(new Bundle {
    val opCode = Input(UInt(4.W)) // opCode

    //val regDst = Output(Bool()) // load immediate
    val regWriteEnable = Output(Bool()) // regWrite

    val aluOp = Output(UInt(2.W))
    val aluSrc = Output(Bool()) // reg or immediate into alu ?

    val memToReg = Output(Bool()) // take data from memory, not alu
    val memWriteEnable = Output(Bool())

    //val branch = Output(Bool())
  })

  //Implement this module here

  // opCodes
  val LI   = 0.U(4.W); // 0000: reg, value
  val LD   = 1.U(4.W); // 0001: regDst, mem
  val SD   = 2.U(4.W); // 0010: mem, regSrc
  val ADDI = 3.U(4.W); // 0011: regDst, regSrc, value
  val ADD  = 4.U(4.W); // 0100: regDst, regSrc_1, regSrc_2
  val MULT = 5.U(4.W); // 0101: regDst, regSrc_1, regSrc_2
  val JNEQ = 6.U(4.W); // 0110: prog_mem_dst, regSrc_1, regSrc_1
  val JLT  = 7.U(4.W); // 0111: prog_mem_dst, regSrc_1, regSrc_1
  val JR   = 8.U(4.W); // 1000: prog_mem_dst
  val END  = 9.U(4.W); // 1001:
  val SUB  = 10.U(4.W);// 1010: regDst, regSrc, regSrc


  // aluOp
  io.aluOp := 0.U
  switch(io.opCode) {
    is(ADD)  {io.aluOp := 0.U}
    is(ADDI) {io.aluOp := 0.U}
    is(MULT) {io.aluOp := 1.U}
    is(JNEQ) {io.aluOp := 2.U}
    is(JLT)  {io.aluOp := 2.U}
    is(SUB)  {io.aluOp := 2.U}
  }
  // aluSrc (vælg om vi bruger Immediate eller load fra register)
  // aluSrc = load immediate
  io.aluSrc := false.B
  switch(io.opCode) {
    is(ADD)  {io.aluSrc := false.B}
    is(ADDI) {io.aluSrc := true.B}
    is(MULT) {io.aluSrc := false.B}
    is(JNEQ) {io.aluSrc := false.B}
    is(JLT)  {io.aluSrc := false.B}
    is(SUB)  {io.aluSrc := false.B}
  }

  io.regWriteEnable := false.B
  switch(io.opCode) {
    is(LI)   {io.regWriteEnable := true.B}
    is(LD)   {io.regWriteEnable := true.B}
    is(ADD)  {io.regWriteEnable := true.B}
    is(ADDI) {io.regWriteEnable := true.B}
    is(MULT) {io.regWriteEnable := true.B}
    is(SUB)  {io.regWriteEnable := true.B}
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
  switch(io.opCode) {
    is(LD) {io.memToReg := true.B}
    is(ADDI) {io.memToReg := false.B}
    is(ADD) {io.memToReg := false.B}
    is(MULT)  {io.memToReg := false.B}
    is(SUB)  {io.memToReg := false.B}
  }

  io.memWriteEnable := false.B
  switch(io.opCode) {
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