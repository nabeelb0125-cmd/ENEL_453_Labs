module switch_logic (
    input  logic [15:0] switches_inputs,
    output logic [15:0] switches_outputs 
);

    
    assign switches_outputs[15:0]  = switches_inputs[15:0];

endmodule
