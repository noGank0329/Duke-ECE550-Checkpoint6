// 32-bit logical left shift (new for checkpoint2)
module sll32(in, shamt, out);
  input  [31:0] in;
  input  [4:0]  shamt;
  output [31:0] out;
  wire [31:0] s1, s2, s3, s4;

  mux2_32 mux_i0(in,  {in[30:0], 1'b0},    shamt[0], s1);
  mux2_32 mux_i1(s1,  {s1[29:0], 2'b00},   shamt[1], s2);
  mux2_32 mux_i2(s2,  {s2[27:0], 4'b0000}, shamt[2], s3);
  mux2_32 mux_i3(s3,  {s3[23:0], 8'h00},   shamt[3], s4);
  mux2_32 mux_i4(s4,  {s4[15:0], 16'h0000},shamt[4], out);
endmodule


