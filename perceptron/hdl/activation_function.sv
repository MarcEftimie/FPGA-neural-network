`timescale 1ns/1ps
`default_nettype none

module activation_function
    #(
        parameter sign = 1,
        parameter q_m = 16,
        parameter q_n = 16
    )
    (
        input wire [(sign + q_m + q_n) - 1:0] summation,
        output logic activation
    );

    assign activation = summation == 0 ? 0 :
                        summation[(sign + q_m + q_n) - 1] ? 0 : 1;

endmodule
