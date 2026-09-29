`timescale 1ns / 1ps

module multiplexer_tb();

    logic [15:0] input0;
    logic [15:0] input1;
    logic        select;
    logic [15:0] mux_out;

    multiplexer uut (
        .input0  (input0),
        .input1  (input1),
        .select  (select),
        .mux_out (mux_out)
    );

    initial begin

        // First A5 test pattern
        input0 = 16'hA5A5;
        input1 = 16'h5A5A;

        select = 0;
        #100;

        select = 1;
        #100;

        // Change the inputs
        input0 = 16'h5A5A;
        input1 = 16'hA5A5;

        select = 0;
        #100;

        select = 1;
        #100;

        $stop;
    end

endmodule