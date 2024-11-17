;buildInfoPackage: chisel3, version: 3.3.2, scalaVersion: 2.12.11, sbtVersion: 1.3.10
circuit CPUTop : 
  module ProgramCounter : 
    input clock : Clock
    input reset : Reset
    output io : {flip run : UInt<1>, flip stop : UInt<1>, flip jump : UInt<1>, flip programCounterJump : UInt<16>, programCounter : UInt<16>}
    
    reg _T : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[ProgramCounter.scala 17:35]
    node _T_1 = eq(io.jump, UInt<1>("h00")) @[ProgramCounter.scala 18:18]
    node _T_2 = and(io.run, _T_1) @[ProgramCounter.scala 18:15]
    node _T_3 = eq(io.stop, UInt<1>("h00")) @[ProgramCounter.scala 18:30]
    node _T_4 = and(_T_2, _T_3) @[ProgramCounter.scala 18:27]
    when _T_4 : @[ProgramCounter.scala 18:39]
      node _T_5 = add(_T, UInt<1>("h01")) @[ProgramCounter.scala 19:30]
      node _T_6 = tail(_T_5, 1) @[ProgramCounter.scala 19:30]
      _T <= _T_6 @[ProgramCounter.scala 19:16]
      skip @[ProgramCounter.scala 18:39]
    else : @[ProgramCounter.scala 20:46]
      node _T_7 = and(io.run, io.jump) @[ProgramCounter.scala 20:22]
      node _T_8 = eq(io.stop, UInt<1>("h00")) @[ProgramCounter.scala 20:36]
      node _T_9 = and(_T_7, _T_8) @[ProgramCounter.scala 20:33]
      when _T_9 : @[ProgramCounter.scala 20:46]
        _T <= io.programCounterJump @[ProgramCounter.scala 21:16]
        skip @[ProgramCounter.scala 20:46]
    io.programCounter <= _T @[ProgramCounter.scala 23:21]
    
  module DataMemory : 
    input clock : Clock
    input reset : Reset
    output io : {flip address : UInt<16>, flip writeEnable : UInt<1>, flip dataWrite : UInt<32>, dataRead : UInt<32>, flip testerEnable : UInt<1>, flip testerAddress : UInt<16>, testerDataRead : UInt<32>, flip testerWriteEnable : UInt<1>, flip testerDataWrite : UInt<32>}
    
    cmem memory : UInt<32>[65536] @[DataMemory.scala 19:20]
    when io.testerEnable : @[DataMemory.scala 21:24]
      read mport _T = memory[io.testerAddress], clock @[DataMemory.scala 23:37]
      io.testerDataRead <= _T @[DataMemory.scala 23:23]
      io.dataRead <= UInt<32>("h00") @[DataMemory.scala 24:17]
      when io.testerWriteEnable : @[DataMemory.scala 25:32]
        write mport _T_1 = memory[io.testerAddress], clock
        _T_1 <= io.testerDataWrite
        io.testerDataRead <= io.testerDataWrite @[DataMemory.scala 27:25]
        skip @[DataMemory.scala 25:32]
      skip @[DataMemory.scala 21:24]
    else : @[DataMemory.scala 29:16]
      read mport _T_2 = memory[io.address], clock @[DataMemory.scala 31:31]
      io.dataRead <= _T_2 @[DataMemory.scala 31:17]
      io.testerDataRead <= UInt<32>("h00") @[DataMemory.scala 32:23]
      when io.writeEnable : @[DataMemory.scala 33:26]
        write mport _T_3 = memory[io.address], clock
        _T_3 <= io.dataWrite
        io.dataRead <= io.dataWrite @[DataMemory.scala 35:19]
        skip @[DataMemory.scala 33:26]
      skip @[DataMemory.scala 29:16]
    
  module ProgramMemory : 
    input clock : Clock
    input reset : Reset
    output io : {flip address : UInt<16>, instructionRead : UInt<32>, flip testerEnable : UInt<1>, flip testerAddress : UInt<16>, testerDataRead : UInt<32>, flip testerWriteEnable : UInt<1>, flip testerDataWrite : UInt<32>}
    
    cmem memory : UInt<32>[65536] @[ProgramMemory.scala 17:19]
    when io.testerEnable : @[ProgramMemory.scala 19:24]
      read mport _T = memory[io.testerAddress], clock @[ProgramMemory.scala 21:37]
      io.testerDataRead <= _T @[ProgramMemory.scala 21:23]
      io.instructionRead <= UInt<32>("h00") @[ProgramMemory.scala 22:24]
      when io.testerWriteEnable : @[ProgramMemory.scala 23:32]
        write mport _T_1 = memory[io.testerAddress], clock
        _T_1 <= io.testerDataWrite
        io.testerDataRead <= io.testerDataWrite @[ProgramMemory.scala 25:25]
        skip @[ProgramMemory.scala 23:32]
      skip @[ProgramMemory.scala 19:24]
    else : @[ProgramMemory.scala 27:16]
      read mport _T_2 = memory[io.address], clock @[ProgramMemory.scala 29:38]
      io.instructionRead <= _T_2 @[ProgramMemory.scala 29:24]
      io.testerDataRead <= UInt<32>("h00") @[ProgramMemory.scala 30:23]
      skip @[ProgramMemory.scala 27:16]
    
  module RegisterFile : 
    input clock : Clock
    input reset : Reset
    output io : {flip aSel : UInt<12>, flip bSel : UInt<12>, flip writeData : UInt<32>, flip writeSel : UInt<4>, flip writeEnable : UInt<1>, a : UInt<32>, b : UInt<32>}
    
    reg registers : UInt<32>[16], clock @[RegisterFile.scala 17:22]
    node _T = bits(io.aSel, 3, 0)
    io.a <= registers[_T] @[RegisterFile.scala 20:8]
    node _T_1 = bits(io.bSel, 3, 0)
    io.b <= registers[_T_1] @[RegisterFile.scala 21:8]
    when io.writeEnable : @[RegisterFile.scala 23:24]
      registers[io.writeSel] <= io.writeData @[RegisterFile.scala 24:28]
      skip @[RegisterFile.scala 23:24]
    
  module ControlUnit : 
    input clock : Clock
    input reset : Reset
    output io : {flip opCode : UInt<4>, regWriteEnable : UInt<1>, aluOp : UInt<2>, aluSrc : UInt<1>, memToReg : UInt<1>, memWriteEnable : UInt<1>}
    
    io.aluOp <= UInt<1>("h00") @[ControlUnit.scala 37:12]
    node _T = eq(UInt<4>("h04"), io.opCode) @[Conditional.scala 37:30]
    when _T : @[Conditional.scala 40:58]
      io.aluOp <= UInt<1>("h00") @[ControlUnit.scala 39:24]
      skip @[Conditional.scala 40:58]
    else : @[Conditional.scala 39:67]
      node _T_1 = eq(UInt<4>("h03"), io.opCode) @[Conditional.scala 37:30]
      when _T_1 : @[Conditional.scala 39:67]
        io.aluOp <= UInt<1>("h00") @[ControlUnit.scala 40:24]
        skip @[Conditional.scala 39:67]
      else : @[Conditional.scala 39:67]
        node _T_2 = eq(UInt<4>("h05"), io.opCode) @[Conditional.scala 37:30]
        when _T_2 : @[Conditional.scala 39:67]
          io.aluOp <= UInt<1>("h01") @[ControlUnit.scala 41:24]
          skip @[Conditional.scala 39:67]
        else : @[Conditional.scala 39:67]
          node _T_3 = eq(UInt<4>("h06"), io.opCode) @[Conditional.scala 37:30]
          when _T_3 : @[Conditional.scala 39:67]
            io.aluOp <= UInt<2>("h02") @[ControlUnit.scala 42:24]
            skip @[Conditional.scala 39:67]
          else : @[Conditional.scala 39:67]
            node _T_4 = eq(UInt<4>("h07"), io.opCode) @[Conditional.scala 37:30]
            when _T_4 : @[Conditional.scala 39:67]
              io.aluOp <= UInt<2>("h02") @[ControlUnit.scala 43:24]
              skip @[Conditional.scala 39:67]
            else : @[Conditional.scala 39:67]
              node _T_5 = eq(UInt<4>("h0a"), io.opCode) @[Conditional.scala 37:30]
              when _T_5 : @[Conditional.scala 39:67]
                io.aluOp <= UInt<2>("h02") @[ControlUnit.scala 44:24]
                skip @[Conditional.scala 39:67]
    io.aluSrc <= UInt<1>("h00") @[ControlUnit.scala 48:13]
    node _T_6 = eq(UInt<4>("h04"), io.opCode) @[Conditional.scala 37:30]
    when _T_6 : @[Conditional.scala 40:58]
      io.aluSrc <= UInt<1>("h00") @[ControlUnit.scala 50:25]
      skip @[Conditional.scala 40:58]
    else : @[Conditional.scala 39:67]
      node _T_7 = eq(UInt<4>("h03"), io.opCode) @[Conditional.scala 37:30]
      when _T_7 : @[Conditional.scala 39:67]
        io.aluSrc <= UInt<1>("h01") @[ControlUnit.scala 51:25]
        skip @[Conditional.scala 39:67]
      else : @[Conditional.scala 39:67]
        node _T_8 = eq(UInt<4>("h05"), io.opCode) @[Conditional.scala 37:30]
        when _T_8 : @[Conditional.scala 39:67]
          io.aluSrc <= UInt<1>("h00") @[ControlUnit.scala 52:25]
          skip @[Conditional.scala 39:67]
        else : @[Conditional.scala 39:67]
          node _T_9 = eq(UInt<4>("h06"), io.opCode) @[Conditional.scala 37:30]
          when _T_9 : @[Conditional.scala 39:67]
            io.aluSrc <= UInt<1>("h00") @[ControlUnit.scala 53:25]
            skip @[Conditional.scala 39:67]
          else : @[Conditional.scala 39:67]
            node _T_10 = eq(UInt<4>("h07"), io.opCode) @[Conditional.scala 37:30]
            when _T_10 : @[Conditional.scala 39:67]
              io.aluSrc <= UInt<1>("h00") @[ControlUnit.scala 54:25]
              skip @[Conditional.scala 39:67]
            else : @[Conditional.scala 39:67]
              node _T_11 = eq(UInt<4>("h0a"), io.opCode) @[Conditional.scala 37:30]
              when _T_11 : @[Conditional.scala 39:67]
                io.aluSrc <= UInt<1>("h00") @[ControlUnit.scala 55:25]
                skip @[Conditional.scala 39:67]
    io.regWriteEnable <= UInt<1>("h00") @[ControlUnit.scala 58:21]
    node _T_12 = eq(UInt<4>("h00"), io.opCode) @[Conditional.scala 37:30]
    when _T_12 : @[Conditional.scala 40:58]
      io.regWriteEnable <= UInt<1>("h01") @[ControlUnit.scala 60:33]
      skip @[Conditional.scala 40:58]
    else : @[Conditional.scala 39:67]
      node _T_13 = eq(UInt<4>("h01"), io.opCode) @[Conditional.scala 37:30]
      when _T_13 : @[Conditional.scala 39:67]
        io.regWriteEnable <= UInt<1>("h01") @[ControlUnit.scala 61:33]
        skip @[Conditional.scala 39:67]
      else : @[Conditional.scala 39:67]
        node _T_14 = eq(UInt<4>("h04"), io.opCode) @[Conditional.scala 37:30]
        when _T_14 : @[Conditional.scala 39:67]
          io.regWriteEnable <= UInt<1>("h01") @[ControlUnit.scala 62:33]
          skip @[Conditional.scala 39:67]
        else : @[Conditional.scala 39:67]
          node _T_15 = eq(UInt<4>("h03"), io.opCode) @[Conditional.scala 37:30]
          when _T_15 : @[Conditional.scala 39:67]
            io.regWriteEnable <= UInt<1>("h01") @[ControlUnit.scala 63:33]
            skip @[Conditional.scala 39:67]
          else : @[Conditional.scala 39:67]
            node _T_16 = eq(UInt<4>("h05"), io.opCode) @[Conditional.scala 37:30]
            when _T_16 : @[Conditional.scala 39:67]
              io.regWriteEnable <= UInt<1>("h01") @[ControlUnit.scala 64:33]
              skip @[Conditional.scala 39:67]
            else : @[Conditional.scala 39:67]
              node _T_17 = eq(UInt<4>("h0a"), io.opCode) @[Conditional.scala 37:30]
              when _T_17 : @[Conditional.scala 39:67]
                io.regWriteEnable <= UInt<1>("h01") @[ControlUnit.scala 65:33]
                skip @[Conditional.scala 39:67]
    io.memToReg <= UInt<1>("h00") @[ControlUnit.scala 78:15]
    node _T_18 = eq(UInt<4>("h01"), io.opCode) @[Conditional.scala 37:30]
    when _T_18 : @[Conditional.scala 40:58]
      io.memToReg <= UInt<1>("h01") @[ControlUnit.scala 80:25]
      skip @[Conditional.scala 40:58]
    else : @[Conditional.scala 39:67]
      node _T_19 = eq(UInt<4>("h03"), io.opCode) @[Conditional.scala 37:30]
      when _T_19 : @[Conditional.scala 39:67]
        io.memToReg <= UInt<1>("h00") @[ControlUnit.scala 81:27]
        skip @[Conditional.scala 39:67]
      else : @[Conditional.scala 39:67]
        node _T_20 = eq(UInt<4>("h04"), io.opCode) @[Conditional.scala 37:30]
        when _T_20 : @[Conditional.scala 39:67]
          io.memToReg <= UInt<1>("h00") @[ControlUnit.scala 82:26]
          skip @[Conditional.scala 39:67]
        else : @[Conditional.scala 39:67]
          node _T_21 = eq(UInt<4>("h05"), io.opCode) @[Conditional.scala 37:30]
          when _T_21 : @[Conditional.scala 39:67]
            io.memToReg <= UInt<1>("h00") @[ControlUnit.scala 83:28]
            skip @[Conditional.scala 39:67]
          else : @[Conditional.scala 39:67]
            node _T_22 = eq(UInt<4>("h0a"), io.opCode) @[Conditional.scala 37:30]
            when _T_22 : @[Conditional.scala 39:67]
              io.memToReg <= UInt<1>("h00") @[ControlUnit.scala 84:27]
              skip @[Conditional.scala 39:67]
    io.memWriteEnable <= UInt<1>("h00") @[ControlUnit.scala 87:21]
    node _T_23 = eq(UInt<4>("h02"), io.opCode) @[Conditional.scala 37:30]
    when _T_23 : @[Conditional.scala 40:58]
      io.memWriteEnable <= UInt<1>("h01") @[ControlUnit.scala 89:31]
      skip @[Conditional.scala 40:58]
    
  module ALU : 
    input clock : Clock
    input reset : Reset
    output io : {flip x : UInt<32>, flip y : UInt<32>, flip sel : UInt<2>, result : UInt<32>, zero : UInt<1>, less_than : UInt<1>}
    
    io.result <= UInt<1>("h00") @[ALU.scala 20:13]
    node _T = eq(UInt<1>("h00"), io.sel) @[Conditional.scala 37:30]
    when _T : @[Conditional.scala 40:58]
      node _T_1 = add(io.x, io.y) @[ALU.scala 23:33]
      node _T_2 = tail(_T_1, 1) @[ALU.scala 23:33]
      io.result <= _T_2 @[ALU.scala 23:25]
      skip @[Conditional.scala 40:58]
    else : @[Conditional.scala 39:67]
      node _T_3 = eq(UInt<1>("h01"), io.sel) @[Conditional.scala 37:30]
      when _T_3 : @[Conditional.scala 39:67]
        node _T_4 = mul(io.x, io.y) @[ALU.scala 24:33]
        io.result <= _T_4 @[ALU.scala 24:25]
        skip @[Conditional.scala 39:67]
      else : @[Conditional.scala 39:67]
        node _T_5 = eq(UInt<2>("h02"), io.sel) @[Conditional.scala 37:30]
        when _T_5 : @[Conditional.scala 39:67]
          node _T_6 = sub(io.x, io.y) @[ALU.scala 25:33]
          node _T_7 = tail(_T_6, 1) @[ALU.scala 25:33]
          io.result <= _T_7 @[ALU.scala 25:25]
          skip @[Conditional.scala 39:67]
    node _T_8 = eq(io.result, UInt<1>("h00")) @[ALU.scala 27:25]
    io.zero <= _T_8 @[ALU.scala 27:11]
    node _T_9 = lt(io.x, io.y) @[ALU.scala 28:25]
    io.less_than <= _T_9 @[ALU.scala 28:16]
    
  module CPUTop : 
    input clock : Clock
    input reset : UInt<1>
    output io : {flip run : UInt<1>, done : UInt<1>, flip testerDataMemEnable : UInt<1>, flip testerDataMemAddress : UInt<16>, testerDataMemDataRead : UInt<32>, flip testerDataMemWriteEnable : UInt<1>, flip testerDataMemDataWrite : UInt<32>, flip testerProgMemEnable : UInt<1>, flip testerProgMemAddress : UInt<16>, testerProgMemDataRead : UInt<32>, flip testerProgMemWriteEnable : UInt<1>, flip testerProgMemDataWrite : UInt<32>}
    
    inst ProgramCounter of ProgramCounter @[CPUTop.scala 28:38]
    ProgramCounter.clock <= clock
    ProgramCounter.reset <= reset
    inst DataMemory of DataMemory @[CPUTop.scala 29:34]
    DataMemory.clock <= clock
    DataMemory.reset <= reset
    inst ProgramMemory of ProgramMemory @[CPUTop.scala 30:37]
    ProgramMemory.clock <= clock
    ProgramMemory.reset <= reset
    inst RegisterFile of RegisterFile @[CPUTop.scala 31:36]
    RegisterFile.clock <= clock
    RegisterFile.reset <= reset
    inst ControlUnit of ControlUnit @[CPUTop.scala 32:35]
    ControlUnit.clock <= clock
    ControlUnit.reset <= reset
    inst ALU of ALU @[CPUTop.scala 33:27]
    ALU.clock <= clock
    ALU.reset <= reset
    node _T = bits(ProgramMemory.io.instructionRead, 31, 28) @[CPUTop.scala 89:32]
    node _T_1 = bits(ProgramMemory.io.instructionRead, 27, 20) @[CPUTop.scala 90:32]
    node _T_2 = bits(ProgramMemory.io.instructionRead, 19, 10) @[CPUTop.scala 91:32]
    node _T_3 = bits(ProgramMemory.io.instructionRead, 9, 0) @[CPUTop.scala 92:32]
    node _T_4 = eq(_T, UInt<4>("h09")) @[CPUTop.scala 38:22]
    io.done <= _T_4 @[CPUTop.scala 38:11]
    ProgramCounter.io.run <= io.run @[CPUTop.scala 41:25]
    ProgramCounter.io.stop <= io.done @[CPUTop.scala 42:26]
    wire _T_5 : UInt<1> @[CPUTop.scala 103:19]
    _T_5 <= UInt<1>("h00") @[CPUTop.scala 104:9]
    node _T_6 = eq(UInt<4>("h08"), _T) @[Conditional.scala 37:30]
    when _T_6 : @[Conditional.scala 40:58]
      _T_5 <= UInt<1>("h01") @[CPUTop.scala 106:21]
      skip @[Conditional.scala 40:58]
    else : @[Conditional.scala 39:67]
      node _T_7 = eq(UInt<3>("h07"), _T) @[Conditional.scala 37:30]
      when _T_7 : @[Conditional.scala 39:67]
        _T_5 <= ALU.io.less_than @[CPUTop.scala 107:21]
        skip @[Conditional.scala 39:67]
      else : @[Conditional.scala 39:67]
        node _T_8 = eq(UInt<3>("h06"), _T) @[Conditional.scala 37:30]
        when _T_8 : @[Conditional.scala 39:67]
          node _T_9 = eq(ALU.io.zero, UInt<1>("h00")) @[CPUTop.scala 108:24]
          _T_5 <= _T_9 @[CPUTop.scala 108:21]
          skip @[Conditional.scala 39:67]
    ProgramCounter.io.jump <= _T_5 @[CPUTop.scala 43:26]
    ProgramCounter.io.programCounterJump <= _T_1 @[CPUTop.scala 44:40]
    ProgramMemory.io.address <= ProgramCounter.io.programCounter @[CPUTop.scala 47:28]
    ControlUnit.io.opCode <= _T @[CPUTop.scala 49:25]
    node _T_10 = eq(_T, UInt<4>("h00")) @[CPUTop.scala 55:16]
    node _T_11 = mux(_T_10, _T_2, ALU.io.result) @[CPUTop.scala 55:8]
    node _T_12 = mux(ControlUnit.io.memToReg, DataMemory.io.dataRead, _T_11) @[CPUTop.scala 53:53]
    RegisterFile.io.aSel <= _T_2 @[CPUTop.scala 61:24]
    RegisterFile.io.bSel <= _T_3 @[CPUTop.scala 62:24]
    RegisterFile.io.writeData <= _T_12 @[CPUTop.scala 63:29]
    RegisterFile.io.writeSel <= _T_1 @[CPUTop.scala 64:28]
    RegisterFile.io.writeEnable <= ControlUnit.io.regWriteEnable @[CPUTop.scala 65:31]
    node _T_13 = mux(ControlUnit.io.aluSrc, _T_3, RegisterFile.io.b) @[CPUTop.scala 68:42]
    ALU.io.x <= RegisterFile.io.a @[CPUTop.scala 73:12]
    ALU.io.y <= _T_13 @[CPUTop.scala 74:12]
    ALU.io.sel <= ControlUnit.io.aluOp @[CPUTop.scala 75:14]
    DataMemory.io.address <= _T_1 @[CPUTop.scala 78:25]
    DataMemory.io.writeEnable <= ControlUnit.io.memWriteEnable @[CPUTop.scala 79:29]
    DataMemory.io.dataWrite <= RegisterFile.io.a @[CPUTop.scala 80:27]
    ProgramMemory.io.testerAddress <= io.testerProgMemAddress @[CPUTop.scala 116:34]
    io.testerProgMemDataRead <= ProgramMemory.io.testerDataRead @[CPUTop.scala 117:28]
    ProgramMemory.io.testerDataWrite <= io.testerProgMemDataWrite @[CPUTop.scala 118:36]
    ProgramMemory.io.testerEnable <= io.testerProgMemEnable @[CPUTop.scala 119:33]
    ProgramMemory.io.testerWriteEnable <= io.testerProgMemWriteEnable @[CPUTop.scala 120:38]
    DataMemory.io.testerAddress <= io.testerDataMemAddress @[CPUTop.scala 122:31]
    io.testerDataMemDataRead <= DataMemory.io.testerDataRead @[CPUTop.scala 123:28]
    DataMemory.io.testerDataWrite <= io.testerDataMemDataWrite @[CPUTop.scala 124:33]
    DataMemory.io.testerEnable <= io.testerDataMemEnable @[CPUTop.scala 125:30]
    DataMemory.io.testerWriteEnable <= io.testerDataMemWriteEnable @[CPUTop.scala 126:35]
    
