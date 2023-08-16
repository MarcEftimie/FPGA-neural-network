import random
import itertools

FIXED_POINT_POSITION = 10
TEST_VECTORS_PATH = "../mem/test_vectors/systolic_artihmetic_node/"
RANDOM_TEST_COUNT = 100000
NONRANDOM_CASES = [0, 1, -1, 2**15 - 1, -(2**15)]


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


def get_non_random_tests():
    combinations = list(itertools.product(NONRANDOM_CASES, repeat=3))

    activations, weights, partial_sums = zip(*combinations)
    return list(activations), list(weights), list(partial_sums)


def add_random_tests(activations, weights, partial_sums):
    for test_case in range(0, RANDOM_TEST_COUNT):
        activations.append(random.randrange(-(2**15), 2**15 - 1))
        weights.append(random.randrange(-(2**15), 2**15 - 1))
        partial_sums.append(random.randrange(-(2**15), 2**15 - 1))
    return activations, weights, partial_sums


def calculate_sum_vector(activations, weights, partial_sums):
    sums = []
    for test_case in range(0, len(activations)):
        sums.append(
            systolic_arithmetic_node(
                activations[test_case], weights[test_case], partial_sums[test_case]
            )
        )
    return sums


activations, weights, partial_sums = get_non_random_tests()
activations, weights, partial_sums = add_random_tests(
    activations, weights, partial_sums
)

sums = calculate_sum_vector(activations, weights, partial_sums)

with open(f"{TEST_VECTORS_PATH}activations.mem", "w") as f:
    for test_count in range(0, len(activations)):
        f.write(f"{format(activations[test_count] & 0xFFFF, '016b')}\n")

with open(f"{TEST_VECTORS_PATH}weights.mem", "w") as f:
    for test_count in range(0, len(weights)):
        f.write(f"{format(weights[test_count] & 0xFFFF, '016b')}\n")

with open(f"{TEST_VECTORS_PATH}partial_sums.mem", "w") as f:
    for test_count in range(0, len(partial_sums)):
        f.write(f"{format(partial_sums[test_count] & 0xFFFF, '016b')}\n")

with open(f"{TEST_VECTORS_PATH}sums.mem", "w") as f:
    for test_count in range(0, len(sums)):
        f.write(f"{sums[test_count]}\n")
