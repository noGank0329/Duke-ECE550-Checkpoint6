// 32-bit register made of 32 dffe 
module reg32(data, clk, en, clr, q);

   input  [31:0] data;   
   input         clk;    
   input         en;     
   input         clr;    
   output [31:0] q;      

   genvar i;
   generate
      for (i = 0; i < 32; i = i + 1) begin: reg_loop
         dffe_ref bit_reg(q[i], data[i], clk, en, clr);
      end
   endgenerate

endmodule
