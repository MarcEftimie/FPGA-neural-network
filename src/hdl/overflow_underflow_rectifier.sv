
`timescale 1ns/1ps
`default_nettype none

module overflow_underflow_rectifier
    #(
        parameter UNRECTIFIED_DATA_WIDTH = 32,
        parameter RECTIFIED_DATA_WIDTH = 16
    )
    (
        input wire clk_in,
        input wire signed [UNRECTIFIED_DATA_WIDTH-1:0] unrectified_num_in,
        output logic signed [RECTIFIED_DATA_WIDTH-1:0] rectified_num_out
    );

    localparam MAX_VALUE = (2**(RECTIFIED_DATA_WIDTH-1)) - 1;
    localparam MIN_VALUE = -(2**(RECTIFIED_DATA_WIDTH-1));

// -----------------------------Define Signals---------------------------------
    logic unrectified_num_has_overflow;
    logic unrectified_num_has_underflow;

// -----------------------------Assign Signals---------------------------------

    always_comb begin : OVERFLOW_UNDERFLOW_DETECTION
        unrectified_num_has_overflow = unrectified_num_in > MAX_VALUE;
        unrectified_num_has_underflow = unrectified_num_in < MIN_VALUE;
    end

    always_comb begin : RECTIFICATION
        if (unrectified_num_has_overflow) begin
            rectified_num_out = MAX_VALUE;
        end else if (unrectified_num_has_underflow) begin
            rectified_num_out = MIN_VALUE;
        end else begin
            rectified_num_out = unrectified_num_in[RECTIFIED_DATA_WIDTH-1:0];
        end
    end

endmodule
