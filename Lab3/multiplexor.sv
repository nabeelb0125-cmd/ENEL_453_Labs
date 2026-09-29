`timescale 1ns / 1ps

// 2-to-1, 16-bit multiplexer
// Selects one of two 16-bit inputs based on the select signal
module multiplexer (
    input  logic [15:0] input0,   // First 16-bit input
    input  logic [15:0] input1,   // Second 16-bit input
    input  logic        select,   // Select signal
    output logic [15:0] mux_out   // Selected output
);

    // If select = 0, output input0
    // If select = 1, output input1
    assign mux_out = select ? input1 : input0;

endmodule