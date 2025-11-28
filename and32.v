// 32-bit AND (new for checkpoint2)
module and32(in1, in2, out);
  input  [31:0] in1, in2;
  output [31:0] out;
  genvar i;
  generate
    for (i=0; i<32; i=i+1) begin: and_loop
      and and_i(out[i], in1[i], in2[i]);
    end
  endgenerate
endmodule
