
`timescale 1ns/1ps
`default_nettype none

module cascaded_adder_chain
    #(
        parameter ADDEND_WIDTH = 16,
        parameter SUM_WIDTH = ADDEND_WIDTH,
        parameter NUMBER_OF_ADDENDS = 64
    )
    (
        input wire clk_in,
        input wire [NUMBER_OF_ADDENDS-1:0][ADDEND_WIDTH-1:0] addends_in,
        output logic [SUM_WIDTH-1:0] sum_out
    );

    localparam STAGES = $clog2(NUMBER_OF_ADDENDS);

// -----------------------------Define In/Outs---------------------------------
    
    // Inputs

    // Outputs
    logic [SUM_WIDTH-1:0] sum_out_d, sum_out_q;

// -----------------------------Assign In/Outs---------------------------------
    
    always_comb begin : ASSIGN_INPUT_SIGNALS
    end

    always_comb begin : ASSIGN_OUTPUT_SIGNALS
        sum_out = sum[0];
    end

// -----------------------------Define Signals---------------------------------
    logic [NUMBER_OF_ADDENDS-1:0][ADDEND_WIDTH-1:0] sum;
// -----------------------------Assign Signals---------------------------------

    genvar stage_num, i;
    generate
        for (stage_num = 0; stage_num < STAGES; stage_num++) begin
            for (i = 0; i < 2**stage_num; i++) begin
                assign sum[i] = stage_num == 0 ? addends_in[i] + addends_in[i+1] : sum[i] + sum[i+i];
            end
        end
    endgenerate

// ----------------------------Register Signals--------------------------------

    always_ff @(posedge clk_in) begin : REGISTER_INPUT_SIGNALS
    end

    always_ff @(posedge clk_in) begin : REGISTER_OUTPUT_SIGNALS
    end

    always_ff @(posedge clk_in) begin : REGISTER_DESIGN_SIGNALS
    end

endmodule
