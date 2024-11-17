import chisel3._
import chisel3.util._
import chisel3.iotesters
import chisel3.iotesters.PeekPokeTester
import java.util

object Programs{
  val LI   = 0.U(4.W); // 0000: reg, value
  val LD   = 1.U(4.W); // 0001: regDst, mem
  val SD   = 2.U(4.W); // 0010: mem, regSrc
  val ADDI = 3.U(4.W); // 0011: regDst, regSrc, value
  val ADD  = 4.U(4.W); // 0100: regDst, regSrc_1, regSrc_2
  val MULT = 5.U(4.W); // 0101: regDst, regSrc_1, regSrc_2
  val JNEQ = 6.U(4.W); // 0110: prog_mem_dst, regSrc_1, regSrc_1
  val JLT  = 7.U(4.W); // 0111: prog_mem_dst, regSrc_1, regSrc_1
  val JR   = 8.U(4.W); // 1000: prog_mem_dst
  val END  = 9.U(4.W); // 1001:
  val SUB  = 10.U(4.W);// 1010: regDst, regSrc, regSrc


  val program_erosion = Array(
  // aller først definer konstanter
  "b0000__00000100__0000000000__0000000000".U(32.W), // LI R4, 0 // bruges inde i step                              -- 0
  "b0000__00000010__0000010100__0000000000".U(32.W), // LI R2, 20 // set max grænse på loop

  // outerloop-start
  "b0000__00000001__0000000000__0000000000".U(32.W), // LI R1, 0; // x = 0
// outerloop-body (idx 3):
  // innerloop-start
  "b0000__00000011__0000000000__0000000000".U(32.W), // LI R3, 0; // y = 0
// innerloop-body (idx 4):
    // processing border pixel
    // LD, R5, out_image(x=R1, y=R3)
      "b0000__00000111__0110010000__0000000000".U(32.W), // LI R7, 400=&out_image(0, 0)
      "b0101__00000101__0000000010__0000000011".U(32.W), // MULT R5, R2, y // R = 20*y                               -- 5
      "b0100__00000101__0000000101__0000000001".U(32.W), // ADD R5, R5, x // R = x + 20 * y
      "b0100__00000101__0000000101__0000000111".U(32.W), // ADD R5, R5, R7 // R = x + 20 * y + out_image(0, 0)
      "b0011__00000000__0000000000__0000000000".U(32.W), // plus 0 aka. No-op, a replacement for "b0001__00000101__0000000101__0000000000".U(32.W), // LD R5, mem-of-R

    // x==0 check
    "b0110__00001100__0000000001__0000000100".U(32.W), // JNEQ y_0, R1, R4 // if (x == 0)
    // SI out_image(x=R1, y=R3), 0
    "b0010__00000101__0000000100__0000000000".U(32.W), // SD R5, R4 // out_image(x=R1, y=R3) = 0                   -- 10
    "b1000__01000000__0000000000__0000000000".U(32.W), // JR innerloop-end  // continue
    // y_0 (idx 12, 1100):
    "b0110__00001111__0000000011__0000000100".U(32.W), // JNEQ x_19, R3, R4 // if (y == 0)
    // SI out_image(x=R1, y=R3), 0
    "b0010__00000101__0000000100__0000000000".U(32.W), // SD R5, R4 // out_image(x=R1, y=R3) = 0
    "b1000__01000000__0000000000__0000000000".U(32.W), // JR innerloop-end  // continue
    // x_19 (idx 15, 1111):
    "b0110__00010010__0000000001__0000000010".U(32.W), // JNEQ y_19, R1, R2 // if (x == 19)                        -- 15
    // SI out_image(x=R1, y=R3), 0
    "b0010__00000101__0000000100__0000000000".U(32.W), // SD R5, R4 // out_image(x, y) = 0
    "b1000__01000000__0000000000__0000000000".U(32.W), // JR innerloop-end  // continue
    // y_19 (idx 18, 10010):
    "b0110__00010101__0000000011__0000000010".U(32.W), // JNEQ in_image, R3, R2 // if (y == 19)
    // SI out_image(x=R1, y=R3), 0
    "b0010__00000101__0000000100__0000000000".U(32.W), // SD R5, R4 // out_image(x=R1, y=R3) = 0
    "b1000__01000000__0000000000__0000000000".U(32.W), // JR innerloop-end  // continue                            -- 20

    // in_image_0 (idx 21, 10101): // processing inner pixel
    // LD, R6, in_image(x=R1, y=R3)
    "b0000__00000111__0000000000__0000000000".U(32.W), // LI R7, 0=&in_image(0, 0)
      "b0101__00000110__0000000010__0000000011".U(32.W), // MULT R, R2, y // R = 20*y
      "b0100__00000110__0000000110__0000000001".U(32.W), // ADD R, R, x // R = x + 20 * y
      "b0100__00000110__0000000110__0000000111".U(32.W), // ADD R, R, R7 // R = x + 20 * y + in_image(0, 0)
      "b0001__00000110__0000000110__0000000000".U(32.W), // LD R, mem-of-R                                         -- 25
    "b0110__00011110__0000000110__0000000100".U(32.W), // JNEQ left, R6, R4 // if (in_image(x, y) == 0)
    // black pixel
    "b0010__00000101__0000000100__0000000000".U(32.W), // SD R5, R4 // out_image(x=R1, y=R3) = 0
    "b1000__01000000__0000000000__0000000000".U(32.W), // JR innerloop-end // skip else block

    // white pixel, checking neighboring pixels
    "b0000__00001010__0000000001__0000000000".U(32.W), // LI R10, 1
    // left (idx 30, 11110):	// x-1 check
    // LD, R6, in_image(x=R9=R1-1, y=R3)
      "b1010__00001001__0000000011__0000001010".U(32.W), // SUB R9, R1, R10 // R9 = x - 1                          -- 30
      "b0101__00000110__0000000010__0000000011".U(32.W), // MULT R, R2, y // R = 20*y
      "b0100__00000110__0000000110__0000001001".U(32.W), // ADD R, R, x // R = x + 20 * y
      "b0100__00000110__0000000110__0000000111".U(32.W), // ADD R, R, R7 // R = x + 20 * y + in_image(0, 0)
      "b0001__00000110__0000000110__0000000000".U(32.W), // LD R, mem-of-R -- 34
    "b0110__00100110__0000000110__0000000100".U(32.W), // JNEQ right, R6, R4 // if (in_image(x - 1, y) == 0)       -- 35
    "b0010__00000101__0000000100__0000000000".U(32.W), // SD R5, R4 // out_image(x=R1, y=R3) = 0
    "b1000__01000000__0000000000__0000000000".U(32.W), // JR innerloop-end  // skip else aka. continue
    // right (idx 38, 100110):	// x-1 check
    // LD, R6, in_image(x=R9=R1+1, y=R3) // overskriver in_image(x - 1, y)
      "b0011__00001001__0000000001__0000000001".U(32.W), // ADDI R9, R1, 1 // R9 = x + 1
      "b0101__00000110__0000000010__0000000011".U(32.W), // MULT R, R2, y // R = 20*y
      "b0100__00000110__0000000110__0000001001".U(32.W), // ADD R, R, x // R = x + 20 * y                          -- 40
      "b0100__00000110__0000000110__0000000111".U(32.W), // ADD R, R, R7 // R = x + 20 * y + in_image(0, 0)
      "b0001__00000110__0000000110__0000000000".U(32.W), // LD R, mem-of-R
    "b0110__00101110__0000000110__0000000100".U(32.W), // JNEQ down, R6, R4 // if (in_image(x + 1, y) == 0)
    "b0010__00000101__0000000100__0000000000".U(32.W), // SD R5, R4 // out_image(x=R1, y=R3) = 0
    "b1000__01000000__0000000000__0000000000".U(32.W), // JR innerloop-end  // skip else aka. continue             -- 45
    // down (idx 46):	// y-1 check
    // LD, R6, in_image(x=R1, y=R9=R3-1) // overskriver in_image(x+1, y)
      "b1010__00001001__0000000011__0000001010".U(32.W), // SUB R9, R3, R10 // R9 = x - 1
      "b0101__00000110__0000000010__0000001001".U(32.W), // MULT R, R2, y // R = 20*y
      "b0100__00000110__0000000110__0000000001".U(32.W), // ADD R, R, x // R = x + 20 * y
      "b0100__00000110__0000000110__0000000111".U(32.W), // ADD R, R, R7 // R = x + 20 * y + in_image(0, 0)
      "b0001__00000110__0000000110__0000000000".U(32.W), // LD R, mem-of-R                                         -- 50
    "b0110__00110110__0000000110__0000000100".U(32.W), // JNEQ top, R6, R4 // if (in_image(x, y-1) == 0)
    "b0010__00000101__0000000100__0000000000".U(32.W), // SD R5, R4 // out_image(x=R1, y=R3) = 0
    "b1000__01000000__0000000000__0000000000".U(32.W), // JR innerloop-end  // skip else aka. continue
    // top (idx 54):	// y+1 check
    // LD, R6, in_image(x=R1, y=R9=R3 + 1) // overskriver in_image(x, y - 1)
      "b0011__00001001__0000000011__0000000001".U(32.W), // ADDI R9, R3, 1 // R9 = x + 1
      "b0101__00000110__0000000010__0000001001".U(32.W), // MULT R, R2, y // R = 20*y                              -- 55
      "b0100__00000110__0000000110__0000000001".U(32.W), // ADD R, R, x // R = x + 20 * y
      "b0100__00000110__0000000110__0000000111".U(32.W), // ADD R, R, R7 // R = x + 20 * y + in_image(0, 0)
      "b0001__00000110__0000000110__0000000000".U(32.W), // LD R, mem-of-R
    "b0110__00111110__0000000110__0000000100".U(32.W), // JNEQ dont_erode, R6, R4 // if (in_image(x, y + 1) == 0)
    "b0010__00000101__0000000100__0000000000".U(32.W), // SD R5, R4 // out_image(x=R1, y=R3) = 0                   -- 60
    "b1000__01000000__0000000000__0000000000".U(32.W), // JR innerloop-end  // skip else aka. continue

    // dont_erode (idx 62):
    "b0000__00001011__0011111111__0000000000".U(32.W), // LI R11, 255 //
    "b0010__00000101__0000001011__0000000000".U(32.W), // SD R5, R11 // out_image(x=R1, y=R3) = 255


  // innerloop-end (idx 64):
  "b0011__00000011__0000000011__0000000001".U(32.W), // ADDI R3, R3, 1 // y++
  "b0111__00000100__0000000011__0000000010".U(32.W), // JLT innerloop-body, R3, R2 // jump to start if y < 20      -- 65

  // outerloop-end
  "b0011__00000001__0000000001__0000000001".U(32.W), // ADDI R1, R1, 1 // x++
  "b0111__00000011__0000000001__0000000010".U(32.W), // JLT outerloop-body, R1, R2 // jump to start if x < 20
  "b1001__00000000__0000000000__0000000000".U(32.W) // END                                                         -- 68
)

  val program_debug = Array(
    // aller først definer konstanter
    "b0000__00000100__0000000000__0000000000".U(32.W), // LI R4, 0 // bruges inde i step
    "b0000__00000010__0000010100__0000000000".U(32.W), // LI R2, 20 // set max grænse på loop
    "b1001__00000000__0000000000__0000000000".U(32.W) // END
  )

  val program1 = program_erosion;
  //val program1 = program_debug;


/*
val program2 = Array(
  "h00000000".U(32.W),
  "h00000000".U(32.W),
  "h00000000".U(32.W),
  "h00000000".U(32.W),
  "h00000000".U(32.W),
  "h00000000".U(32.W),
  "h00000000".U(32.W),
  "h00000000".U(32.W),
  "h00000000".U(32.W),
  "h00000000".U(32.W),
  "h00000000".U(32.W),
  "h00000000".U(32.W)
)
*/
}