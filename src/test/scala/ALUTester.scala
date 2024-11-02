import chisel3._
import chisel3.iotesters.PeekPokeTester

class ALUTester(dut: ALU) extends PeekPokeTester(dut) {

  // Test Add
  poke(dut.io.x, 2)
  poke(dut.io.y, 3)
  poke(dut.io.sel, 0)
  step(5)

  //Test mult1
  poke(dut.io.x, 5)
  poke(dut.io.y, 5)
  poke(dut.io.sel,1)
  step(5)

  //Test mult2
  poke(dut.io.x, 2)
  poke(dut.io.y, 3)
  poke(dut.io.sel,1)
  step(5)

  //Test mult3
  poke(dut.io.x, 5)
  poke(dut.io.y, 2)
  poke(dut.io.sel,1)
  step(5)

  //Test mult4
  poke(dut.io.x, 25)
  poke(dut.io.y, 5)
  poke(dut.io.sel,1)
  step(5)

  //test sub1
  poke(dut.io.x, 5)
  poke(dut.io.y, 2)
  poke(dut.io.sel,2)
  step(5)

  //test sub2
  poke(dut.io.x, 10)
  poke(dut.io.y, 1)
  poke(dut.io.sel,2)
  step(5)

  //test sub3
  poke(dut.io.x, 20)
  poke(dut.io.y, 10)
  poke(dut.io.sel,2)
  step(5)


  //test zero
  poke(dut.io.x, 5)
  poke(dut.io.y, 5)
  poke(dut.io.sel,2)
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
