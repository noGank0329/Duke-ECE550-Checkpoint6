module cla_4bit(A, B, cin, sum, cout, P, G);

   input  [3:0] A, B;
   input        cin;
   output [3:0] sum;
   output       cout, P, G;

   wire [3:0] p, g;
   wire c1, c2, c3;

   // p and g
   xor x0(p[0], A[0], B[0]);
   xor x1(p[1], A[1], B[1]);
   xor x2(p[2], A[2], B[2]);
   xor x3(p[3], A[3], B[3]);

   and a0(g[0], A[0], B[0]);
   and a1(g[1], A[1], B[1]);
   and a2(g[2], A[2], B[2]);
   and a3(g[3], A[3], B[3]);

   // carry
   wire t1, t2, t3, t4, t5, t6, t7, t8, t9, t10;
   and a4(t1, p[0], cin);
   or  o1(c1, g[0], t1);

   and a5(t2, p[1], g[0]);
   and a6(t3, p[1], p[0], cin);
   or  o2(c2, g[1], t2, t3);

   and a7(t4, p[2], g[1]);
   and a8(t5, p[2], p[1], g[0]);
   and a9(t6, p[2], p[1], p[0], cin);
   or  o3(c3, g[2], t4, t5, t6);

   and a10(t7, p[3], g[2]);
   and a11(t8, p[3], p[2], g[1]);
   and a12(t9, p[3], p[2], p[1], g[0]);
   and a13(t10, p[3], p[2], p[1], p[0], cin);
   or  o4(cout, g[3], t7, t8, t9, t10);

   // sum
   xor s0(sum[0], p[0], cin);
   xor s1(sum[1], p[1], c1);
   xor s2(sum[2], p[2], c2);
   xor s3(sum[3], p[3], c3);

   // group
   wire t11, t12;
   and a14(t11, p[0], p[1]);
   and a15(t12, p[2], p[3]);
   and a16(P, t11, t12);

   assign G = cout;

endmodule
