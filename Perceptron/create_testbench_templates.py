import os
import re


def find_io_params(filename):
    with open(filename, 'r') as f:
        content = f.read()

    inputs = re.findall(r'input\s+([\w\[\]:]+)\s+([\w,]+)', content)
    outputs = re.findall(r'output\s+([\w\[\]:]+)\s+([\w,]+)', content)
    parameters = re.findall(r'parameter\s+(\w+)\s*=\s*([\w\[\]:]+)', content)

    inputs = [(io[0], io[1].split(',')) for io in inputs]
    inputs = [(io[0], i.strip()) for io in inputs for i in io[1]]

    outputs = [(io[0], io[1].split(',')) for io in outputs]
    outputs = [(io[0], i.strip()) for io in outputs for i in io[1]]

    return inputs, outputs, parameters


def generate_tb_template(module_name, inputs, outputs, parameters):
    def convert_datatype(datatype):
        if datatype == 'wire':
            return 'logic'
        elif datatype in ('logic', 'tri', 'inout'):
            return 'wire'
        else:
            return datatype

    input_declarations = ', '.join(
        [f'{convert_datatype(io[0])} {io[1]}' for io in inputs]) + ';'
    output_declarations = ', '.join(
        [f'{convert_datatype(io[0])} {io[1]}' for io in outputs]) + ';'

    parameter_declarations = ',\n    '.join(
        [f'.{param[0]}({param[0]})' for param in parameters])

    tb_template = f'''`timescale 1ns/1ps
`default_nettype none

module {module_name}_tb;

    parameter CLK_PERIOD_NS = 10;
    {input_declarations}
    {output_declarations}

    {module_name} #(
    {parameter_declarations})
    UUT(
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

    return tb_template


def update_makefile(module_name):
    with open('Makefile', 'r') as f:
        content = f.read()

    test_line = f'test_{module_name} : testbenches/{module_name}_tb.sv hdl/*\n\t'
    test_line += f'${{IVERILOG}} $^ -o {module_name}_tb.bin && ${{VVP}} {module_name}_tb.bin ${{VVP_POST}} '
    test_line += f'&& gtkwave {module_name}.fst -a testbenches/sy\n'

    if f'test_{module_name}' not in content:
        content += test_line

    with open('Makefile', 'w') as f:
        f.write(content)


def main():
    for filename in os.listdir('hdl'):
        if filename.endswith('.sv'):
            module_name = os.path.splitext(filename)[0]
            inputs, outputs, parameters = find_io_params(f'hdl/{filename}')

            tb_filename = f'testbenches/{module_name}_tb.sv'
            if os.path.exists(tb_filename):
                current_inputs, current_outputs, current_parameters = find_io_params(
                    tb_filename)
                if (inputs, outputs, parameters) != (current_inputs, current_outputs, current_parameters):
                    tb_template = generate_tb_template(
                        module_name, inputs, outputs, parameters)
                    with open(tb_filename, 'w') as f:
                        f.write(tb_template)
                    print(f'Updated testbench for {module_name}')
            else:
                tb_template = generate_tb_template(
                    module_name, inputs, outputs, parameters)
                with open(tb_filename, 'w') as f:
                    f.write(tb_template)
                print(f'Created testbench for {module_name}')

            update_makefile(module_name)


if __name__ == '__main__':
    main()
