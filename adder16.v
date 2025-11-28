module adder16(A, B, cin, sum, cout);

   input  [15:0] A, B;
   input         cin;
   output [15:0] sum;
   output        cout;

   wire c1, c2, c3;

   cla_4bit cla0(A[3:0],   B[3:0],   cin,  sum[3:0],   c1, , );
   cla_4bit cla1(A[7:4],   B[7:4],   c1,   sum[7:4],   c2, , );
   cla_4bit cla2(A[11:8],  B[11:8],  c2,   sum[11:8],  c3, , );
   cla_4bit cla3(A[15:12], B[15:12], c3,   sum[15:12], cout, , );

endmodule
