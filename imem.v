//  Instruction Memory (IMEM)
//  4K x 32-bit, initialized from imem.mif
module imem (
    input  [11:0] address,
    input         clock,
    output [31:0] q
);
    altsyncram imem_component (
        .address_a       (address),
        .clock0          (clock),
        .q_a             (q),

        .data_a          (32'b0),
        .wren_a          (1'b0),
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
        imem_component.operation_mode = "ROM",
        imem_component.width_a = 32,
        imem_component.widthad_a = 12,
        imem_component.numwords_a = 4096,
        imem_component.outdata_reg_a = "UNREGISTERED",
        imem_component.init_file = "imem.mif",
        imem_component.intended_device_family = "Cyclone IV E";
endmodule
