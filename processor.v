/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                   // I: Data from port B of regfile
);

    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input  [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output        wren;
    input  [31:0] q_dmem;

    // Regfile
    output        ctrl_writeEnable;
    output [4:0]  ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input  [31:0] data_readRegA, data_readRegB;

    /* YOUR CODE STARTS HERE */

    // Program Counter 
    wire [31:0] pc_cur;
	 wire [31:0] pc_plus_1;
    inc32 pc_inc(.in(pc_cur), .out(pc_plus_1));

    // Instruction Decode 
    wire [31:0] inst    = q_imem;
    wire [4:0]  opcode  = inst[31:27];
    wire [4:0]  rd      = inst[26:22];
    wire [4:0]  rs      = inst[21:17];
    wire [4:0]  rt      = inst[16:12];
    wire [4:0]  shamt   = inst[11:7];
    wire [4:0]  aluop   = inst[6:2];
    wire [16:0] imm17   = inst[16:0];
    wire [31:0] imm_ext = { {15{imm17[16]}}, imm17 };

    wire [31:0] op;
    dec5to32 u_dec_op(.address(opcode), .enable(1'b1), .out(op));
    wire isR    = op[0];
    wire isJ    = op[1];
    wire isBNE  = op[2];
    wire isJAL  = op[3];
    wire isJR   = op[4];
    wire isADDI = op[5];
    wire isBLT  = op[6];
    wire isSW   = op[7];
    wire isLW   = op[8];
    wire isSETX = op[21];
    wire isBEX  = op[22];

    wire [31:0] sub;
    dec5to32 u_dec_sub(.address(aluop), .enable(1'b1), .out(sub));

    // Regfile Access 
    assign ctrl_readRegA = isBEX ? 5'd30 : rs;
    assign ctrl_readRegB = (isSW | isBNE | isBLT | isJR) ? rd : rt;

    // ALU Execution 
    wire [31:0] aluA = data_readRegA;
    wire [31:0] aluB = (isADDI | isLW | isSW) ? imm_ext : data_readRegB;
    wire [4:0]  alu_ctrl = isR ? aluop : 5'b00000;

    wire [31:0] aluY;
    wire alu_ne, alu_lt, alu_of;
    alu u_alu(
        .data_operandA (aluA),
        .data_operandB (aluB),
        .ctrl_ALUopcode(alu_ctrl),
        .ctrl_shiftamt (shamt),
        .data_result   (aluY),
        .isNotEqual    (alu_ne),
        .isLessThan    (alu_lt),
        .overflow      (alu_of)
    );

    // Branch / Jump Logic
    wire [31:0] target_T  = {5'b0, inst[26:0]};
    wire [31:0] branch_N  = imm_ext;
	 wire [31:0] pc_branch;

    wire br_ne, br_lt, br_of;
    alu alu_branch_add(
        .data_operandA(pc_plus_1),
        .data_operandB(branch_N),
        .ctrl_ALUopcode(5'b00000),
        .ctrl_shiftamt(5'b00000),
        .data_result(pc_branch),
        .isNotEqual(br_ne),
        .isLessThan(br_lt),
        .overflow(br_of)
    );

    wire [31:0] cmp_ab_res;
    wire cmp_ab_ne, cmp_ab_lt, cmp_ab_of;
    alu alu_cmp_ab(
        .data_operandA(data_readRegA),
        .data_operandB(data_readRegB),
        .ctrl_ALUopcode(5'b00001),
        .ctrl_shiftamt(5'b00000),
        .data_result(cmp_ab_res),
        .isNotEqual(cmp_ab_ne),
        .isLessThan(cmp_ab_lt),
        .overflow(cmp_ab_of)
    );

    wire [31:0] cmp_a0_res;
    wire cmp_a0_ne, cmp_a0_lt, cmp_a0_of;
    alu alu_cmp_a0(
        .data_operandA(data_readRegA),
        .data_operandB(32'b0),
        .ctrl_ALUopcode(5'b00001),
        .ctrl_shiftamt(5'b00000),
        .data_result(cmp_a0_res),
        .isNotEqual(cmp_a0_ne),
        .isLessThan(cmp_a0_lt),
        .overflow(cmp_a0_of)
    );
	 

	 wire [31:0] blt_cmp_res;
	 wire blt_ne, blt_lt, blt_of;
	 alu alu_blt_compare(
		  .data_operandA(data_readRegB),
		  .data_operandB(data_readRegA),
		  .ctrl_ALUopcode(5'b00001),
	     .ctrl_shiftamt(5'b00000),
		  .data_result(blt_cmp_res),
		  .isNotEqual(blt_ne),
	     .isLessThan(blt_lt),
		  .overflow(blt_of)
	 );

	 wire take_blt = isBLT & blt_lt;
    wire take_bne = isBNE & cmp_ab_ne;
    wire take_bex = isBEX & cmp_a0_ne;

    wire [31:0] pc_jump;
	  assign pc_jump = take_blt ? pc_branch :
				 (isJR ? data_readRegB :
				 ((isJ | isJAL) ? target_T :
				 (take_bex ? target_T :
				 (take_bne ? pc_branch : pc_plus_1))));


    reg32 pc_reg(pc_jump, clock, 1'b1, reset, pc_cur);
    assign address_imem = pc_cur[11:0];

    // Memory Access 
    assign address_dmem = aluY[11:0];
    assign data         = data_readRegB;
    assign wren         = isSW;

	 // Writeback 
	 wire        wb_en_raw   = isR | isADDI | isLW | isJAL | isSETX;
	 wire [4:0]  wb_dst_raw  = 
			(isJAL)  ? 5'd31 :
			(isSETX) ? 5'd30 :
			 rd;
	 wire [31:0] wb_data_raw = 
			(isJAL)  ? pc_plus_1 :
			(isSETX) ? target_T :
			(isLW)   ? q_dmem :
			 aluY;

	 // Overflow handling
	 wire is_add  = isR & sub[0];
	 wire is_sub  = isR & sub[1];
	 wire is_addi = isADDI;

	 wire overflow = alu_of & (is_add | is_sub | is_addi);
	 
	 wire [4:0] rstatus_reg = 5'd30;
	 wire [31:0] overflow_type = 
			is_add  ? 32'd1 :
			is_sub  ? 32'd3 :
			is_addi ? 32'd2 : 
                   32'd0;
						 
	 assign ctrl_writeEnable = wb_en_raw | overflow;  
	 assign ctrl_writeReg    = overflow ? rstatus_reg : wb_dst_raw;
	 assign data_writeReg    = overflow ? overflow_type : wb_data_raw;

    wire [31:0] alu_result = aluY;

endmodule