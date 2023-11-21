import numpy as np
import unittest
import statistics


def find_median_with_padding(data_list, filter_length):
    """
    Description: get median value in data array (zero padding)

    Args:
    - data_list: the array
    - filter_length: filter size(must odd value)

    Out:
    - result: medians array
    """
    if filter_length % 2 == 0:
        return -1

    result = []  # initialize the result data array

    for i in range(len(data_list)):
        start_index = max(0, i - filter_length // 2)
        end_index = min(len(data_list), i + filter_length // 2 + 1)

        window = data_list[start_index:end_index]
        padded_window = [0] * (filter_length - len(window)) + window

        sl = sorted(padded_window)
        n = len(sl)
        mid = n // 2

        if n % 2 == 0:
            median = (sl[mid - 1] + sl[mid]) / 2
        else:
            median = sl[mid]

        result.append(median)

    return result


class TestMedian(unittest.TestCase):

    def test_median(self):
        numbers_input = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5]
        result_numbers = [1, 3, 1, 4, 5, 5, 6, 5, 5, 5, 3]
        self.assertEqual(result_numbers, find_median_with_padding(numbers_input, 3))

    def test_median_not_odd_num(self):
        numbers_input = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5]
        result_numbers = [1, 3, 1, 4, 5, 5, 6, 5, 5, 5, 3]
        self.assertEqual(-1, find_median_with_padding(numbers_input, 4))


if __name__ == '__main__':
    print("this is a test")
    numbers = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5]
    result_data_list = find_median_with_padding(numbers, 3)
    print(result_data_list)
    unittest.main()
