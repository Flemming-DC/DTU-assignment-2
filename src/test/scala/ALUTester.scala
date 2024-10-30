import chisel3._
import chisel3.iotesters.PeekPokeTester

class ALUTester(dut: ALU) extends PeekPokeTester(dut) {

  // running for 5 clock cycles
  poke(dut.io.x, 0)
  poke(dut.io.y, 0)
  poke(dut.io.sel, 0)
  step(5)

}

object ALUTester {
  def main(args: Array[String]): Unit = {
    println("Testing ALU")
    iotesters.Driver.execute(
      Array("--generate-vcd-output", "on",
        "--target-dir", "generated",
        "--top-name", "ALU"),
      () => new ALU()) {
      c => new ALUTester(c)
    }
  }
}
