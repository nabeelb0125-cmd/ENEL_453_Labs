`timescale 1ns / 1ps

module lab_1b_top_level (
    input  logic        clk,
    input  logic        reset,
    input  logic        mux_select,
    input  logic [15:0] switches_inputs,

    output logic         CA, CB, CC, CD, CE, CF, CG, DP,
    output logic         AN1, AN2, AN3, AN4,
    output logic [15:0]  led
);

    // Internal signals
    logic [15:0] switches_outputs;
    logic [15:0] bcd_value;
    logic [15:0] selected_value;

    // Connect the switches to the LEDs
    switch_logic SWITCHES (
        .switches_inputs  (switches_inputs),
        .switches_outputs (switches_outputs)
    );

    assign led = switches_outputs;

    // Convert the binary switch value to decimal BCD
    bin_to_bcd BCD_CONVERTER (
        .clk     (clk),
        .reset   (reset),
        .bin_in  (switches_inputs),
        .bcd_out (bcd_value)
    );

    // Select between hexadecimal and decimal BCD
    value_multiplexer VALUE_MULTIPLEXER (
        .hex_value     (switches_inputs),
        .decimal_value (bcd_value),
        .select        (mux_select),
        .display_value (selected_value)
    );

    // Send the selected value to the displays
    seven_segment_display_subsystem SEVEN_SEGMENT_DISPLAY (
        .clk      (clk),
        .reset    (reset),

        .sec_dig1 (selected_value[3:0]),
        .sec_dig2 (selected_value[7:4]),
        .min_dig1 (selected_value[11:8]),
        .min_dig2 (selected_value[15:12]),

        .CA       (CA),
        .CB       (CB),
        .CC       (CC),
        .CD       (CD),
        .CE       (CE),
        .CF       (CF),
        .CG       (CG),
        .DP       (DP),

        .AN1      (AN1),
        .AN2      (AN2),
        .AN3      (AN3),
        .AN4      (AN4)
    );

endmodule