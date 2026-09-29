module lab_3_top_level (
    input  logic        clk,
    input  logic        reset,
    input  logic        btnU,   // Selecting HEX or BCD
    input  logic        btnL,   // Storing current switch value
    input  logic        btnR,   // Selecting current or stored value
    input  logic [15:0] switches_inputs,
    
    output logic         CA, CB, CC, CD, CE, CF, CG, DP,
    output logic         AN1, AN2, AN3, AN4,
    output logic [15:0]  led
);

    // Internal signals
    logic [15:0] switches_outputs;
    logic [15:0] bcd_value;
    logic [15:0] stored_value;
    logic [15:0] stored_bcd_value;

    logic [15:0] current_display_value;
    logic [15:0] stored_display_value;
    logic [15:0] display_value;

    logic [15:0] synchronized_switches;
    
    logic btnU_debounced;
    logic btnL_debounced;
    logic btnR_debounced;

// Debounce the pushbuttons used in the design
    debounce #(
        .clk_freq    (100_000_000),
        .stable_time (50)
    ) DEBOUNCE_BTNU (
        .clk    (clk),
        .reset  (reset),
        .button (btnU),
        .result (btnU_debounced)
    );

    debounce #(
        .clk_freq    (100_000_000),
        .stable_time (50)
    ) DEBOUNCE_BTNL (
        .clk    (clk),
        .reset  (reset),
        .button (btnL),
        .result (btnL_debounced)
    );

    debounce #(
        .clk_freq    (100_000_000),
        .stable_time (50)
    ) DEBOUNCE_BTNR (
        .clk    (clk),
        .reset  (reset),
        .button (btnR),
        .result (btnR_debounced)
    );

    // Synchronize the asynchronous slide-switch inputs
    switch_synchronizer SWITCH_SYNCHRONIZER (
        .clk      (clk),
        .reset    (reset),
        .async_in (switches_inputs),
        .sync_out (synchronized_switches)
    );


    // Pass the synchronized switch values through the switch logic module
    switch_logic SWITCHES (
        .switches_inputs  (synchronized_switches),
        .switches_outputs (switches_outputs)
    );

    // Connect the switch logic outputs to the LEDs
    assign led = switches_outputs;


    // Store the current synchronized switch value when btnL is pressed
    switch_register STORAGE_REGISTER (
        .clk      (clk),
        .reset    (reset),
        .enable   (btnL_debounced),
        .data_in  (synchronized_switches),
        .data_out (stored_value)
    );


    // Convert the current synchronized switch value to BCD
    bin_to_bcd BCD_CONVERTER_CURRENT (
        .clk     (clk),
        .reset   (reset),
        .bin_in  (synchronized_switches),
        .bcd_out (bcd_value)
    );


    // Convert the stored register value to BCD
    bin_to_bcd BCD_CONVERTER_STORED (
        .clk     (clk),
        .reset   (reset),
        .bin_in  (stored_value),
        .bcd_out (stored_bcd_value)
    );


    // Choosing HEX or BCD for the CURRENT switch value
    // if btnU = 0, it is HEX
    // if btnU = 1, it is BCD
    multiplexer CURRENT_FORMAT_MUX (
        .input0  (synchronized_switches),
        .input1  (bcd_value),
        .select  (btnU_debounced),
        .mux_out (current_display_value)
    );


    // Choosing HEX or BCD for the STORED register value
    // if btnU = 0, it is HEX
    // if btnU = 1, it is BCD
    multiplexer STORED_FORMAT_MUX (
        .input0  (stored_value),
        .input1  (stored_bcd_value),
        .select  (btnU_debounced),
        .mux_out (stored_display_value)
    );


    // Choosing whether to display the current or stored value
    // if btnR = 0, it will be the current value
    // if btnR = 1, it will be the stored value
    multiplexer VALUE_SELECT_MUX (
        .input0  (current_display_value),
        .input1  (stored_display_value),
        .select  (btnR_debounced),
        .mux_out (display_value)
    );


    // Drive the four seven-segment displays
    seven_segment_display_subsystem SEVEN_SEGMENT_DISPLAY (
        .clk      (clk),
        .reset    (reset),

        .sec_dig1 (display_value[3:0]),
        .sec_dig2 (display_value[7:4]),
        .min_dig1 (display_value[11:8]),
        .min_dig2 (display_value[15:12]),

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