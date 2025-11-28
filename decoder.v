// decoder (new for checkpoint2)
module alu_decoder(op, dec_add, dec_sub, dec_and, dec_or, dec_sll, dec_sra);
  input  [4:0] op;
  output dec_add, dec_sub, dec_and, dec_or, dec_sll, dec_sra;

  wire n4, n3, n2, n1, n0;
  not gate0(n4, op[4]);
  not gate1(n3, op[3]);
  not gate2(n2, op[2]);
  not gate3(n1, op[1]);
  not gate4(n0, op[0]);

  and gate5(dec_add, n4, n3, n2, n1, n0);
  and gate6(dec_sub, n4, n3, n2, n1, op[0]);
  and gate7(dec_and, n4, n3, n2, op[1], n0);
  and gate8(dec_or,  n4, n3, n2, op[1], op[0]);
  and gate9(dec_sll, n4, n3, op[2], n1, n0);
  and gate10(dec_sra,n4, n3, op[2], n1, op[0]);
endmodule
