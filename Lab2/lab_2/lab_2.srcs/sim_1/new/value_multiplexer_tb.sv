`timescale 1ns / 1ps

module value_multiplexer_tb;

    logic [15:0] hex_value;
    logic [15:0] decimal_value;
    logic        select;
    logic [15:0] display_value;

    value_multiplexer uut (
        .hex_value     (hex_value),
        .decimal_value (decimal_value),
        .select        (select),
        .display_value (display_value)
    );

    initial begin
        hex_value     = 16'hA5A5;
        decimal_value = 16'h5A5A;
        select        = 1'b0;
        #20;

        select = 1'b1;
        #20;

        hex_value     = 16'h5A5A;
        decimal_value = 16'hA5A5;
        #20;

        select = 1'b0;
        #20;

        $finish;
    end

endmodule