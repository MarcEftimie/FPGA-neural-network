`timescale 1ns/1ps
`default_nettype none

module vector_multiplier_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter INPUT_COUNT = 1;
    parameter DATA_WIDTH = 16;
    logic clk_in;
    logic [INPUT_COUNT * DATA_WIDTH - 1:0] inputs_in;
    logic [INPUT_COUNT * DATA_WIDTH - 1:0] weights_in;
    logic [DATA_WIDTH - 1:0] bias_in;
    wire [DATA_WIDTH - 1:0] output_out;
    logic [DATA_WIDTH - 1:0] output_from_file;
    string MEM_PATH = "./mem/vector_multiplier/";


    vector_multiplier #(
        .INPUT_COUNT(INPUT_COUNT),
        .DATA_WIDTH(DATA_WIDTH)
    ) UUT(
        .*
    );

    task automatic readMem(int test_num);
        $fscanf($fopen({MEM_PATH, $sformatf("inputs/inputs%0d.mem", test_num)}, "r"), "%h\n", inputs_in);
        $fscanf($fopen({MEM_PATH, $sformatf("weights/weights%0d.mem", test_num)}, "r"), "%h\n", weights_in);
        $fscanf($fopen({MEM_PATH, $sformatf("output/output%0d.mem", test_num)}, "r"), "%h\n", output_from_file);
    endtask

    task automatic reset;
        repeat(1) @(posedge clk_in);
        inputs_in = 0;
        weights_in = 0;
        bias_in = 0;
        repeat(5) @(posedge clk_in);
    endtask

    always #(CLK_PERIOD_NS/2) clk_in = ~clk_in;

    initial begin
        $dumpfile("vector_multiplier.vcd");
        $dumpvars(0, UUT);
        clk_in = 0;
        repeat(1) @(negedge clk_in);

        // Test 1
        reset;
        readMem(0);
        repeat(7) @(posedge clk_in);
        if(output_out == output_from_file)
            $display("Test 1 Passed");
        else
            $display("Test 1 Failed: Expected %h, Got %h", output_from_file, output_out);
        repeat(10) @(negedge clk_in);

        // Test 2
        reset;
        readMem(1);
        repeat(7) @(posedge clk_in);
        if(output_out == output_from_file)
            $display("Test 2 Passed");
        else
            $display("Test 2 Failed: Expected %h, Got %h", output_from_file, output_out);
        repeat(10) @(negedge clk_in);

        // Test 3
        reset;
        readMem(2);
        repeat(7) @(posedge clk_in);
        if(output_out == output_from_file)
            $display("Test 3 Passed");
        else
            $display("Test 3 Failed: Expected %h, Got %h", output_from_file, output_out);
        repeat(10) @(negedge clk_in);

        // Test 4
        reset;
        readMem(3);
        repeat(7) @(posedge clk_in);
        if(output_out == output_from_file)
            $display("Test 4 Passed");
        else
            $display("Test 4 Failed: Expected %h, Got %h", output_from_file, output_out);
        repeat(10) @(negedge clk_in);

        // Test 5
        reset;
        readMem(4);
        repeat(7) @(posedge clk_in);
        if(output_out == output_from_file)
            $display("Test 5 Passed");
        else
            $display("Test 5 Failed: Expected %h, Got %h", output_from_file, output_out);
        repeat(10) @(negedge clk_in);

        // Test 6
        reset;
        readMem(5);
        repeat(7) @(posedge clk_in);
        if(output_out == output_from_file)
            $display("Test 6 Passed");
        else
            $display("Test 6 Failed: Expected %h, Got %h", output_from_file, output_out);
        repeat(10) @(negedge clk_in);

        // Test 7
        reset;
        readMem(7);
        repeat(6) @(posedge clk_in);
        if(output_out == output_from_file)
            $display("Test 7 Passed");
        else
            $display("Test 7 Failed: Expected %h, Got %h", output_from_file, output_out);
        repeat(10) @(negedge clk_in);

        // Test 8
        reset;
        readMem(7);
        repeat(7) @(posedge clk_in);
        if(output_out == output_from_file)
            $display("Test 8 Passed");
        else
            $display("Test 8 Failed: Expected %h, Got %h", output_from_file, output_out);
        repeat(10) @(negedge clk_in);

        // Test 9
        reset;
        readMem(8);
        repeat(7) @(posedge clk_in);
        if(output_out == output_from_file)
            $display("Test 9 Passed");
        else
            $display("Test 9 Failed: Expected %h, Got %h", output_from_file, output_out);
        repeat(10) @(negedge clk_in);

        // Test 10
        reset;
        readMem(9);
        repeat(7) @(posedge clk_in);
        if(output_out == output_from_file)
            $display("Test 10 Passed");
        else
            $display("Test 10 Failed: Expected %h, Got %h", output_from_file, output_out);
        repeat(10) @(negedge clk_in);

        // Test 11
        reset;
        readMem(10);
        repeat(7) @(posedge clk_in);
        if(output_out == output_from_file)
            $display("Test 11 Passed");
        else
            $display("Test 11 Failed: Expected %h, Got %h", output_from_file, output_out);
        repeat(10) @(negedge clk_in);

        // Test 12
        reset;
        readMem(11);
        repeat(7) @(posedge clk_in);
        if(output_out == output_from_file)
            $display("Test 12 Passed");
        else
            $display("Test 12 Failed: Expected %h, Got %h", output_from_file, output_out);
        repeat(10) @(negedge clk_in);
        $finish;
    end

endmodule
