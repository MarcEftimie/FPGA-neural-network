import re
import os

def find_io(filename):
    patterns = ["input", "output", "inout"]
    matching_lines = []

    with open(filename, 'r') as file:
        for line in file:
            if re.search(patterns[0], line):
                line = line.strip()
                line = line.rstrip(',')
                line = line.replace('input ', '')
                line = line.replace('wire ', '')
                line = line.replace('logic ', '')
                line = line.replace('tri ', '')
                line = "logic " + line
                matching_lines.append(line)
            if re.search(patterns[1], line):
                line = line.strip()
                line = line.rstrip(',')
                line = line.replace('output ', '')
                line = line.replace('wire ', '')
                line = line.replace('logic ', '')
                line = line.replace('tri ', '')
                line = "wire " + line
                matching_lines.append(line)
            if re.search(patterns[2], line):
                line = line.strip()
                line = line.rstrip(',')
                line = line.replace('inout ', '')
                line = line.replace('wire ', '')
                line = line.replace('logic ', '')
                line = line.replace('tri ', '')
                line = "wire " + line
                matching_lines.append(line)
    return matching_lines

def find_params(filename):
    parameter_pattern = r"parameter\s+(\w+)"
    pattern = "parameter"
    parameters = []
    pattern_names = []

    with open(filename, 'r') as file:
        for line in file:
            if re.search(pattern, line):
                line = line.strip()
                line = line.rstrip(',')
                parameters.append(line)
            match = re.search(parameter_pattern, line)
            if match:
                pattern_names.append(match.group(1))
                
    return parameters, pattern_names

def create_testbench_template(module_name, inouts, parameters, parameter_names):
    template = f'''`timescale 1ns/1ps
`default_nettype none

module {module_name}_tb;

    parameter CLK_PERIOD_NS = 10;
'''
    for parameter in parameters:
        template += f'    {parameter};\n'

    for inout in inouts:
        template += f'    {inout};\n'

    template += f'''
    {module_name} #(
'''

    for parameter_name in parameter_names:
        template += f'    .{parameter_name}({parameter_name}),\n'

    template = template.rstrip(',\n') + f'''
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("{module_name}.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        reset_i = 1;
        repeat(1) @(negedge clk_i);
        reset_i = 0;
        $finish;
    end

endmodule
'''

    return template

def update_makefile(module_name):
    with open('Makefile', 'r') as f:
        content = f.read()

    test_line = f'test_{module_name} : testbenches/{module_name}_tb.sv hdl/*\n\t'
    test_line += f'${{IVERILOG}} $^ -o {module_name}_tb.bin && ${{VVP}} {module_name}_tb.bin ${{VVP_POST}} '
    test_line += f'&& gtkwave {module_name}.fst -a testbenches/sy\n\n'

    if f'test_{module_name}' not in content:
        content += test_line

    with open('Makefile', 'w') as f:
        f.write(content)

def main():
    for filename in os.listdir('hdl'):
        if filename.endswith('.sv'):
            module_name = os.path.splitext(filename)[0]
            inouts = find_io(f'hdl/{filename}')
            params, param_names = find_params(f'hdl/{filename}')

            tb_filename = f'testbenches/{module_name}_tb.sv'
            if os.path.exists(tb_filename):
                pass
            else:
                tb_template = create_testbench_template(module_name, inouts, params, param_names)
                with open(tb_filename, 'w') as f:
                    f.write(tb_template)
                print(f'Created testbench for {module_name}')
                update_makefile(module_name)


if __name__ == '__main__':
    main()
