import chisel3._
import chisel3.iotesters.PeekPokeTester

class RegisterFileTester(dut: RegisterFile) extends PeekPokeTester(dut) {

  // Write 100 to register 0
  poke(dut.io.writeSel, 0.U)
  poke(dut.io.writeData, 100.U)
  poke(dut.io.writeEnable, true.B)
  step(1)
  poke(dut.io.writeEnable, false.B)

  // Write 200 to register 1
  poke(dut.io.writeSel, 1.U)
  poke(dut.io.writeData, 200.U)
  poke(dut.io.writeEnable, true.B)
  step(1)
  poke(dut.io.writeEnable, false.B)

  // Write 300 to register 2
  poke(dut.io.writeSel, 2.U)
  poke(dut.io.writeData, 300.U)
  poke(dut.io.writeEnable, true.B)
  step(1)
  poke(dut.io.writeEnable, false.B)

  // Read from each register
  poke(dut.io.aSel, 0.U)
  poke(dut.io.bSel, 1.U)
  step(1)

  poke(dut.io.aSel, 1.U)
  poke(dut.io.bSel, 2.U)
  step(1)

  poke(dut.io.aSel, 2.U)
  poke(dut.io.bSel, 0.U)
  step(1)
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
