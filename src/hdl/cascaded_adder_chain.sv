
`timescale 1ns/1ps
`default_nettype none

module cascaded_adder_chain
    #(
        parameter ADDEND_WIDTH = 16,
        parameter NUMBER_OF_ADDENDS = 64,
        parameter FINAL_SUM_WIDTH = ADDEND_WIDTH
    )
    (
        input wire clk_in,
        input wire signed [NUMBER_OF_ADDENDS-1:0][ADDEND_WIDTH-1:0] addends_in,
        output logic signed [FINAL_SUM_WIDTH-1:0] sum_out
    );

    localparam STAGES = $clog2(NUMBER_OF_ADDENDS);
    localparam MAX_SUM_WIDTH = ADDEND_WIDTH + STAGES;

// -----------------------------Define Signals---------------------------------

    logic signed [(NUMBER_OF_ADDENDS/2)-1:0][ADDEND_WIDTH:0] stage_1_sum;
    logic signed [(NUMBER_OF_ADDENDS/4)-1:0][ADDEND_WIDTH+1:0] stage_2_sum;
    logic signed [(NUMBER_OF_ADDENDS/8)-1:0][ADDEND_WIDTH+2:0] stage_3_sum;
    logic signed [(NUMBER_OF_ADDENDS/16)-1:0][ADDEND_WIDTH+3:0] stage_4_sum;
    logic signed [(NUMBER_OF_ADDENDS/32)-1:0][ADDEND_WIDTH+4:0] stage_5_sum;
    logic signed [(NUMBER_OF_ADDENDS/64)-1:0][ADDEND_WIDTH+5:0] stage_6_sum;

    logic signed [FINAL_SUM_WIDTH-1:0] recitfied_sum;

// -----------------------------Assign Signals---------------------------------

    genvar i;
    for (i = 0; i<(NUMBER_OF_ADDENDS/2); i++) begin
        assign stage_1_sum[i] = addends_in[i] + addends_in[i+1];
    end

    for (i = 0; i<(NUMBER_OF_ADDENDS/4); i++) begin
        assign stage_2_sum[i] = stage_1_sum[i] + stage_1_sum[i+1];
    end

    for (i = 0; i<(NUMBER_OF_ADDENDS/8); i++) begin
        assign stage_3_sum[i] = stage_2_sum[i] + stage_2_sum[i+1];
    end

    for (i = 0; i<(NUMBER_OF_ADDENDS/16); i++) begin
        assign stage_4_sum[i] = stage_3_sum[i] + stage_3_sum[i+1];
    end

    for (i = 0; i<(NUMBER_OF_ADDENDS/32); i++) begin
        assign stage_5_sum[i] = stage_4_sum[i] + stage_4_sum[i+1];
    end

    for (i = 0; i<(NUMBER_OF_ADDENDS/64); i++) begin
        assign stage_6_sum[i] = stage_5_sum[i] + stage_5_sum[i+1];
    end

    overflow_underflow_rectifier #(
        .UNRECTIFIED_DATA_WIDTH(MAX_SUM_WIDTH),
        .RECTIFIED_DATA_WIDTH(FINAL_SUM_WIDTH)
    ) OVERFLOW_UNDERFLOW_RECTIFIER (
        .clk_in(clk_in),
        .unrectified_num_in(stage_6_sum),
        .rectified_num_out(sum_out)
    );


endmodule
