// 32-bit 2:1 mux (new for checkpoint2)
module mux2_32(in0, in1, sel, out);
  input  [31:0] in0, in1;
  input         sel;
  output [31:0] out;
  genvar i;
  generate
    for (i=0; i<32; i=i+1) begin: mux_loop
      mux2 mux_i(in0[i], in1[i], sel, out[i]);
    end
  endgenerate
endmodule
