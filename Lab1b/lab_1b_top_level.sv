module lab_1b_top_level (
    input  logic        clk,
    input  logic        reset,
    input  logic [15:0] switches_inputs,

    output logic         CA, CB, CC, CD, CE, CF, CG, DP,
    output logic         AN1, AN2, AN3, AN4,
    output logic [15:0]  led
);

    // Internal signal carrying the switch values to the LEDs
    logic [15:0] switches_outputs;

    // Pass the switch values through the switch logic module
    switch_logic SWITCHES (
        .switches_inputs  (switches_inputs),
        .switches_outputs (switches_outputs)
    );

    // Connect the switch logic outputs to the LEDs
    assign led = switches_outputs;

    // Drive the four seven-segment displays using the slide switches.
    // Each group of four switches controls one hexadecimal digit.
    seven_segment_display_subsystem SEVEN_SEGMENT_DISPLAY (
        .clk      (clk),
        .reset    (reset),

        // Map the four 4-bit switch groups to the four display digits
        .sec_dig1 (switches_inputs[3:0]),
        .sec_dig2 (switches_inputs[7:4]),
        .min_dig1 (switches_inputs[11:8]),
        .min_dig2 (switches_inputs[15:12]),

        // Seven-segment cathode connections
        .CA       (CA),
        .CB       (CB),
        .CC       (CC),
        .CD       (CD),
        .CE       (CE),
        .CF       (CF),
        .CG       (CG),
        .DP       (DP),

        // Display digit-selection connections
        .AN1      (AN1),
        .AN2      (AN2),
        .AN3      (AN3),
        .AN4      (AN4)
    );

endmodule