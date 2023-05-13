`timescale 1ns/1ps
`default_nettype none

module multiply_top
    (
        input wire clk_i, reset_i,
        input wire [31:0] a_i, b_i,
        output logic [31:0] product_o
    );

    logic sign_a;
    logic [7:0] exponent_a;
    logic [22:0] mantissa_a;

    logic sign_b;
    logic [7:0] exponent_b;
    logic [22:0] mantissa_b;

    logic [47:0] product_mantissa_reg, product_mantissa_next;
    logic [31:0] product_reg, product_next;

    typedef enum logic [1:0] { 
        IDLE,
        MULTIPLY,
        NORMALIZE,
        DONE
    } state_t;

    state_t state_reg, state_next;

    assign sign_a = a_i[31];
    assign exponent_a = a_i[30:23];
    assign mantissa_a = a_i[22:0];

    assign sign_b = b_i[31];
    assign exponent_b = b_i[30:23];
    assign mantissa_b = b_i[22:0];

    always @(posedge clk_i) begin
        if (reset_i) begin
            state_reg = IDLE;
            product_reg = 0;
            product_mantissa_reg = 0;
        end else begin
            state_reg = state_next;
            product_reg = product_next;
            product_mantissa_reg = product_mantissa_next;
        end
    end

    always_comb begin
        state_next = state_reg;
        product_next = product_reg;
        product_mantissa_next = product_mantissa_reg;
        product_o = 0;
        case (state_reg)
            IDLE : begin
                state_next = MULTIPLY;
            end
            MULTIPLY : begin
                product_mantissa_next = {1'b1, mantissa_a} * {1'b1, mantissa_b};

                product_next[31] = sign_a ^ sign_b;
                product_next[30:23] = exponent_a + exponent_b - 8'd127;

                state_next = NORMALIZE;
            end
            NORMALIZE : begin
                if (product_mantissa_reg[47]) begin
                    product_next[22:0] = {product_mantissa_reg[45:24] >> 1, 1'b0};
                    product_next[30:23] = product_reg[30:23] + 1;
                end else begin
                    product_next[22:0] = {product_mantissa_reg[45:24], 1'b0};
                end
                state_next = DONE;
            end
            DONE : begin
                product_o = product_reg;
                state_next = DONE;
            end
            default : begin
                state_next = IDLE;
            end
        endcase
    end

endmodule
