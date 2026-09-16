`timescale 1ns / 1ps

module lab_1b_top_level_tb;

    parameter CLK_PERIOD = 10;

    // Inputs
    logic        clk;
    logic        reset;
    logic        mux_select;
    logic [15:0] switches_inputs;

    // Outputs
    logic [15:0] led;
    logic CA, CB, CC, CD, CE, CF, CG, DP;
    logic AN1, AN2, AN3, AN4;

    // Unit Under Test
    lab_1b_top_level uut (
        .clk             (clk),
        .reset           (reset),
        .mux_select      (mux_select),
        .switches_inputs (switches_inputs),

        .led              (led),

        .CA               (CA),
        .CB               (CB),
        .CC               (CC),
        .CD               (CD),
        .CE               (CE),
        .CF               (CF),
        .CG               (CG),
        .DP               (DP),

        .AN1              (AN1),
        .AN2              (AN2),
        .AN3              (AN3),
        .AN4              (AN4)
    );

    // Generate a 100 MHz clock
    initial clk = 1'b0;
    always #(CLK_PERIOD / 2) clk = ~clk;

    initial begin
        // Begin in reset
        reset           = 1'b1;
        mux_select      = 1'b0;
        switches_inputs = 16'h0123;
        #(2 * CLK_PERIOD);

        // Release reset
        reset = 1'b0;

        // Allow the BCD converter to finish
        #300;

        // Hexadecimal mode: selected_value should be 0123
        mux_select = 1'b0;
        #100;

        // Decimal mode: selected_value should be 0291
        mux_select = 1'b1;
        #100;

        // Apply another input: hexadecimal 0100 = decimal 256
        mux_select      = 1'b0;
        switches_inputs = 16'h0100;
        #300;

        // Hexadecimal mode: selected_value should be 0100
        mux_select = 1'b0;
        #100;

        // Decimal mode: selected_value should be 0256
        mux_select = 1'b1;
        #100;

        $finish;
    end

endmodule