module ProgramCounter(
  input         clock,
  input         reset,
  input         io_stop,
  input         io_jump,
  input         io_run,
  input  [15:0] io_programCounterJump,
  output [15:0] io_programCounter
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [15:0] counterReg; // @[ProgramCounter.scala 15:27]
  wire  _T = ~io_jump; // @[ProgramCounter.scala 16:18]
  wire  _T_1 = io_run & _T; // @[ProgramCounter.scala 16:15]
  wire  _T_2 = ~io_stop; // @[ProgramCounter.scala 16:30]
  wire  _T_3 = _T_1 & _T_2; // @[ProgramCounter.scala 16:27]
  wire [15:0] _T_5 = counterReg + 16'h1; // @[ProgramCounter.scala 17:30]
  wire  _T_6 = io_run & io_jump; // @[ProgramCounter.scala 18:22]
  wire  _T_8 = _T_6 & _T_2; // @[ProgramCounter.scala 18:33]
  assign io_programCounter = counterReg; // @[ProgramCounter.scala 21:21]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  counterReg = _RAND_0[15:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      counterReg <= 16'h0;
    end else if (_T_3) begin
      counterReg <= _T_5;
    end else if (_T_8) begin
      counterReg <= io_programCounterJump;
    end
  end
endmodule
