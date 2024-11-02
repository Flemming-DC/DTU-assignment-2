import chisel3._
import chisel3.iotesters.PeekPokeTester

class ControlUnitTester(dut: ControlUnit) extends PeekPokeTester(dut) {

  poke(dut.io.instruction, 0.U) // LI (Load Immediate)
  step(1)

  poke(dut.io.instruction, 1.U) // LD (Load from Memory)
  step(1)

  poke(dut.io.instruction, 9.U) // SD (Store to Memory)
  step(1)

  poke(dut.io.instruction, 2.U) // ADDI (Add Immediate)
  step(1)

  poke(dut.io.instruction, 3.U) // ADD (Addition)
  step(1)

  poke(dut.io.instruction, 4.U) // MULT (Multiply)
  step(1)

  poke(dut.io.instruction, 5.U) // JNEQ (Jump if Not Equal)
  step(1)

  poke(dut.io.instruction, 6.U) // JLT (Jump if Less Than)
  step(1)

  poke(dut.io.instruction, 7.U) // JR (Jump Register)
  step(1)

  poke(dut.io.instruction, 8.U) // END (End of Program)
  step(1)
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
