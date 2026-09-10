module switch_logic (
    input  logic [15:0] switches_inputs,
    output logic [15:0] switches_outputs 
);
    // Now when switches are up LEDs are on and when switches are down LEDs are off
    assign switches_outputs = switches_inputs; 

endmodule
