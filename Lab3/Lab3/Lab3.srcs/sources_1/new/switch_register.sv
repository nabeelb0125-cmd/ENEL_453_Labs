`timescale 1ns / 1ps

// 16-bit register used to store a switch value
module switch_register (
    input  logic        clk,
    input  logic        reset,
    input  logic        enable,
    input  logic [15:0] data_in,
    output logic [15:0] data_out
);

    // Synchronous register
    always_ff @(posedge clk) begin
        if (reset)
            data_out <= 16'h0000;
        else if (enable)
            data_out <= data_in;
    end

endmodule