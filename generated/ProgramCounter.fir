;buildInfoPackage: chisel3, version: 3.3.2, scalaVersion: 2.12.11, sbtVersion: 1.3.10
circuit ProgramCounter : 
  module ProgramCounter : 
    input clock : Clock
    input reset : UInt<1>
    output io : {flip stop : UInt<1>, flip jump : UInt<1>, flip run : UInt<1>, flip programCounterJump : UInt<16>, programCounter : UInt<16>}
    
    reg counterReg : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[ProgramCounter.scala 15:27]
    node _T = eq(io.jump, UInt<1>("h00")) @[ProgramCounter.scala 16:18]
    node _T_1 = and(io.run, _T) @[ProgramCounter.scala 16:15]
    node _T_2 = eq(io.stop, UInt<1>("h00")) @[ProgramCounter.scala 16:30]
    node _T_3 = and(_T_1, _T_2) @[ProgramCounter.scala 16:27]
    when _T_3 : @[ProgramCounter.scala 16:39]
      node _T_4 = add(counterReg, UInt<1>("h01")) @[ProgramCounter.scala 17:30]
      node _T_5 = tail(_T_4, 1) @[ProgramCounter.scala 17:30]
      counterReg <= _T_5 @[ProgramCounter.scala 17:16]
      skip @[ProgramCounter.scala 16:39]
    else : @[ProgramCounter.scala 18:46]
      node _T_6 = and(io.run, io.jump) @[ProgramCounter.scala 18:22]
      node _T_7 = eq(io.stop, UInt<1>("h00")) @[ProgramCounter.scala 18:36]
      node _T_8 = and(_T_6, _T_7) @[ProgramCounter.scala 18:33]
      when _T_8 : @[ProgramCounter.scala 18:46]
        counterReg <= io.programCounterJump @[ProgramCounter.scala 19:16]
        skip @[ProgramCounter.scala 18:46]
    io.programCounter <= counterReg @[ProgramCounter.scala 21:21]
    
