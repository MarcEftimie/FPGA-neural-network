import sys

file_name = str(sys.argv[1])
with open(f"./hdl/{file_name}.sv", "w") as f:
    template = f"""
`timescale 1ns/1ps
`default_nettype none

module {file_name}
    (
        input wire clk_in,
    );

// -------------------------Define In/Out Registers----------------------------
    
    // Inputs

    // Outputs

// -------------------------Assign In/Out Registers----------------------------
    
    always_comb begin : ASSIGN_INPUT_SIGNALS
    end

    always_comb begin : ASSIGN_OUTPUT_SIGNALS
    end

// -----------------------------Define Signals---------------------------------

// -----------------------------Assign Signals---------------------------------

    always_comb begin : BLOCK_LOGIC
    end

// ----------------------------Register Signals--------------------------------

    always_ff @(posedge clk_in) begin : REGISTER_INPUT_SIGNALS
    end

    always_ff @(posedge clk_in) begin : REGISTER_OUTPUT_SIGNALS
    end

    always_ff @(posedge clk_in) begin : REGISTER_DESIGN_SIGNALS
    end

endmodule
"""
    f.write(template)
