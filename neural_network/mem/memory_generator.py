import random

def generate_topology(topology, file_name='topology.mem'):
    # Function to convert an integer to its 8-bit binary representation
    def float_to_fixed_point_16_16(value):
        print(value)
        if not (-2**15 <= value < 2**15):
            raise ValueError(f"The value {value} cannot be represented in the 16.16 fixed-point format")

        # Multiply the float value by 2**16 to shift the fractional part to the integer position
        fixed_point_value = int(value * 2**16)

        # Convert the fixed-point value to its binary representation
        return format(fixed_point_value, '032b')

    # Open the file in write mode and write the 8-bit binary representations
    with open(file_name, 'w') as f:
        for layer_count in range(0, len(topology)):
            if (layer_count == len(topology) - 1):
                outputs = 0
            else:
                outputs = topology[layer_count + 1]
            for neuron in range(0, topology[layer_count]):
                for output in range(0, outputs+1):
                    f.write(f"{float_to_fixed_point_16_16(random.random())}" + "\n")
                f.write(f"{format(0, '032b')}" + "\n")
                # for number in topology:
                #     if 0 <= number <= 255:  # Ensure the number is within the 8-bit range
                #         binary_representation = int_to_8bit_binary(number)
                #         f.write(binary_representation + '\n')
                #     else:
                #         print(f"Number {number} is out of range for 8-bit representation. Skipping.")
                # f.write(int_to_8bit_binary(0))

if (__name__ == '__main__'):
    # Example usage:
    topology = [3, 2, 1]
    generate_topology(topology, 'topology.mem')
    print(random.random())
