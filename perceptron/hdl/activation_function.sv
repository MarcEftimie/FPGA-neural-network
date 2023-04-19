`timescale 1ns/1ps
`default_nettype none

module activation_function
    #(
        parameter SIGN = 1,
        parameter Q_M = 16,
        parameter Q_N = 16
    )
    (
        input wire [(SIGN + Q_M + Q_N) - 1:0] summation,
        output logic activation
    );

    assign activation = summation == 0 ? 0 :
                        summation[(SIGN + Q_M + Q_N) - 1] ? 0 : 1;

endmodule
