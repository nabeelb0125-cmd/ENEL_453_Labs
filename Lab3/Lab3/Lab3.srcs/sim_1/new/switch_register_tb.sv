`timescale 1ns / 1ps

module switch_register_tb();

    parameter CLK_PERIOD = 10;

    logic        clk;
    logic        reset;
    logic        enable;
    logic [15:0] data_in;
    logic [15:0] data_out;

    // Unit Under Test
    switch_register uut (
        .clk      (clk),
        .reset    (reset),
        .enable   (enable),
        .data_in  (data_in),
        .data_out (data_out)
    );

    // 100 MHz clock
    always begin
        clk = 0;
        #(CLK_PERIOD / 2);
        clk = 1;
        #(CLK_PERIOD / 2);
    end

    initial begin
        // Initial reset
        reset  = 1;
        enable = 0;
        data_in = 16'h0000;

        #(2 * CLK_PERIOD);
        reset = 0;

        // Change input, but do not store it yet
        data_in = 16'hAAAA;
        #(2 * CLK_PERIOD);

        // Store AAAA
        enable = 1;
        #(CLK_PERIOD);
        enable = 0;

        // Change input to 5555
        // Output should remain AAAA
        data_in = 16'h5555;
        #(2 * CLK_PERIOD);

        // Store 5555
        enable = 1;
        #(CLK_PERIOD);
        enable = 0;

        #(2 * CLK_PERIOD);

        // Test synchronous reset
        reset = 1;
        #(CLK_PERIOD);
        reset = 0;

        #(2 * CLK_PERIOD);

        $stop;
    end

endmodule