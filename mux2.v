// 1-bit 2:1 mux (new for checkpoint2)
module mux2(in0, in1, sel, out);
  input in0, in1, sel;
  output out;
  wire nsel, a, b;

  not gate0(nsel, sel);
  and gate1(a, in0, nsel);
  and gate2(b, in1, sel);
  or  gate3(out, a, b);
endmodule
