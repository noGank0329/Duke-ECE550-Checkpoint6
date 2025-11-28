module csa_32bit(A, B, cin, sum, cout);

   input  [31:0] A, B;
   input         cin;
   output [31:0] sum;
   output        cout;

   // lower 16 bits
   wire [15:0] sum_low;
   wire        cout_low;
   adder16 adder_low(A[15:0], B[15:0], cin, sum_low, cout_low);

   // upper 16 bits (carry select)
   wire [15:0] sum_high0, sum_high1;
   wire        cout_high0, cout_high1;
   adder16 adder_high0(A[31:16], B[31:16], 1'b0, sum_high0, cout_high0);
   adder16 adder_high1(A[31:16], B[31:16], 1'b1, sum_high1, cout_high1);

   // select correct result based on cout_low
   assign sum[15:0]  = sum_low;
   assign sum[31:16] = cout_low ? sum_high1 : sum_high0;
   assign cout       = cout_low ? cout_high1 : cout_high0;

endmodule
