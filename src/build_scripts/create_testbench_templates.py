import re
import os


def create_testbench_template(file_name):
    with open(f"./hdl/{file_name}.sv", "r+") as f:
        parameters = []
        parameter_names = []
        inputs = []
        outputs = []
        lines = f.readlines()
        for line in lines:
            if "parameter" in line:
                parameters.append("    " + line.strip().strip(",") + ";\n")
                parameter_name = line.strip().strip("parameter").strip(",").strip("=")
                parameter_names.append(
                    re.sub(r"^\d+|\d+$", "", parameter_name).strip("= ")
                )
            if "input" in line:
                inputs.append(
                    "    logic "
                    + line.strip().strip("input ").replace("wire ", "").strip(",")
                    + ";\n"
                )
            if "output" in line:
                outputs.append(
                    "    wire "
                    + line.strip().strip("output ").replace("logic ", "").strip(",")
                    + ";\n"
                )
            if ");" in line:
                break
    nl = "\n"

    testbench_template = f"""
`timescale 1ns/1ps
`default_nettype none

module {file_name}_tb;

    parameter CLK_PERIOD_NS = 10;

    // UUT Parameters
{''.join([str(parameter) for parameter in parameters])}
    // UUT Inputs
{''.join([str(input) for input in inputs])}
    // UUT Outputs
{''.join([str(output) for output in outputs])}

    // Test Hyperparameters
    parameter TEST_COUNT = 1;
    string MEM_PATH = "./mem/test_vectors/{file_name}/";

    // Test Vectors
    logic [1-1:0] xx [0:TEST_COUNT-1];

    // task automatic readMem();
    //    $readmemb({{MEM_PATH, xx".mem"}}, xx);
    // endtask

    {file_name} #(
        {f',{nl}        '.join([f".{parameter_name.strip()}({parameter_name.strip()})" for parameter_name in parameter_names])}
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_in = ~clk_in;

    initial begin
        $dumpfile("{file_name}.fst");
        $dumpvars(0, UUT);
        clk_in = 0;
        repeat(1) @(negedge clk_in);
        $finish;
    end

endmodule
"""

    return testbench_template


def update_makefile(module_name):
    with open("Makefile", "r") as f:
        content = f.read()

    test_line = f"test_{module_name} : testbenches/{module_name}_tb.sv hdl/*\n\t"
    test_line += f"${{IVERILOG}} {module_name}.bin ./testbenches/{module_name}_tb.sv ./hdl/{module_name}.sv && ${{VVP}} {module_name}.bin ${{VVP_POST}}\n\n"
    test_line += f"wave_{module_name} : testbenches/{module_name}_tb.sv\n\t"
    test_line += f"gtkwave {module_name}.fst --save={module_name}.gtkw\n\n"

    # if f"test_{module_name}" not in content:
    content += test_line

    with open("Makefile", "w") as f:
        f.write(content)


def main():
    for filename in os.listdir("hdl"):
        if filename.endswith(".sv"):
            module_name = os.path.splitext(filename)[0]

            tb_filename = f"testbenches/{module_name}_tb.sv"
            if os.path.exists(tb_filename):
                pass
            else:
                tb_template = create_testbench_template(module_name)
                with open(tb_filename, "w") as f:
                    f.write(tb_template)
                print(f"Created testbench for {module_name}")
                update_makefile(module_name)


if __name__ == "__main__":
    main()
