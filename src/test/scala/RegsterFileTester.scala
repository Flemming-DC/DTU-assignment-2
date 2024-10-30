import chisel3._
import chisel3.iotesters.PeekPokeTester

class RegisterFileTester(dut: RegisterFile) extends PeekPokeTester(dut) {

  // running for 5 clock cycles
  poke(dut.io.aSel, 0)
  poke(dut.io.bSel, 0)
  poke(dut.io.writeData, 0)
  poke(dut.io.writeSel, 0)
  poke(dut.io.writeEnable, false)
  step(5)


}

object RegisterFileTester {
  def main(args: Array[String]): Unit = {
    println("Testing Register File")
    iotesters.Driver.execute(
      Array("--generate-vcd-output", "on",
        "--target-dir", "generated",
        "--top-name", "RegisterFile"),
      () => new RegisterFile()) {
      c => new RegisterFileTester(c)
    }
  }
}
