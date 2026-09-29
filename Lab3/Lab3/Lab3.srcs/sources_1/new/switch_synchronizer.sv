`timescale 1ns / 1ps

// Two-stage synchronizer for the 16 slide switches
module switch_synchronizer (
    input  logic        clk,
    input  logic        reset,
    input  logic [15:0] async_in,
    output logic [15:0] sync_out
);

    logic [15:0] sync_stage1;

    always_ff @(posedge clk) begin
        if (reset) begin
            sync_stage1 <= 16'h0000;
            sync_out    <= 16'h0000;
        end
        else begin
            sync_stage1 <= async_in;
            sync_out    <= sync_stage1;
        end
    end

endmodule