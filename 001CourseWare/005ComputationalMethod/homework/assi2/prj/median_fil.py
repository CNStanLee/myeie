import os
import numpy as np
from tqdm import tqdm
import data_proc as dp
import matplotlib.pyplot as plt
import unittest
import time


def median_filter(deg_data, det_data, filter_len, out_file):
    """median filter which can use given length filter and detection result to reconstruct the original voice 

    Args:
        deg_data (1Darray): degraded voice data
        det_data (1Darray): detection binary data
        filter_len (int): length of the median filter, means the number to take median value around the noise data point
        out_file (path): file path to save the result wav

    Returns:
        res_data: the restored data after processing
    """
    # judege filter length is not odd
    if (filter_len % 2 == 0):
        return -1

    # copy for result data
    res_data = np.array(deg_data)

    # find the bk point
    for i in tqdm(range(len(deg_data))):
        # judge if the detection is 1 means need interpolation
        if (det_data[i]):
            # error point detected, interpolation needed
            # find median array: filter_len / 2
            begin_addr = i - filter_len // 2
            end_addr = i + filter_len // 2
            median_arr = np.array([])
            for j in range(begin_addr, end_addr + 1):
                if j < 0:
                    median_arr = np.append(median_arr, 0)
                else:
                    median_arr = np.append(median_arr, deg_data[j])
            # sort the array
            median_arr.sort()
            median_val = median_arr[filter_len // 2]
            res_data[i] = median_val

    if out_file != "":
        dp.save_wav(out_file, res_data, 8192)

    return res_data


def find_best_mse_median():
    """find best mse by changing the filter length
    """
    script_dir = os.path.dirname(os.path.abspath(__file__))
    deg_file = os.path.join(script_dir, "res", "degraded.wav")
    det_file = os.path.join(script_dir, "bk.npy")
    # out_file = os.path.join(script_dir, "output.wav")
    out_file = ""
    clean_file = os.path.join(script_dir, "res", "clean.wav")

    clean_data, deg_data, det_data, fs, t = dp.read_data(
        clean_file, deg_file, det_file)
    data_len = len(clean_data)
    det_len = sum(det_data)

    start_time = time.time()
    res_data = median_filter(deg_data, det_data, 3, out_file)
    end_time = time.time()
    print("Time of median(3) is ", end_time - start_time)
    dp.plot_input_fig(t, clean_data, deg_data, det_data, res_data)
    print("MSE = ", dp.cal_mse(res_data, clean_data, det_len))

    # find best mse using median filter
    ergodic_arr = [1, 3, 5, 7, 9]
    mse_arr = []
    for i in ergodic_arr:
        res_data = median_filter(deg_data, det_data, i, out_file)
        # plot_input_fig(t, clean_data, deg_data, det_data, res_data)
        c_mse = dp.cal_mse(res_data, clean_data, det_len)
        print("size = ", i, "MSE = ", c_mse)
        mse_arr.append(c_mse)
    print(mse_arr)

    # plot the relationship between filter length and MSE
    plt.figure(figsize=(4, 6))

    plt.plot(ergodic_arr, mse_arr)
    plt.xlabel("filter length")
    plt.ylabel("MSE")
    plt.title("MSE vs filter length (median filter)")
    plt.ylim(0, 0.01)
    plt.show()


def save_demo_median():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    deg_file = os.path.join(script_dir, "res", "degraded.wav")
    det_file = os.path.join(script_dir, "bk.npy")
    out_file = os.path.join(script_dir, "output_medianFilter.wav")
    clean_file = os.path.join(script_dir, "res", "clean.wav")

    clean_data, deg_data, det_data, fs, t = dp.read_data(
        clean_file, deg_file, det_file)
    data_len = len(clean_data)
    det_len = sum(det_data)

    res_data = median_filter(deg_data, det_data, 3, out_file)


class median_unit_test(unittest.TestCase):
    def test_median_filter(self):
        result = median_filter([1, 3, 80, 7, 9], [0, 0, 1, 0, 0], 5, "")
        target = np.array([1, 3, 7, 7, 9])
        self.assertEqual(result.tolist(), target.tolist())

    def test_median_filter_even_input(self):
        result = median_filter([1, 3, 80, 7, 9, 11], [0, 0, 1, 0, 0, 0], 6, "")
        target = -1
        self.assertEqual(result, target)


if __name__ == '__main__':
    unittest.main()
