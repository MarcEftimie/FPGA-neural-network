import random
import itertools

FIXED_POINT_POSITION = 10
TEST_VECTORS_PATH = "../mem/test_vectors/systolic_array/"
RANDOM_TEST_COUNT = 100000
NONRANDOM_WEIGHTS = [0, 1 << FIXED_POINT_POSITION, 2**15 - 1, -(2**15)]
MATRIX_SIZE = 8


def systolic_arithmetic_node(activation, weight, partial_sum):
    product = weight * activation
    shifted_product = product >> FIXED_POINT_POSITION
    if shifted_product > 2**15 - 1:
        shifted_product = 2**15 - 1
    elif shifted_product < -(2**15):
        shifted_product = -(2**15)
    sum = shifted_product + partial_sum

    sum_bin = format(sum & 0x1FFFF, "017b")

    return sum_bin


def get_weights():
    return NONRANDOM_WEIGHTS


activations = get_weights()

with open(f"{TEST_VECTORS_PATH}weights.mem", "w") as f:
    for test_count in range(0, len(activations)):
        for i in range(0, MATRIX_SIZE):
            f.write(f"{format(activations[test_count] & 0xFFFF, '016b')}")
        f.write("\n")
