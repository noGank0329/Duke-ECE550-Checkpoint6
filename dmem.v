//  Data Memory (DMEM)
//  4K x 32-bit, initialized from dmem.mif
module dmem (
    input  [11:0] address,
    input         clock,
    input  [31:0] data,
    input         wren,
    output [31:0] q
);
    altsyncram dmem_component (
        .address_a       (address),
        .clock0          (clock),
        .data_a          (data),
        .wren_a          (wren),
        .q_a             (q),

        .rden_a          (1'b1),
        .wren_b          (),
        .rden_b          (),
        .address_b       (),
        .data_b          (),
        .clock1          (),
        .clocken0        (1'b1),
        .clocken1        (1'b1),
        .clocken2        (1'b1),
        .clocken3        (1'b1),
        .aclr0           (1'b0),
        .aclr1           (1'b0),
        .byteena_a       (1'b1),
        .byteena_b       (1'b1),
        .addressstall_a  (1'b0),
        .addressstall_b  (1'b0),
        .q_b             (),
        .eccstatus       ()
    );

    defparam
        dmem_component.operation_mode = "SINGLE_PORT",
        dmem_component.width_a = 32,
        dmem_component.widthad_a = 12,
        dmem_component.numwords_a = 4096,
        dmem_component.outdata_reg_a = "UNREGISTERED",
        dmem_component.init_file = "dmem.mif",
        dmem_component.intended_device_family = "Cyclone IV E";
endmodule
