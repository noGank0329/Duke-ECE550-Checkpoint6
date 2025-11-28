module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt,
           data_result, isNotEqual, isLessThan, overflow);

   input  [31:0] data_operandA, data_operandB;
   input  [4:0]  ctrl_ALUopcode, ctrl_shiftamt;
   output [31:0] data_result;
   output        isNotEqual, isLessThan, overflow;

   wire [31:0] add_res, sub_res;

   // and/or wire (new for checkpoint2)
   wire [31:0] and_res, or_res;

   // sll/sra wire (new for checkpoint2)
   wire [31:0] sll_res, sra_res;

   // decoder wire (new for checkpoint2)
   wire dec_add, dec_sub, dec_and, dec_or, dec_sll, dec_sra;

   csa_32bit add_unit(data_operandA, data_operandB, 1'b0, add_res, );
   csa_32bit sub_unit(data_operandA, ~data_operandB, 1'b1, sub_res, );

   // and/or (new for checkpoint2)
   and32 and_i(data_operandA, data_operandB, and_res);
   or32  or_i (data_operandA, data_operandB, or_res);

   // sll/sra (new for checkpoint2)
   sll32 sll_i(data_operandA, ctrl_shiftamt, sll_res);
   sra32 sra_i(data_operandA, ctrl_shiftamt, sra_res);

   // decoder (new for checkpoint2)
   alu_decoder dec(
      .op(ctrl_ALUopcode),
      .dec_add(dec_add),
      .dec_sub(dec_sub),
      .dec_and(dec_and),
      .dec_or(dec_or),
      .dec_sll(dec_sll),
      .dec_sra(dec_sra)
   );

   // choose result (new for checkpoint2)
   genvar j;
   generate
      for (j=0; j<32; j=j+1) begin: result_sel
         wire w_add, w_sub, w_and, w_or, w_sll, w_sra;
         and and_i0(w_add, dec_add, add_res[j]);
         and and_i1(w_sub, dec_sub, sub_res[j]);
         and and_i2(w_and, dec_and, and_res[j]);
         and and_i3(w_or,  dec_or,  or_res[j]);
         and and_i4(w_sll, dec_sll, sll_res[j]);
         and and_i5(w_sra, dec_sra, sra_res[j]);
         or  or_i0(data_result[j], w_add, w_sub, w_and, w_or, w_sll, w_sra);
      end
   endgenerate

   // overflow
   wire signA   = data_operandA[31];
   wire signB   = data_operandB[31];
   wire signAdd = add_res[31];
   wire signSub = sub_res[31];

   wire t1, t2, t3, t4, t5, t6, t7, t8;
   xor gate0(t1, signA, signB);
   xor gate1(t2, signA, signAdd);
   xor gate2(t3, signA, signSub);
   not gate3(t4, t1);
   and gate4(t5, t4, t2);
   and gate5(t6, t1, t3);
   and gate6(t7, dec_add, t5);
   and gate7(t8, dec_sub, t6);
   or  gate8(overflow, t7, t8);

   // isNotEqual (new for checkpoint2)
   wire [15:0] or16;
   genvar i;
   generate
      for (i=0; i<16; i=i+1) begin: or_stage1
         or or_i0(or16[i], sub_res[2*i], sub_res[2*i+1]);
      end
   endgenerate

   wire [7:0] or8;
   generate
      for (i=0; i<8; i=i+1) begin: or_stage2
         or or_i1(or8[i], or16[2*i], or16[2*i+1]);
      end
   endgenerate

   wire [3:0] or4;
   generate
      for (i=0; i<4; i=i+1) begin: or_stage3
         or or_i2(or4[i], or8[2*i], or8[2*i+1]);
      end
   endgenerate

   wire [1:0] or2;
   generate
      for (i=0; i<2; i=i+1) begin: or_stage4
         or or_i3(or2[i], or4[2*i], or4[2*i+1]);
      end
   endgenerate

   or g_final(isNotEqual, or2[0], or2[1]);

   // isLessThan (new for checkpoint2)
   xor g_lt(isLessThan, signSub, t6);

endmodule
