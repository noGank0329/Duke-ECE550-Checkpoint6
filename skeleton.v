module skeleton(
    resetn, 
	ps2_clock, ps2_data, 										// ps2 related I/O
	debug_data_in, debug_addr, leds, 						// extra debugging ports
	lcd_data, lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon, // LCD info
	seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8,		// seven segements
	VGA_CLK,   														//	VGA Clock
	VGA_HS,															//	VGA H_SYNC
	VGA_VS,															//	VGA V_SYNC
	VGA_BLANK,														//	VGA BLANK
	VGA_SYNC,														//	VGA SYNC
	VGA_R,   														//	VGA Red[7:0]
	VGA_G,	 														//	VGA Green[7:0]
	VGA_B,															//	VGA Blue[7:0]
	CLOCK_50);  													// 50 MHz clock
		
	////////////////////////	VGA	////////////////////////////
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK;				//	VGA BLANK
	output			VGA_SYNC;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[7:0]
	output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
	input				CLOCK_50;

	////////////////////////	PS2	////////////////////////////
	input 			resetn;
	inout 			ps2_data, ps2_clock;
	
	////////////////////////	LCD and Seven Segment	////////////////////////////
	output 			   lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon;
	output 	[7:0] 	leds, lcd_data;
	output 	[6:0] 	seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8;

	// 你现在的 processor_skeleton 并没有把 debug 信号拉出来，
	// 先简单接成 0，防止悬空
	output 	[31:0] 	debug_data_in;
	output   [11:0]   debug_addr;
	assign debug_data_in = 32'b0;
	assign debug_addr    = 12'b0;
	
	////////////////////////	内部信号 ////////////////////////////
	wire clock;
	assign clock = CLOCK_50;   // 先不用 pll，直接 50MHz 给你的分频模块

	wire [7:0]	 ps2_key_data;
	wire			 ps2_key_pressed;
	wire	[7:0]	 ps2_out;	

	// 如果你以后想把这些分频时钟引出来调试，可以用这些 wire 接 processor_skeleton 的输出
	wire imem_clock, dmem_clock, processor_clock, regfile_clock;

	//////////////////////// 你的 CPU skeleton ////////////////////////
	// 现在 processor_skeleton 内部已经例化了 imem/dmem/regfile/processor
	// 顶层只需要给它 clock 和 reset
	processor_skeleton my_cpu_skel (
		.clock         (clock),
		.reset         (~resetn),        // 你里面是同步 reset，这里取反
		.imem_clock    (imem_clock),     // 目前没用到，只是接出来以免综合优化掉
		.dmem_clock    (dmem_clock),
		.processor_clock(processor_clock),
		.regfile_clock (regfile_clock)
	);
	
	//////////////////////// 键盘 ////////////////////////
	PS2_Interface myps2(
		clock, resetn,
		ps2_clock, ps2_data,
		ps2_key_data, ps2_key_pressed, ps2_out
	);
	
	//////////////////////// LCD ////////////////////////
	lcd mylcd(
		clock, ~resetn, 1'b1,
		ps2_out, lcd_data, lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon
	);
	
	//////////////////////// 数码管 ////////////////////////
	Hexadecimal_To_Seven_Segment hex1(ps2_out[3:0], seg1);
	Hexadecimal_To_Seven_Segment hex2(ps2_out[7:4], seg2);
	Hexadecimal_To_Seven_Segment hex3(4'b0, seg3);
	Hexadecimal_To_Seven_Segment hex4(4'b0, seg4);
	Hexadecimal_To_Seven_Segment hex5(4'b0, seg5);
	Hexadecimal_To_Seven_Segment hex6(4'b0, seg6);
	Hexadecimal_To_Seven_Segment hex7(4'b0, seg7);
	Hexadecimal_To_Seven_Segment hex8(4'b0, seg8);
	
	// 调试 LED（你可以以后改成显示分频时钟 / flag 等）
	assign leds = 8'b00101011;
		
	//////////////////////// VGA ////////////////////////
	wire DLY_RST;
	wire VGA_CTRL_CLK;
	wire AUD_CTRL_CLK;

	Reset_Delay			r0	(.iCLK(CLOCK_50), .oRESET(DLY_RST));
	VGA_Audio_PLL 		p1	(
		.areset (~DLY_RST),
		.inclk0 (CLOCK_50),
		.c0     (VGA_CTRL_CLK),
		.c1     (AUD_CTRL_CLK),
		.c2     (VGA_CLK)
	);
	vga_controller vga_ins(
		.iRST_n   (DLY_RST),
		.iVGA_CLK (VGA_CLK),
		.oBLANK_n (VGA_BLANK),
		.oHS      (VGA_HS),
		.oVS      (VGA_VS),
		.b_data   (VGA_B),
		.g_data   (VGA_G),
		.r_data   (VGA_R)
	);
	
endmodule
