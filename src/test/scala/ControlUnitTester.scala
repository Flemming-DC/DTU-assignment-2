import chisel3._
import chisel3.iotesters.PeekPokeTester

class ControlUnitTester(dut: ControlUnit) extends PeekPokeTester(dut) {

  poke(dut.io.opCode, 0.U) // LI (Load Immediate)
  step(1)

  poke(dut.io.opCode, 1.U) // LD (Load from Memory)
  step(1)

  poke(dut.io.opCode, 9.U) // SD (Store to Memory)
  step(1)

  poke(dut.io.opCode, 2.U) // ADDI (Add Immediate)
  step(1)

  poke(dut.io.opCode, 3.U) // ADD (Addition)
  step(1)

  poke(dut.io.opCode, 4.U) // MULT (Multiply)
  step(1)

  poke(dut.io.opCode, 5.U) // JNEQ (Jump if Not Equal)
  step(1)

  poke(dut.io.opCode, 6.U) // JLT (Jump if Less Than)
  step(1)

  poke(dut.io.opCode, 7.U) // JR (Jump Register)
  step(1)

  poke(dut.io.opCode, 8.U) // END (End of Program)
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
