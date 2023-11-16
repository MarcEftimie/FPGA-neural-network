
`timescale 1ns/1ps
`default_nettype none

module row_selector
    #(
        parameter SYSTOLIC_WIDTH = 2,
        parameter M1_WIDTH = 3
    )
    (
        input wire clk_in,
        input wire rst_in,
        output logic [7:0] item_out
    );

// -----------------------------Define Signals---------------------------------
    logic [7:0] row_count_d, row_count_q;
    logic [7:0] total_row_count_d, total_row_count_q;
    logic [7:0] row_start_d, row_start_q;
    logic [7:0] row_threshold_d, row_threshold_q;

// -----------------------------Assign Signals---------------------------------

    always_comb begin : TOTAL_ROW_COUNT_THRESHOLD
        if (rst_in) begin
            row_threshold_d = M1_WIDTH;
        end else if ((total_row_count_q > row_threshold_q - 1) & (row_count_q == SYSTOLIC_WIDTH - 1)) begin
            row_threshold_d = row_start_q + M1_WIDTH;
        end else begin
            row_threshold_d = row_threshold_q;
        end
    end

    always_comb begin : ROW_COUNTER
        if (rst_in) begin
            row_count_d = 0;
        end else if (row_count_q == SYSTOLIC_WIDTH - 1) begin
            row_count_d = 0;
        end else begin
            row_count_d = row_count_q + 1;
        end
    end

    always_comb begin : TOTAL_ROW_COUNTER
        if (rst_in) begin
            total_row_count_d = 0;
        end else if ((total_row_count_q > row_threshold_q - 1) & (row_count_q == SYSTOLIC_WIDTH - 1)) begin
            total_row_count_d = row_start_q;
        end else begin
            total_row_count_d = total_row_count_q + 1;
        end
    end

    always_comb begin : ROW_START_COUNTER
        if (rst_in) begin
            row_start_d = 0;
        end else if (!(total_row_count_q > row_threshold_q - 1)) begin
            row_start_d = row_start_q + SYSTOLIC_WIDTH;
        end else begin
            row_start_d = row_start_q;
        end
    end

    assign item_out = (total_row_count_q > row_threshold_q - 1) ? 0 : total_row_count_q;

// ----------------------------Register Signals--------------------------------

    always_ff @(posedge clk_in) begin : REGISTER_DESIGN_SIGNALS
        row_count_q <= row_count_d;
        total_row_count_q <= total_row_count_d;
        row_start_q <= row_start_d;
        row_threshold_q <= row_threshold_d;
    end

endmodule
