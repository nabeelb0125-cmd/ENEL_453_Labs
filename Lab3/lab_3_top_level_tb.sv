`timescale 1ns / 1ps

module lab_3_top_level_tb();

    // 10 ns period = 100 MHz clock
    parameter CLK_PERIOD = 10;

    // Inputs
    logic        btnU;
    logic        btnL;
    logic        btnR;   
    logic        clk;
    logic        reset;
    logic [15:0] switches_inputs;

    // Outputs
    logic [15:0] led;
    logic CA, CB, CC, CD, CE, CF, CG, DP;
    logic AN1, AN2, AN3, AN4;

    // Unit Under Test
    lab_3_top_level uut (
        .btnL            (btnL),
        .btnR            (btnR),
        .btnU            (btnU),
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
        // Reset
        reset = 1;
        btnL = 0;
        btnR = 0;
        btnU = 0;
        switches_inputs = 16'd0;

        #(2 * CLK_PERIOD);
        reset = 0;

        // Put 123 decimal on the switches
        // HEX = 007B, BCD = 0123
        switches_inputs = 16'd123;

        // Allow BCD conversion to finish
        #(100 * CLK_PERIOD);

        // Store 123 in the register
        btnL = 1;
        #(2 * CLK_PERIOD);
        btnL = 0;

        // Change current switches to 255 decimal
        // HEX = 00FF, BCD = 0255
        switches_inputs = 16'd255;

        // Allow BCD conversions to finish
        #(100 * CLK_PERIOD);

        // Current value, HEX
        // Expected display_value = 00FF
        btnR = 0;
        btnU = 0;
        #(100 * CLK_PERIOD);

        // Current value, BCD
        // Expected display_value = 0255
        btnR = 0;
        btnU = 1;
        #(100 * CLK_PERIOD);

        // Stored value, HEX
        // Expected display_value = 007B
        btnR = 1;
        btnU = 0;
        #(100 * CLK_PERIOD);

        // Stored value, BCD
        // Expected display_value = 0123
        btnR = 1;
        btnU = 1;
        #(100 * CLK_PERIOD);

        $stop;
    end
endmodule