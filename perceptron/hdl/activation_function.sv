`timescale 1ns/1ps
`default_nettype none

module activation_function
    #(
        parameter SIGN = 1,
        parameter Q_M = 15,
        parameter Q_N = 16
    )
    (
        input wire [(SIGN + Q_M + Q_N) - 1:0] summation,
        output logic [(SIGN + Q_M + Q_N) - 1:0] activation
    );

    assign activation = summation == 0 ? 32'b0_000000000000000_0000000000000000 :
                        summation[(SIGN + Q_M + Q_N) - 1] ? 32'b0_000000000000000_0000000000000000 : 32'b0_000000000000001_0000000000000000;

endmodule
