import random


# Function to convert an integer to its 8-bit binary representation
def float_to_fixed_point_16_16(value):
    print(value)
    if not (-2**15 <= value < 2**15):
        raise ValueError(
            f"The value {value} cannot be represented in the 16.16 fixed-point format")
    # Multiply the float value by 2**16 to shift the fractional part to the integer position
    fixed_point_value = int(value * 2**16)

    # Convert the fixed-point value to its binary representation
    return format(fixed_point_value, '032b')


def generate_network_memory(topology, file_name='network.mem'):
    # Open the file in write mode and write the 8-bit binary representations
    with open(file_name, 'w') as f:
        for layer_count in range(0, len(topology)):
            f.write(f"{format(topology[layer_count], '032b')}" + "\n")
            if (layer_count == len(topology) - 1):
                outputs = 0
            else:
                outputs = topology[layer_count + 1]
            for neuron in range(0, topology[layer_count]):
                for output in range(0, outputs+1):
                    f.write(
                        f"{float_to_fixed_point_16_16(random.random())}" + "\n")
                f.write(f"{format(0, '032b')}" + "\n")
                f.write(f"{format(0, '032b')}" + "\n")


def generate_trainer_memory(training_data, file_name='trainer.mem'):
    with open(file_name, 'w') as f:
        for set in training_data:
            for input in set[0]:
                f.write(f"{float_to_fixed_point_16_16(input)}\n")
            for output in set[1]:
                f.write(
                    f"{float_to_fixed_point_16_16(output)}\n")


if (__name__ == '__main__'):
    # Example usage:
    topology = [3, 2, 1]
    training_data = [[[1, 1, 1], [1]], [[2, 2, 2], [2]], [[3, 3, 3], [3]]]
    generate_network_memory(topology, 'network.mem')
    generate_trainer_memory(training_data, 'trainer.mem')
    print(random.random())
