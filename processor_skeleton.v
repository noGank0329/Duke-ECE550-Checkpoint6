module processor_skeleton(clock, reset, imem_clock, dmem_clock, processor_clock, regfile_clock);
    input clock, reset;
    output imem_clock, dmem_clock, processor_clock, regfile_clock;

    // First divider: clock -> clk_div2 = clock/2
    wire clk_div2;
    wire next_clk_div2 = reset ? 1'b0 : ~clk_div2;
    dffe_ref clk_div2_ff(
        .q  (clk_div2),
        .d  (next_clk_div2),
        .clk(clock),
        .en (1'b1),
        .clr(1'b0)
    );

    // Second divider: clk_div2 -> clk_div4 = clock/4
    wire clk_div4;
    wire next_clk_div4 = reset ? 1'b0 : ~clk_div4;
    dffe_ref clk_div4_ff(
        .q  (clk_div4),
        .d  (next_clk_div4),
        .clk(clk_div2),
        .en (1'b1),
        .clr(1'b0)
    );

    // Clock mapping
    assign imem_clock      = clock;
    assign dmem_clock      = clk_div2;
    assign processor_clock = clk_div4;
    assign regfile_clock   = clk_div4;

    /** IMEM **/
    wire [11:0] address_imem;
    wire [31:0] q_imem;
    imem my_imem(
        .address(address_imem),
        .clock  (imem_clock),
        .q      (q_imem)
    );

    /** DMEM **/
    wire [11:0] address_dmem;
    wire [31:0] data;
    wire        wren;
    wire [31:0] q_dmem;
    dmem my_dmem(
        .address(address_dmem),
        .clock  (dmem_clock),
        .data   (data),
        .wren   (wren),
        .q      (q_dmem)
    );

    /** REGFILE **/
    wire        ctrl_writeEnable;
    wire [4:0]  ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    wire [31:0] data_writeReg;
    wire [31:0] data_readRegA, data_readRegB;
    regfile my_regfile(
        regfile_clock,
        ctrl_writeEnable,
        reset,
        ctrl_writeReg,
        ctrl_readRegA,
        ctrl_readRegB,
        data_writeReg,
        data_readRegA,
        data_readRegB
    );

    /** PROCESSOR **/
    processor my_processor(
        processor_clock,
        reset,

        // Imem
        address_imem,
        q_imem,

        // Dmem
        address_dmem,
        data,
        wren,
        q_dmem,

        // Regfile
        ctrl_writeEnable,
        ctrl_writeReg,
        ctrl_readRegA,
        ctrl_readRegB,
        data_writeReg,
        data_readRegA,
        data_readRegB
    );

endmodule
