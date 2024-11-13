import chisel3._
import chisel3.util._

class RegisterFile extends Module {
  val io = IO(new Bundle {
    val aSel = Input(UInt(12.W)) // select register for output a
    val bSel = Input(UInt(12.W)) // select register for output b
    val writeData = Input(UInt(32.W)) // if (writeEnable) put writeData in writeSel
    val writeSel = Input(UInt(4.W)) // select register for writeData
    val writeEnable = Input(Bool())

    val a = Output(UInt(32.W))
    val b = Output(UInt(32.W))
  })

  //Implement this module here
  val registers = Reg(Vec(16, UInt (32.W)))

  // Read
  io.a := registers(io.aSel)
  io.b := registers(io.bSel)
  // Write
  when (io.writeEnable){
    registers(io.writeSel) := io.writeData
  }


}