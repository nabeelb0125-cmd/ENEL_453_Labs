`timescale 1ns / 1ps

module value_multiplexer (
    input  logic [15:0] hex_value,
    input  logic [15:0] decimal_value,
    input  logic        select,
    output logic [15:0] display_value
);

    always_comb begin
        if (select == 1'b0)
            display_value = hex_value;
        else
            display_value = decimal_value;
    end

endmodule