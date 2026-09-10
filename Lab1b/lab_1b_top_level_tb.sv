`timescale 1ns / 1ps

module lab_1b_top_level_tb();

    // 10 ns period = 100 MHz clock
    parameter CLK_PERIOD = 10;

    // Inputs
    logic        clk;
    logic        reset;
    logic [15:0] switches_inputs;

    // Outputs
    logic [15:0] led;
    logic CA, CB, CC, CD, CE, CF, CG, DP;
    logic AN1, AN2, AN3, AN4;

    // Unit Under Test
    lab_1b_top_level uut (
        .clk             (clk),
        .reset           (reset),
        .switches_inputs (switches_inputs),

        .led             (led),

        .CA              (CA),
        .CB              (CB),
        .CC              (CC),
        .CD              (CD),
        .CE              (CE),
        .CF              (CF),
        .CG              (CG),
        .DP              (DP),

        .AN1             (AN1),
        .AN2             (AN2),
        .AN3             (AN3),
        .AN4             (AN4)
    );

    // Generate a 100 MHz clock
    always begin
        clk = 0;
        #(CLK_PERIOD / 2);
        clk = 1;
        #(CLK_PERIOD / 2);
    end

    // Test stimulus
    initial begin
        // Reset the design
        reset = 1;
        switches_inputs = 16'h0000;
        #(2 * CLK_PERIOD);
        reset = 0;

        // Test digits 0, 1, 2 and 3
        switches_inputs = 16'h0123;
        #(2_000_000 * CLK_PERIOD);

        // Test digits 4, 5, 6 and 7
        switches_inputs = 16'h4567;
        #(2_000_000 * CLK_PERIOD);

        // Test digits 8, 9, A and B
        switches_inputs = 16'h89AB;
        #(2_000_000 * CLK_PERIOD);

        // Test digits C, D, E and F
        switches_inputs = 16'hCDEF;
        #(2_000_000 * CLK_PERIOD);

        $stop;
    end

endmodule