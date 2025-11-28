// 32-bit arithmetic right shift (new for checkpoint2)
module sra32(in, shamt, out);
  input  [31:0] in;
  input  [4:0]  shamt;
  output [31:0] out;
  wire [31:0] s1, s2, s3, s4;
  wire sign = in[31];

  mux2_32 mux_i0(in,  {{1{sign}},  in[31:1]},    shamt[0], s1);
  mux2_32 mux_i1(s1,  {{2{sign}},  s1[31:2]},   shamt[1], s2);
  mux2_32 mux_i2(s2,  {{4{sign}},  s2[31:4]},   shamt[2], s3);
  mux2_32 mux_i3(s3,  {{8{sign}},  s3[31:8]},   shamt[3], s4);
  mux2_32 mux_i4(s4,  {{16{sign}}, s4[31:16]},  shamt[4], out);
endmodule

