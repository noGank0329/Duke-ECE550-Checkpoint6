// 32x32 Register File 
module regfile (
   clock,
   ctrl_writeEnable,
   ctrl_reset, ctrl_writeReg,
   ctrl_readRegA, ctrl_readRegB, data_writeReg,
   data_readRegA, data_readRegB
);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;
   output [31:0] data_readRegA, data_readRegB;

   wire [31:0] write_en;
   dec5to32 dec_write(ctrl_writeReg, ctrl_writeEnable, write_en);

   wire [31:0] reg_out [31:0];

   genvar i;
   generate
      for (i = 0; i < 32; i = i + 1) begin: reg_loop
         if (i == 0) begin
            reg32 r0(32'b0, clock, 1'b0, ctrl_reset, reg_out[i]);
         end else begin
            reg32 rN(data_writeReg, clock, write_en[i], ctrl_reset, reg_out[i]);
         end
      end
   endgenerate

   // read port A
   wire [31:0] selA;
   dec5to32 decA(ctrl_readRegA, 1'b1, selA);
   assign data_readRegA =
      (selA[0]  ? reg_out[0]  : 32'b0) |
      (selA[1]  ? reg_out[1]  : 32'b0) |
      (selA[2]  ? reg_out[2]  : 32'b0) |
      (selA[3]  ? reg_out[3]  : 32'b0) |
      (selA[4]  ? reg_out[4]  : 32'b0) |
      (selA[5]  ? reg_out[5]  : 32'b0) |
      (selA[6]  ? reg_out[6]  : 32'b0) |
      (selA[7]  ? reg_out[7]  : 32'b0) |
      (selA[8]  ? reg_out[8]  : 32'b0) |
      (selA[9]  ? reg_out[9]  : 32'b0) |
      (selA[10] ? reg_out[10] : 32'b0) |
      (selA[11] ? reg_out[11] : 32'b0) |
      (selA[12] ? reg_out[12] : 32'b0) |
      (selA[13] ? reg_out[13] : 32'b0) |
      (selA[14] ? reg_out[14] : 32'b0) |
      (selA[15] ? reg_out[15] : 32'b0) |
      (selA[16] ? reg_out[16] : 32'b0) |
      (selA[17] ? reg_out[17] : 32'b0) |
      (selA[18] ? reg_out[18] : 32'b0) |
      (selA[19] ? reg_out[19] : 32'b0) |
      (selA[20] ? reg_out[20] : 32'b0) |
      (selA[21] ? reg_out[21] : 32'b0) |
      (selA[22] ? reg_out[22] : 32'b0) |
      (selA[23] ? reg_out[23] : 32'b0) |
      (selA[24] ? reg_out[24] : 32'b0) |
      (selA[25] ? reg_out[25] : 32'b0) |
      (selA[26] ? reg_out[26] : 32'b0) |
      (selA[27] ? reg_out[27] : 32'b0) |
      (selA[28] ? reg_out[28] : 32'b0) |
      (selA[29] ? reg_out[29] : 32'b0) |
      (selA[30] ? reg_out[30] : 32'b0) |
      (selA[31] ? reg_out[31] : 32'b0);

   // read port B
   wire [31:0] selB;
   dec5to32 decB(ctrl_readRegB, 1'b1, selB);
   assign data_readRegB =
      (selB[0]  ? reg_out[0]  : 32'b0) |
      (selB[1]  ? reg_out[1]  : 32'b0) |
      (selB[2]  ? reg_out[2]  : 32'b0) |
      (selB[3]  ? reg_out[3]  : 32'b0) |
      (selB[4]  ? reg_out[4]  : 32'b0) |
      (selB[5]  ? reg_out[5]  : 32'b0) |
      (selB[6]  ? reg_out[6]  : 32'b0) |
      (selB[7]  ? reg_out[7]  : 32'b0) |
      (selB[8]  ? reg_out[8]  : 32'b0) |
      (selB[9]  ? reg_out[9]  : 32'b0) |
      (selB[10] ? reg_out[10] : 32'b0) |
      (selB[11] ? reg_out[11] : 32'b0) |
      (selB[12] ? reg_out[12] : 32'b0) |
      (selB[13] ? reg_out[13] : 32'b0) |
      (selB[14] ? reg_out[14] : 32'b0) |
      (selB[15] ? reg_out[15] : 32'b0) |
      (selB[16] ? reg_out[16] : 32'b0) |
      (selB[17] ? reg_out[17] : 32'b0) |
      (selB[18] ? reg_out[18] : 32'b0) |
      (selB[19] ? reg_out[19] : 32'b0) |
      (selB[20] ? reg_out[20] : 32'b0) |
      (selB[21] ? reg_out[21] : 32'b0) |
      (selB[22] ? reg_out[22] : 32'b0) |
      (selB[23] ? reg_out[23] : 32'b0) |
      (selB[24] ? reg_out[24] : 32'b0) |
      (selB[25] ? reg_out[25] : 32'b0) |
      (selB[26] ? reg_out[26] : 32'b0) |
      (selB[27] ? reg_out[27] : 32'b0) |
      (selB[28] ? reg_out[28] : 32'b0) |
      (selB[29] ? reg_out[29] : 32'b0) |
      (selB[30] ? reg_out[30] : 32'b0) |
      (selB[31] ? reg_out[31] : 32'b0);

endmodule
