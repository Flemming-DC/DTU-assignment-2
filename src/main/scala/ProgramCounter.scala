import chisel3._
import chisel3.util._

// ProgramCounter er en instruction pointer
class ProgramCounter extends Module {
  val io = IO(new Bundle {
    val run = Input(Bool())
    val stop = Input(Bool())
    val jump = Input(Bool())
    val programCounterJump = Input(UInt(16.W))

    val programCounter = Output(UInt(16.W))
  })

  //Implement this module here (respect the provided interface, since it used by the tester)

  private val counterReg = RegInit(0.U(16.W));
  when(io.run && !io.jump && !io.stop){
    counterReg := counterReg + 1.U;
  } .elsewhen(io.run && io.jump && !io.stop) {
    counterReg := io.programCounterJump;
  }
  io.programCounter := counterReg;

}
