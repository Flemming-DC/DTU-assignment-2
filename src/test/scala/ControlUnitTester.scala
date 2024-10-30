import chisel3._
import chisel3.iotesters.PeekPokeTester

class ControlUnitTester(dut: ControlUnit) extends PeekPokeTester(dut) {

  // running for 5 clock cycles
  poke(dut.io.instruction, 0)
  step(5)

}

object ControlUnitTester {
  def main(args: Array[String]): Unit = {
    println("Testing ControlUnit")
    iotesters.Driver.execute(
      Array("--generate-vcd-output", "on",
        "--target-dir", "generated",
        "--top-name", "ControlUnit"),
      () => new ControlUnit()) {
      c => new ControlUnitTester(c)
    }
  }
}
