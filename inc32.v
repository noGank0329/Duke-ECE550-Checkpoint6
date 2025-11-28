// 32-bit incrementer
module inc32(in, out);
    input [31:0] in;
    output [31:0] out;

    wire [31:0] c;
    assign c[0] = 1'b1;

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin: add1
            xor x1(out[i], in[i], c[i]);
            if (i < 31) begin: carry
                and a1(c[i+1], in[i], c[i]);
            end
        end
    endgenerate
endmodule
