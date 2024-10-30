import chisel3._
import chisel3.util._

class ALU extends Module {
  val io = IO(new Bundle {
    val x = Input(SInt(32.W))
    val y = Input(SInt(32.W))
    val sel = Input(UInt(2.W)) // choose oparation

    val result = Output(SInt(32.W))
    val zero = Output(Bool())
  })

  // sel
  val ADD = 0.U;
  val MULT = 1.U;
  val SUB = 2.U;

  io.result := 0.S;

  switch(io.sel) {
    is(ADD)  {io.result := io.x + io.y}
    is(MULT) {io.result := io.x * io.y}
    is(SUB)  {io.result := io.x - io.y}
  }
  io.zero := (io.result === 0.S);

}