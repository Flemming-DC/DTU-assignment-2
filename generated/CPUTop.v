module ProgramCounter(
  input         clock,
  input         reset,
  input         io_run,
  input         io_stop,
  input         io_jump,
  input  [15:0] io_programCounterJump,
  output [15:0] io_programCounter
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [15:0] _T; // @[ProgramCounter.scala 17:35]
  wire  _T_1 = ~io_jump; // @[ProgramCounter.scala 18:18]
  wire  _T_2 = io_run & _T_1; // @[ProgramCounter.scala 18:15]
  wire  _T_3 = ~io_stop; // @[ProgramCounter.scala 18:30]
  wire  _T_4 = _T_2 & _T_3; // @[ProgramCounter.scala 18:27]
  wire [15:0] _T_6 = _T + 16'h1; // @[ProgramCounter.scala 19:30]
  wire  _T_7 = io_run & io_jump; // @[ProgramCounter.scala 20:22]
  wire  _T_9 = _T_7 & _T_3; // @[ProgramCounter.scala 20:33]
  assign io_programCounter = _T; // @[ProgramCounter.scala 23:21]
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
  _T = _RAND_0[15:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      _T <= 16'h0;
    end else if (_T_4) begin
      _T <= _T_6;
    end else if (_T_9) begin
      _T <= io_programCounterJump;
    end
  end
endmodule
module DataMemory(
  input         clock,
  input  [15:0] io_address,
  input         io_writeEnable,
  input  [31:0] io_dataWrite,
  output [31:0] io_dataRead,
  input         io_testerEnable,
  input  [15:0] io_testerAddress,
  output [31:0] io_testerDataRead,
  input         io_testerWriteEnable,
  input  [31:0] io_testerDataWrite
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
  reg [31:0] memory [0:65535]; // @[DataMemory.scala 19:20]
  wire [31:0] memory__T_data; // @[DataMemory.scala 19:20]
  wire [15:0] memory__T_addr; // @[DataMemory.scala 19:20]
  wire [31:0] memory__T_2_data; // @[DataMemory.scala 19:20]
  wire [15:0] memory__T_2_addr; // @[DataMemory.scala 19:20]
  wire [31:0] memory__T_1_data; // @[DataMemory.scala 19:20]
  wire [15:0] memory__T_1_addr; // @[DataMemory.scala 19:20]
  wire  memory__T_1_mask; // @[DataMemory.scala 19:20]
  wire  memory__T_1_en; // @[DataMemory.scala 19:20]
  wire [31:0] memory__T_3_data; // @[DataMemory.scala 19:20]
  wire [15:0] memory__T_3_addr; // @[DataMemory.scala 19:20]
  wire  memory__T_3_mask; // @[DataMemory.scala 19:20]
  wire  memory__T_3_en; // @[DataMemory.scala 19:20]
  wire [31:0] _GEN_5 = io_testerWriteEnable ? io_testerDataWrite : memory__T_data; // @[DataMemory.scala 25:32]
  wire [31:0] _GEN_11 = io_writeEnable ? io_dataWrite : memory__T_2_data; // @[DataMemory.scala 33:26]
  assign memory__T_addr = io_testerAddress;
  assign memory__T_data = memory[memory__T_addr]; // @[DataMemory.scala 19:20]
  assign memory__T_2_addr = io_address;
  assign memory__T_2_data = memory[memory__T_2_addr]; // @[DataMemory.scala 19:20]
  assign memory__T_1_data = io_testerDataWrite;
  assign memory__T_1_addr = io_testerAddress;
  assign memory__T_1_mask = 1'h1;
  assign memory__T_1_en = io_testerEnable & io_testerWriteEnable;
  assign memory__T_3_data = io_dataWrite;
  assign memory__T_3_addr = io_address;
  assign memory__T_3_mask = 1'h1;
  assign memory__T_3_en = io_testerEnable ? 1'h0 : io_writeEnable;
  assign io_dataRead = io_testerEnable ? 32'h0 : _GEN_11; // @[DataMemory.scala 24:17 DataMemory.scala 31:17 DataMemory.scala 35:19]
  assign io_testerDataRead = io_testerEnable ? _GEN_5 : 32'h0; // @[DataMemory.scala 23:23 DataMemory.scala 27:25 DataMemory.scala 32:23]
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
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 65536; initvar = initvar+1)
    memory[initvar] = _RAND_0[31:0];
`endif // RANDOMIZE_MEM_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    if(memory__T_1_en & memory__T_1_mask) begin
      memory[memory__T_1_addr] <= memory__T_1_data; // @[DataMemory.scala 19:20]
    end
    if(memory__T_3_en & memory__T_3_mask) begin
      memory[memory__T_3_addr] <= memory__T_3_data; // @[DataMemory.scala 19:20]
    end
  end
endmodule
module ProgramMemory(
  input         clock,
  input  [15:0] io_address,
  output [31:0] io_instructionRead,
  input         io_testerEnable,
  input  [15:0] io_testerAddress,
  output [31:0] io_testerDataRead,
  input         io_testerWriteEnable,
  input  [31:0] io_testerDataWrite
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
  reg [31:0] memory [0:65535]; // @[ProgramMemory.scala 17:19]
  wire [31:0] memory__T_data; // @[ProgramMemory.scala 17:19]
  wire [15:0] memory__T_addr; // @[ProgramMemory.scala 17:19]
  wire [31:0] memory__T_2_data; // @[ProgramMemory.scala 17:19]
  wire [15:0] memory__T_2_addr; // @[ProgramMemory.scala 17:19]
  wire [31:0] memory__T_1_data; // @[ProgramMemory.scala 17:19]
  wire [15:0] memory__T_1_addr; // @[ProgramMemory.scala 17:19]
  wire  memory__T_1_mask; // @[ProgramMemory.scala 17:19]
  wire  memory__T_1_en; // @[ProgramMemory.scala 17:19]
  wire [31:0] _GEN_5 = io_testerWriteEnable ? io_testerDataWrite : memory__T_data; // @[ProgramMemory.scala 23:32]
  assign memory__T_addr = io_testerAddress;
  assign memory__T_data = memory[memory__T_addr]; // @[ProgramMemory.scala 17:19]
  assign memory__T_2_addr = io_address;
  assign memory__T_2_data = memory[memory__T_2_addr]; // @[ProgramMemory.scala 17:19]
  assign memory__T_1_data = io_testerDataWrite;
  assign memory__T_1_addr = io_testerAddress;
  assign memory__T_1_mask = 1'h1;
  assign memory__T_1_en = io_testerEnable & io_testerWriteEnable;
  assign io_instructionRead = io_testerEnable ? 32'h0 : memory__T_2_data; // @[ProgramMemory.scala 22:24 ProgramMemory.scala 29:24]
  assign io_testerDataRead = io_testerEnable ? _GEN_5 : 32'h0; // @[ProgramMemory.scala 21:23 ProgramMemory.scala 25:25 ProgramMemory.scala 30:23]
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
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 65536; initvar = initvar+1)
    memory[initvar] = _RAND_0[31:0];
`endif // RANDOMIZE_MEM_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    if(memory__T_1_en & memory__T_1_mask) begin
      memory[memory__T_1_addr] <= memory__T_1_data; // @[ProgramMemory.scala 17:19]
    end
  end
endmodule
module RegisterFile(
  input         clock,
  input  [11:0] io_aSel,
  input  [11:0] io_bSel,
  input  [31:0] io_writeData,
  input  [3:0]  io_writeSel,
  input         io_writeEnable,
  output [31:0] io_a,
  output [31:0] io_b
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] registers_0; // @[RegisterFile.scala 17:22]
  reg [31:0] registers_1; // @[RegisterFile.scala 17:22]
  reg [31:0] registers_2; // @[RegisterFile.scala 17:22]
  reg [31:0] registers_3; // @[RegisterFile.scala 17:22]
  reg [31:0] registers_4; // @[RegisterFile.scala 17:22]
  reg [31:0] registers_5; // @[RegisterFile.scala 17:22]
  reg [31:0] registers_6; // @[RegisterFile.scala 17:22]
  reg [31:0] registers_7; // @[RegisterFile.scala 17:22]
  reg [31:0] registers_8; // @[RegisterFile.scala 17:22]
  reg [31:0] registers_9; // @[RegisterFile.scala 17:22]
  reg [31:0] registers_10; // @[RegisterFile.scala 17:22]
  reg [31:0] registers_11; // @[RegisterFile.scala 17:22]
  reg [31:0] registers_12; // @[RegisterFile.scala 17:22]
  reg [31:0] registers_13; // @[RegisterFile.scala 17:22]
  reg [31:0] registers_14; // @[RegisterFile.scala 17:22]
  reg [31:0] registers_15; // @[RegisterFile.scala 17:22]
  wire [31:0] _GEN_1 = 4'h1 == io_aSel[3:0] ? registers_1 : registers_0; // @[RegisterFile.scala 20:8]
  wire [31:0] _GEN_2 = 4'h2 == io_aSel[3:0] ? registers_2 : _GEN_1; // @[RegisterFile.scala 20:8]
  wire [31:0] _GEN_3 = 4'h3 == io_aSel[3:0] ? registers_3 : _GEN_2; // @[RegisterFile.scala 20:8]
  wire [31:0] _GEN_4 = 4'h4 == io_aSel[3:0] ? registers_4 : _GEN_3; // @[RegisterFile.scala 20:8]
  wire [31:0] _GEN_5 = 4'h5 == io_aSel[3:0] ? registers_5 : _GEN_4; // @[RegisterFile.scala 20:8]
  wire [31:0] _GEN_6 = 4'h6 == io_aSel[3:0] ? registers_6 : _GEN_5; // @[RegisterFile.scala 20:8]
  wire [31:0] _GEN_7 = 4'h7 == io_aSel[3:0] ? registers_7 : _GEN_6; // @[RegisterFile.scala 20:8]
  wire [31:0] _GEN_8 = 4'h8 == io_aSel[3:0] ? registers_8 : _GEN_7; // @[RegisterFile.scala 20:8]
  wire [31:0] _GEN_9 = 4'h9 == io_aSel[3:0] ? registers_9 : _GEN_8; // @[RegisterFile.scala 20:8]
  wire [31:0] _GEN_10 = 4'ha == io_aSel[3:0] ? registers_10 : _GEN_9; // @[RegisterFile.scala 20:8]
  wire [31:0] _GEN_11 = 4'hb == io_aSel[3:0] ? registers_11 : _GEN_10; // @[RegisterFile.scala 20:8]
  wire [31:0] _GEN_12 = 4'hc == io_aSel[3:0] ? registers_12 : _GEN_11; // @[RegisterFile.scala 20:8]
  wire [31:0] _GEN_13 = 4'hd == io_aSel[3:0] ? registers_13 : _GEN_12; // @[RegisterFile.scala 20:8]
  wire [31:0] _GEN_14 = 4'he == io_aSel[3:0] ? registers_14 : _GEN_13; // @[RegisterFile.scala 20:8]
  wire [31:0] _GEN_17 = 4'h1 == io_bSel[3:0] ? registers_1 : registers_0; // @[RegisterFile.scala 21:8]
  wire [31:0] _GEN_18 = 4'h2 == io_bSel[3:0] ? registers_2 : _GEN_17; // @[RegisterFile.scala 21:8]
  wire [31:0] _GEN_19 = 4'h3 == io_bSel[3:0] ? registers_3 : _GEN_18; // @[RegisterFile.scala 21:8]
  wire [31:0] _GEN_20 = 4'h4 == io_bSel[3:0] ? registers_4 : _GEN_19; // @[RegisterFile.scala 21:8]
  wire [31:0] _GEN_21 = 4'h5 == io_bSel[3:0] ? registers_5 : _GEN_20; // @[RegisterFile.scala 21:8]
  wire [31:0] _GEN_22 = 4'h6 == io_bSel[3:0] ? registers_6 : _GEN_21; // @[RegisterFile.scala 21:8]
  wire [31:0] _GEN_23 = 4'h7 == io_bSel[3:0] ? registers_7 : _GEN_22; // @[RegisterFile.scala 21:8]
  wire [31:0] _GEN_24 = 4'h8 == io_bSel[3:0] ? registers_8 : _GEN_23; // @[RegisterFile.scala 21:8]
  wire [31:0] _GEN_25 = 4'h9 == io_bSel[3:0] ? registers_9 : _GEN_24; // @[RegisterFile.scala 21:8]
  wire [31:0] _GEN_26 = 4'ha == io_bSel[3:0] ? registers_10 : _GEN_25; // @[RegisterFile.scala 21:8]
  wire [31:0] _GEN_27 = 4'hb == io_bSel[3:0] ? registers_11 : _GEN_26; // @[RegisterFile.scala 21:8]
  wire [31:0] _GEN_28 = 4'hc == io_bSel[3:0] ? registers_12 : _GEN_27; // @[RegisterFile.scala 21:8]
  wire [31:0] _GEN_29 = 4'hd == io_bSel[3:0] ? registers_13 : _GEN_28; // @[RegisterFile.scala 21:8]
  wire [31:0] _GEN_30 = 4'he == io_bSel[3:0] ? registers_14 : _GEN_29; // @[RegisterFile.scala 21:8]
  assign io_a = 4'hf == io_aSel[3:0] ? registers_15 : _GEN_14; // @[RegisterFile.scala 20:8]
  assign io_b = 4'hf == io_bSel[3:0] ? registers_15 : _GEN_30; // @[RegisterFile.scala 21:8]
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
  registers_0 = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  registers_1 = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  registers_2 = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  registers_3 = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  registers_4 = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  registers_5 = _RAND_5[31:0];
  _RAND_6 = {1{`RANDOM}};
  registers_6 = _RAND_6[31:0];
  _RAND_7 = {1{`RANDOM}};
  registers_7 = _RAND_7[31:0];
  _RAND_8 = {1{`RANDOM}};
  registers_8 = _RAND_8[31:0];
  _RAND_9 = {1{`RANDOM}};
  registers_9 = _RAND_9[31:0];
  _RAND_10 = {1{`RANDOM}};
  registers_10 = _RAND_10[31:0];
  _RAND_11 = {1{`RANDOM}};
  registers_11 = _RAND_11[31:0];
  _RAND_12 = {1{`RANDOM}};
  registers_12 = _RAND_12[31:0];
  _RAND_13 = {1{`RANDOM}};
  registers_13 = _RAND_13[31:0];
  _RAND_14 = {1{`RANDOM}};
  registers_14 = _RAND_14[31:0];
  _RAND_15 = {1{`RANDOM}};
  registers_15 = _RAND_15[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (io_writeEnable) begin
      if (4'h0 == io_writeSel) begin
        registers_0 <= io_writeData;
      end
    end
    if (io_writeEnable) begin
      if (4'h1 == io_writeSel) begin
        registers_1 <= io_writeData;
      end
    end
    if (io_writeEnable) begin
      if (4'h2 == io_writeSel) begin
        registers_2 <= io_writeData;
      end
    end
    if (io_writeEnable) begin
      if (4'h3 == io_writeSel) begin
        registers_3 <= io_writeData;
      end
    end
    if (io_writeEnable) begin
      if (4'h4 == io_writeSel) begin
        registers_4 <= io_writeData;
      end
    end
    if (io_writeEnable) begin
      if (4'h5 == io_writeSel) begin
        registers_5 <= io_writeData;
      end
    end
    if (io_writeEnable) begin
      if (4'h6 == io_writeSel) begin
        registers_6 <= io_writeData;
      end
    end
    if (io_writeEnable) begin
      if (4'h7 == io_writeSel) begin
        registers_7 <= io_writeData;
      end
    end
    if (io_writeEnable) begin
      if (4'h8 == io_writeSel) begin
        registers_8 <= io_writeData;
      end
    end
    if (io_writeEnable) begin
      if (4'h9 == io_writeSel) begin
        registers_9 <= io_writeData;
      end
    end
    if (io_writeEnable) begin
      if (4'ha == io_writeSel) begin
        registers_10 <= io_writeData;
      end
    end
    if (io_writeEnable) begin
      if (4'hb == io_writeSel) begin
        registers_11 <= io_writeData;
      end
    end
    if (io_writeEnable) begin
      if (4'hc == io_writeSel) begin
        registers_12 <= io_writeData;
      end
    end
    if (io_writeEnable) begin
      if (4'hd == io_writeSel) begin
        registers_13 <= io_writeData;
      end
    end
    if (io_writeEnable) begin
      if (4'he == io_writeSel) begin
        registers_14 <= io_writeData;
      end
    end
    if (io_writeEnable) begin
      if (4'hf == io_writeSel) begin
        registers_15 <= io_writeData;
      end
    end
  end
endmodule
module ControlUnit(
  input  [3:0] io_instruction,
  output       io_regWriteEnable,
  output [1:0] io_aluOp,
  output       io_aluSrc,
  output       io_memToReg,
  output       io_memWriteEnable
);
  wire  _T = 4'h4 == io_instruction; // @[Conditional.scala 37:30]
  wire  _T_1 = 4'h3 == io_instruction; // @[Conditional.scala 37:30]
  wire  _T_2 = 4'h5 == io_instruction; // @[Conditional.scala 37:30]
  wire  _T_3 = 4'h6 == io_instruction; // @[Conditional.scala 37:30]
  wire  _T_4 = 4'h7 == io_instruction; // @[Conditional.scala 37:30]
  wire  _T_5 = 4'ha == io_instruction; // @[Conditional.scala 37:30]
  wire [1:0] _GEN_0 = _T_5 ? 2'h2 : 2'h0; // @[Conditional.scala 39:67]
  wire [1:0] _GEN_1 = _T_4 ? 2'h2 : _GEN_0; // @[Conditional.scala 39:67]
  wire [1:0] _GEN_2 = _T_3 ? 2'h2 : _GEN_1; // @[Conditional.scala 39:67]
  wire [1:0] _GEN_3 = _T_2 ? 2'h1 : _GEN_2; // @[Conditional.scala 39:67]
  wire [1:0] _GEN_4 = _T_1 ? 2'h0 : _GEN_3; // @[Conditional.scala 39:67]
  wire  _GEN_13 = _T_2 | _T_5; // @[Conditional.scala 39:67]
  wire  _GEN_14 = _T_1 | _GEN_13; // @[Conditional.scala 39:67]
  assign io_regWriteEnable = _T | _GEN_14; // @[ControlUnit.scala 58:21 ControlUnit.scala 60:33 ControlUnit.scala 61:33 ControlUnit.scala 62:33 ControlUnit.scala 63:33]
  assign io_aluOp = _T ? 2'h0 : _GEN_4; // @[ControlUnit.scala 37:12 ControlUnit.scala 39:24 ControlUnit.scala 40:24 ControlUnit.scala 41:24 ControlUnit.scala 42:24 ControlUnit.scala 43:24 ControlUnit.scala 44:24]
  assign io_aluSrc = _T ? 1'h0 : _T_1; // @[ControlUnit.scala 48:13 ControlUnit.scala 50:25 ControlUnit.scala 51:25 ControlUnit.scala 52:25 ControlUnit.scala 53:25 ControlUnit.scala 54:25 ControlUnit.scala 55:25]
  assign io_memToReg = 4'h1 == io_instruction; // @[ControlUnit.scala 76:15 ControlUnit.scala 78:25 ControlUnit.scala 79:27 ControlUnit.scala 80:26 ControlUnit.scala 81:28 ControlUnit.scala 82:27]
  assign io_memWriteEnable = 4'h2 == io_instruction; // @[ControlUnit.scala 85:21 ControlUnit.scala 87:31]
endmodule
module ALU(
  input  [31:0] io_x,
  input  [31:0] io_y,
  input  [1:0]  io_sel,
  output [31:0] io_result,
  output        io_zero
);
  wire  _T = 2'h0 == io_sel; // @[Conditional.scala 37:30]
  wire [31:0] _T_2 = io_x + io_y; // @[ALU.scala 22:33]
  wire  _T_3 = 2'h1 == io_sel; // @[Conditional.scala 37:30]
  wire [63:0] _T_4 = io_x * io_y; // @[ALU.scala 23:33]
  wire  _T_5 = 2'h2 == io_sel; // @[Conditional.scala 37:30]
  wire [31:0] _T_7 = io_x - io_y; // @[ALU.scala 24:33]
  wire [31:0] _GEN_0 = _T_5 ? _T_7 : 32'h0; // @[Conditional.scala 39:67]
  wire [63:0] _GEN_1 = _T_3 ? _T_4 : {{32'd0}, _GEN_0}; // @[Conditional.scala 39:67]
  wire [63:0] _GEN_2 = _T ? {{32'd0}, _T_2} : _GEN_1; // @[Conditional.scala 40:58]
  assign io_result = _GEN_2[31:0]; // @[ALU.scala 19:13 ALU.scala 22:25 ALU.scala 23:25 ALU.scala 24:25]
  assign io_zero = io_result == 32'h0; // @[ALU.scala 26:11]
endmodule
module CPUTop(
  input         clock,
  input         reset,
  input         io_run,
  output        io_done,
  input         io_testerDataMemEnable,
  input  [15:0] io_testerDataMemAddress,
  output [31:0] io_testerDataMemDataRead,
  input         io_testerDataMemWriteEnable,
  input  [31:0] io_testerDataMemDataWrite,
  input         io_testerProgMemEnable,
  input  [15:0] io_testerProgMemAddress,
  output [31:0] io_testerProgMemDataRead,
  input         io_testerProgMemWriteEnable,
  input  [31:0] io_testerProgMemDataWrite
);
  wire  ProgramCounter_clock; // @[CPUTop.scala 28:38]
  wire  ProgramCounter_reset; // @[CPUTop.scala 28:38]
  wire  ProgramCounter_io_run; // @[CPUTop.scala 28:38]
  wire  ProgramCounter_io_stop; // @[CPUTop.scala 28:38]
  wire  ProgramCounter_io_jump; // @[CPUTop.scala 28:38]
  wire [15:0] ProgramCounter_io_programCounterJump; // @[CPUTop.scala 28:38]
  wire [15:0] ProgramCounter_io_programCounter; // @[CPUTop.scala 28:38]
  wire  DataMemory_clock; // @[CPUTop.scala 29:34]
  wire [15:0] DataMemory_io_address; // @[CPUTop.scala 29:34]
  wire  DataMemory_io_writeEnable; // @[CPUTop.scala 29:34]
  wire [31:0] DataMemory_io_dataWrite; // @[CPUTop.scala 29:34]
  wire [31:0] DataMemory_io_dataRead; // @[CPUTop.scala 29:34]
  wire  DataMemory_io_testerEnable; // @[CPUTop.scala 29:34]
  wire [15:0] DataMemory_io_testerAddress; // @[CPUTop.scala 29:34]
  wire [31:0] DataMemory_io_testerDataRead; // @[CPUTop.scala 29:34]
  wire  DataMemory_io_testerWriteEnable; // @[CPUTop.scala 29:34]
  wire [31:0] DataMemory_io_testerDataWrite; // @[CPUTop.scala 29:34]
  wire  ProgramMemory_clock; // @[CPUTop.scala 30:37]
  wire [15:0] ProgramMemory_io_address; // @[CPUTop.scala 30:37]
  wire [31:0] ProgramMemory_io_instructionRead; // @[CPUTop.scala 30:37]
  wire  ProgramMemory_io_testerEnable; // @[CPUTop.scala 30:37]
  wire [15:0] ProgramMemory_io_testerAddress; // @[CPUTop.scala 30:37]
  wire [31:0] ProgramMemory_io_testerDataRead; // @[CPUTop.scala 30:37]
  wire  ProgramMemory_io_testerWriteEnable; // @[CPUTop.scala 30:37]
  wire [31:0] ProgramMemory_io_testerDataWrite; // @[CPUTop.scala 30:37]
  wire  RegisterFile_clock; // @[CPUTop.scala 31:36]
  wire [11:0] RegisterFile_io_aSel; // @[CPUTop.scala 31:36]
  wire [11:0] RegisterFile_io_bSel; // @[CPUTop.scala 31:36]
  wire [31:0] RegisterFile_io_writeData; // @[CPUTop.scala 31:36]
  wire [3:0] RegisterFile_io_writeSel; // @[CPUTop.scala 31:36]
  wire  RegisterFile_io_writeEnable; // @[CPUTop.scala 31:36]
  wire [31:0] RegisterFile_io_a; // @[CPUTop.scala 31:36]
  wire [31:0] RegisterFile_io_b; // @[CPUTop.scala 31:36]
  wire [3:0] ControlUnit_io_instruction; // @[CPUTop.scala 32:35]
  wire  ControlUnit_io_regWriteEnable; // @[CPUTop.scala 32:35]
  wire [1:0] ControlUnit_io_aluOp; // @[CPUTop.scala 32:35]
  wire  ControlUnit_io_aluSrc; // @[CPUTop.scala 32:35]
  wire  ControlUnit_io_memToReg; // @[CPUTop.scala 32:35]
  wire  ControlUnit_io_memWriteEnable; // @[CPUTop.scala 32:35]
  wire [31:0] ALU_io_x; // @[CPUTop.scala 33:27]
  wire [31:0] ALU_io_y; // @[CPUTop.scala 33:27]
  wire [1:0] ALU_io_sel; // @[CPUTop.scala 33:27]
  wire [31:0] ALU_io_result; // @[CPUTop.scala 33:27]
  wire  ALU_io_zero; // @[CPUTop.scala 33:27]
  wire  _T_4 = ProgramMemory_io_instructionRead[3:0] == 4'h9; // @[CPUTop.scala 105:18]
  wire  _T_5 = ProgramMemory_io_instructionRead[3:0] == 4'h8; // @[CPUTop.scala 106:25]
  wire  _T_7 = ProgramMemory_io_instructionRead[3:0] == 4'h0; // @[CPUTop.scala 108:24]
  wire  _T_8 = ProgramMemory_io_instructionRead[3:0] == 4'h1; // @[CPUTop.scala 108:41]
  wire  _T_9 = _T_7 | _T_8; // @[CPUTop.scala 108:31]
  wire  _T_10 = ProgramMemory_io_instructionRead[3:0] == 4'h2; // @[CPUTop.scala 108:58]
  wire  _T_11 = _T_9 | _T_10; // @[CPUTop.scala 108:48]
  wire [7:0] _GEN_0 = _T_11 ? ProgramMemory_io_instructionRead[11:4] : ProgramMemory_io_instructionRead[11:4]; // @[CPUTop.scala 108:66]
  wire [9:0] _GEN_1 = _T_11 ? ProgramMemory_io_instructionRead[21:12] : ProgramMemory_io_instructionRead[21:12]; // @[CPUTop.scala 108:66]
  wire [9:0] _GEN_2 = _T_11 ? 10'h0 : ProgramMemory_io_instructionRead[31:22]; // @[CPUTop.scala 108:66]
  wire [7:0] _GEN_3 = _T_5 ? {{4'd0}, ProgramMemory_io_instructionRead[7:4]} : _GEN_0; // @[CPUTop.scala 106:33]
  wire [9:0] _GEN_4 = _T_5 ? 10'h0 : _GEN_1; // @[CPUTop.scala 106:33]
  wire [9:0] _GEN_5 = _T_5 ? 10'h0 : _GEN_2; // @[CPUTop.scala 106:33]
  wire [7:0] _GEN_6 = _T_4 ? 8'h0 : _GEN_3; // @[CPUTop.scala 105:27]
  wire [9:0] _GEN_7 = _T_4 ? 10'h0 : _GEN_4; // @[CPUTop.scala 105:27]
  wire [9:0] _GEN_8 = _T_4 ? 10'h0 : _GEN_5; // @[CPUTop.scala 105:27]
  wire  _T_18 = 4'h8 == ProgramMemory_io_instructionRead[3:0]; // @[Conditional.scala 37:30]
  wire  _T_19 = 4'h7 == ProgramMemory_io_instructionRead[3:0]; // @[Conditional.scala 37:30]
  wire  _T_21 = 4'h6 == ProgramMemory_io_instructionRead[3:0]; // @[Conditional.scala 37:30]
  wire  _T_22 = ~ALU_io_zero; // @[CPUTop.scala 131:24]
  wire  _GEN_9 = _T_21 & _T_22; // @[Conditional.scala 39:67]
  wire  _GEN_10 = _T_19 ? 1'h0 : _GEN_9; // @[Conditional.scala 39:67]
  ProgramCounter ProgramCounter ( // @[CPUTop.scala 28:38]
    .clock(ProgramCounter_clock),
    .reset(ProgramCounter_reset),
    .io_run(ProgramCounter_io_run),
    .io_stop(ProgramCounter_io_stop),
    .io_jump(ProgramCounter_io_jump),
    .io_programCounterJump(ProgramCounter_io_programCounterJump),
    .io_programCounter(ProgramCounter_io_programCounter)
  );
  DataMemory DataMemory ( // @[CPUTop.scala 29:34]
    .clock(DataMemory_clock),
    .io_address(DataMemory_io_address),
    .io_writeEnable(DataMemory_io_writeEnable),
    .io_dataWrite(DataMemory_io_dataWrite),
    .io_dataRead(DataMemory_io_dataRead),
    .io_testerEnable(DataMemory_io_testerEnable),
    .io_testerAddress(DataMemory_io_testerAddress),
    .io_testerDataRead(DataMemory_io_testerDataRead),
    .io_testerWriteEnable(DataMemory_io_testerWriteEnable),
    .io_testerDataWrite(DataMemory_io_testerDataWrite)
  );
  ProgramMemory ProgramMemory ( // @[CPUTop.scala 30:37]
    .clock(ProgramMemory_clock),
    .io_address(ProgramMemory_io_address),
    .io_instructionRead(ProgramMemory_io_instructionRead),
    .io_testerEnable(ProgramMemory_io_testerEnable),
    .io_testerAddress(ProgramMemory_io_testerAddress),
    .io_testerDataRead(ProgramMemory_io_testerDataRead),
    .io_testerWriteEnable(ProgramMemory_io_testerWriteEnable),
    .io_testerDataWrite(ProgramMemory_io_testerDataWrite)
  );
  RegisterFile RegisterFile ( // @[CPUTop.scala 31:36]
    .clock(RegisterFile_clock),
    .io_aSel(RegisterFile_io_aSel),
    .io_bSel(RegisterFile_io_bSel),
    .io_writeData(RegisterFile_io_writeData),
    .io_writeSel(RegisterFile_io_writeSel),
    .io_writeEnable(RegisterFile_io_writeEnable),
    .io_a(RegisterFile_io_a),
    .io_b(RegisterFile_io_b)
  );
  ControlUnit ControlUnit ( // @[CPUTop.scala 32:35]
    .io_instruction(ControlUnit_io_instruction),
    .io_regWriteEnable(ControlUnit_io_regWriteEnable),
    .io_aluOp(ControlUnit_io_aluOp),
    .io_aluSrc(ControlUnit_io_aluSrc),
    .io_memToReg(ControlUnit_io_memToReg),
    .io_memWriteEnable(ControlUnit_io_memWriteEnable)
  );
  ALU ALU ( // @[CPUTop.scala 33:27]
    .io_x(ALU_io_x),
    .io_y(ALU_io_y),
    .io_sel(ALU_io_sel),
    .io_result(ALU_io_result),
    .io_zero(ALU_io_zero)
  );
  assign io_done = 1'h0; // @[CPUTop.scala 36:11]
  assign io_testerDataMemDataRead = DataMemory_io_testerDataRead; // @[CPUTop.scala 146:28]
  assign io_testerProgMemDataRead = ProgramMemory_io_testerDataRead; // @[CPUTop.scala 140:28]
  assign ProgramCounter_clock = clock;
  assign ProgramCounter_reset = reset;
  assign ProgramCounter_io_run = io_run; // @[CPUTop.scala 40:25]
  assign ProgramCounter_io_stop = io_done; // @[CPUTop.scala 41:26]
  assign ProgramCounter_io_jump = _T_18 | _GEN_10; // @[CPUTop.scala 42:26]
  assign ProgramCounter_io_programCounterJump = {{8'd0}, _GEN_6}; // @[CPUTop.scala 43:40]
  assign DataMemory_clock = clock;
  assign DataMemory_io_address = ALU_io_result[15:0]; // @[CPUTop.scala 75:25]
  assign DataMemory_io_writeEnable = ControlUnit_io_memWriteEnable; // @[CPUTop.scala 76:29]
  assign DataMemory_io_dataWrite = RegisterFile_io_b; // @[CPUTop.scala 77:27]
  assign DataMemory_io_testerEnable = io_testerDataMemEnable; // @[CPUTop.scala 148:30]
  assign DataMemory_io_testerAddress = io_testerDataMemAddress; // @[CPUTop.scala 145:31]
  assign DataMemory_io_testerWriteEnable = io_testerDataMemWriteEnable; // @[CPUTop.scala 149:35]
  assign DataMemory_io_testerDataWrite = io_testerDataMemDataWrite; // @[CPUTop.scala 147:33]
  assign ProgramMemory_clock = clock;
  assign ProgramMemory_io_address = ProgramCounter_io_programCounter; // @[CPUTop.scala 46:28]
  assign ProgramMemory_io_testerEnable = io_testerProgMemEnable; // @[CPUTop.scala 142:33]
  assign ProgramMemory_io_testerAddress = io_testerProgMemAddress; // @[CPUTop.scala 139:34]
  assign ProgramMemory_io_testerWriteEnable = io_testerProgMemWriteEnable; // @[CPUTop.scala 143:38]
  assign ProgramMemory_io_testerDataWrite = io_testerProgMemDataWrite; // @[CPUTop.scala 141:36]
  assign RegisterFile_clock = clock;
  assign RegisterFile_io_aSel = {{2'd0}, _GEN_7}; // @[CPUTop.scala 58:24]
  assign RegisterFile_io_bSel = {{2'd0}, _GEN_8}; // @[CPUTop.scala 59:24]
  assign RegisterFile_io_writeData = ControlUnit_io_memToReg ? DataMemory_io_dataRead : ALU_io_result; // @[CPUTop.scala 60:29]
  assign RegisterFile_io_writeSel = _GEN_6[3:0]; // @[CPUTop.scala 61:28]
  assign RegisterFile_io_writeEnable = ControlUnit_io_regWriteEnable; // @[CPUTop.scala 62:31]
  assign ControlUnit_io_instruction = ProgramMemory_io_instructionRead[3:0]; // @[CPUTop.scala 48:30]
  assign ALU_io_x = RegisterFile_io_a; // @[CPUTop.scala 70:12]
  assign ALU_io_y = ControlUnit_io_aluSrc ? {{22'd0}, _GEN_8} : RegisterFile_io_b; // @[CPUTop.scala 71:12]
  assign ALU_io_sel = ControlUnit_io_aluOp; // @[CPUTop.scala 72:14]
endmodule
