import sys

file_name = str(sys.argv[1])
signal_type = str(sys.argv[2])
signal_name = str(sys.argv[3])
signal_width = str(sys.argv[4])


def add_input(f, signal_name, signal_width):
    port_input = False
    assign_input = False
    define_input = False
    register_input = False
    modified_lines = []
    for line in f.readlines():
        if port_input:
            if ");" in line:
                port_input = False
                modified_lines.append(
                    f"        input wire {signal_width}{signal_name}_in,\n"
                )
        if define_input:
            if line.isspace():
                define_input = False
                modified_lines.append(
                    f"    logic {signal_width}{signal_name}_in_d, {signal_name}_in_q;\n"
                )
        if assign_input:
            if "end" in line:
                assign_input = False
                modified_lines.append(
                    f"        {signal_name}_in_d = {signal_name}_in;\n"
                )

        if register_input:
            if "end" in line:
                register_input = False
                modified_lines.append(
                    f"        {signal_name}_in_q <= {signal_name}_in_d;\n"
                )

        if "module" in line:
            port_input = True

        if "// Inputs" in line:
            define_input = True

        if "always_comb begin : ASSIGN_INPUT_SIGNALS" in line:
            assign_input = True

        if "always_ff @(posedge clk_in) begin : REGISTER_INPUT_SIGNALS" in line:
            register_input = True

        modified_lines.append(line)

    return modified_lines


def add_output(f, signal_name, signal_width):
    port_output = False
    assign_output = False
    define_output = False
    register_output = False
    modified_lines = []
    for line in f.readlines():
        if port_output:
            if ");" in line:
                port_output = False
                modified_lines.append(
                    f"        output logic {signal_width}{signal_name}_out,\n"
                )
        if define_output:
            if line.isspace():
                define_output = False
                modified_lines.append(
                    f"    logic {signal_width}{signal_name}_out_d, {signal_name}_out_q;\n"
                )
        if assign_output:
            if "end" in line:
                assign_output = False
                modified_lines.append(
                    f"        {signal_name}_out = {signal_name}_out_q;\n"
                )

        if register_output:
            if "end" in line:
                register_output = False
                modified_lines.append(
                    f"        {signal_name}_out_q <= {signal_name}_out_d;\n"
                )

        if "module" in line:
            port_output = True

        if "// Outputs" in line:
            define_output = True

        if "always_comb begin : ASSIGN_OUTPUT_SIGNALS" in line:
            assign_output = True

        if "always_ff @(posedge clk_in) begin : REGISTER_OUTPUT_SIGNALS" in line:
            register_output = True

        modified_lines.append(line)

    return modified_lines


def add_logic(f, signal_name, signal_width):
    define_logic = False
    register_logic = False
    modified_lines = []
    for line in f.readlines():
        if define_logic:
            if line.isspace():
                define_logic = False
                modified_lines.append(
                    f"    logic {signal_width}{signal_name}_d, {signal_name}_q;\n"
                )

        if register_logic:
            if "end" in line:
                register_logic = False
                modified_lines.append(f"        {signal_name}_q <= {signal_name}_d;\n")

        if (
            "// -----------------------------Define Signals---------------------------------"
            in line
        ):
            define_logic = True

        if "always_ff @(posedge clk_in) begin : REGISTER_DESIGN_SIGNALS" in line:
            register_logic = True

        modified_lines.append(line)

    return modified_lines


if signal_type not in ["i", "o", "l", "s"]:
    raise ValueError("Not a valid signal type")

if signal_width == "1":
    signal_width = ""
else:
    signal_width = f"[{signal_width}-1:0] "
with open(f"./hdl/{file_name}.sv", "r+") as f:
    modified_lines = []

    if signal_type == "i":
        modified_lines = add_input(f, signal_name, signal_width)
    if signal_type == "o":
        modified_lines = add_output(f, signal_name, signal_width)
    if signal_type == "l":
        modified_lines = add_logic(f, signal_name, signal_width)

with open(f"./hdl/{file_name}.sv", "w+") as f:
    f.writelines(modified_lines)
