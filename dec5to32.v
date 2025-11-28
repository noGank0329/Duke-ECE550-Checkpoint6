// 5-to-32 decoder with enable
module dec5to32(address, enable, out);

   input  [4:0] address;   
   input        enable;    
   output [31:0] out;      
	
   wire n4, n3, n2, n1, n0;
   not gate0(n4, address[4]);
   not gate1(n3, address[3]);
   not gate2(n2, address[2]);
   not gate3(n1, address[1]);
   not gate4(n0, address[0]);

   wire [7:0] upper;
   and u0(upper[0], n4, n3, n2);
   and u1(upper[1], n4, n3, address[2]);
   and u2(upper[2], n4, address[3], n2);
   and u3(upper[3], n4, address[3], address[2]);
   and u4(upper[4], address[4], n3, n2);
   and u5(upper[5], address[4], n3, address[2]);
   and u6(upper[6], address[4], address[3], n2);
   and u7(upper[7], address[4], address[3], address[2]);

   wire [3:0] lower;
   and l0(lower[0], n1, n0);
   and l1(lower[1], n1, address[0]);
   and l2(lower[2], address[1], n0);
   and l3(lower[3], address[1], address[0]);

   genvar i, j;
   generate
      for (i=0; i<8; i=i+1) begin: upper_loop
         for (j=0; j<4; j=j+1) begin: lower_loop
            wire m;
            and a1(m, upper[i], lower[j]);
            and a2(out[i*4+j], enable, m);
         end
      end
   endgenerate

endmodule
