`timescale 1ns/1ps
`default_nettype none

module overflow_underflow_rectifier_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter UNRECTIFIED_DATA_WIDTH = 32;
    parameter RECTIFIED_DATA_WIDTH = 16;
    logic clk_in;
    logic [UNRECTIFIED_DATA_WIDTH-1:0] unrectified_data_in;
    wire [RECTIFIED_DATA_WIDTH-1:0] rectified_data_out;
    localparam MAX_VALUE = (2**(RECTIFIED_DATA_WIDTH-1)) - 1;
    localparam MIN_VALUE = -(2**(RECTIFIED_DATA_WIDTH-1));

    overflow_underflow_rectifier #(
        .UNRECTIFIED_DATA_WIDTH(UNRECTIFIED_DATA_WIDTH),
        .RECTIFIED_DATA_WIDTH(RECTIFIED_DATA_WIDTH)
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_in = ~clk_in;

    initial begin
        $dumpfile("overflow_underflow_rectifier.fst");
        $dumpvars(0, UUT);
        clk_in = 0;

        // Test the max unrectified value
        unrectified_data_in = 32'h7FFFFFFF;
        repeat(2) @(negedge clk_in);
        if(rectified_data_out != MAX_VALUE[RECTIFIED_DATA_WIDTH-1:0]) $display("Failed for max unrectified input");

        // Test the min unrectified value
        unrectified_data_in = 32'h80000000;
        repeat(2) @(negedge clk_in);
        if(rectified_data_out != MIN_VALUE[RECTIFIED_DATA_WIDTH-1:0]) $display("Failed for min unrectified input");

        // Test a value greater than the max 2's complement 16-bit value
        unrectified_data_in = MAX_VALUE + 1;
        repeat(2) @(negedge clk_in);
        if(rectified_data_out != MAX_VALUE[RECTIFIED_DATA_WIDTH-1:0]) $display("Failed for input greater than MAX_VALUE");

        // Test a value less than the min 2's complement 16-bit value
        unrectified_data_in = MIN_VALUE - 1;
        repeat(2) @(negedge clk_in);
        if(rectified_data_out != MIN_VALUE[RECTIFIED_DATA_WIDTH-1:0]) $display("Failed for input less than MIN_VALUE");

        // Test a value equal to the max 2's complement 16-bit value
        unrectified_data_in = MAX_VALUE;
        repeat(2) @(negedge clk_in);
        if(rectified_data_out != MAX_VALUE[RECTIFIED_DATA_WIDTH-1:0]) $display("Failed for input equal to MAX_VALUE");

        // Test a value equal to the min 2's complement 16-bit value
        unrectified_data_in = MIN_VALUE;
        repeat(2) @(negedge clk_in);
        if(rectified_data_out != MIN_VALUE[RECTIFIED_DATA_WIDTH-1:0]) $display("Failed for input equal to MIN_VALUE");

        // Test some normal values
        unrectified_data_in = 12345;
        repeat(2) @(negedge clk_in);
        if(rectified_data_out !== unrectified_data_in[RECTIFIED_DATA_WIDTH-1:0]) $display("Failed for input 12345");

        unrectified_data_in = -12345;
        repeat(2) @(negedge clk_in);
        if(rectified_data_out !== unrectified_data_in[RECTIFIED_DATA_WIDTH-1:0]) $display("Failed for input -12345");
        repeat(2) @(negedge clk_in);

        $finish;
    end

endmodule
