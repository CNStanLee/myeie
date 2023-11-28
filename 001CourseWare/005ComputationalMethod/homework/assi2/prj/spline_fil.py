import os
import numpy as np
from tqdm import tqdm
import matplotlib.pyplot as plt
import data_proc as dp
from scipy.interpolate import CubicSpline
import unittest
import time


def cubic_spline_filter(deg_data, det_data, filter_len, out_file):
    """ use the cubic spline filter included in the scipy lib to filter and interpolation the voice data

    Args:
        deg_data (1Darray): degraded voice data
        det_data (1Darray): degraded point detection data file
        filter_len (int): the length of the cubic_spline filter, which means how many nearby data point will take part in the filtering
        out_file (String): the location where you want to save the wavform file

    Returns:
        res_data: the restored data after processing
    """
    # judge filter length is not odd
    if (filter_len % 2 == 0):
        return -1

    # judge filter length is 1
    if (filter_len == 1):
        return deg_data

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

            # get data addr array
            addr_range = np.arange(begin_addr, end_addr + 1)
            # get data array
            spline_arr = np.array([])
            for j in range(begin_addr, end_addr + 1):
                if j < 0:
                    spline_arr = np.append(spline_arr, 0)
                else:
                    spline_arr = np.append(spline_arr, deg_data[j])

            # remove noise point
            addr_range = np.delete(addr_range, (filter_len - 1) // 2)
            spline_arr = np.delete(spline_arr, (filter_len - 1) // 2)

            # utilize spline
            cs = CubicSpline(addr_range, spline_arr)

            addr_range_new = np.linspace(begin_addr, end_addr, 501)
            spline_arr_new = cs(addr_range_new)

            res_data[i] = spline_arr_new[250]
    if out_file != "":
        dp.save_wav(out_file, res_data, 8192)

    return res_data


def find_best_mse_spline():
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
    res_data = cubic_spline_filter(deg_data, det_data, 21, out_file)
    end_time = time.time()
    print("Time of spline(21) is ", end_time - start_time)

    print("MSE = ", dp.cal_mse(res_data, clean_data, det_len))
    dp.plot_input_fig(t, clean_data, deg_data, det_data, res_data)
    # find best mse using median filter
    mse_arr = []
    ergodic_arr = range(9, 30, 2)
    for i in ergodic_arr:
        res_data = cubic_spline_filter(deg_data, det_data, i, out_file)
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
    plt.title("MSE vs filter length (spline filter)")

    plt.show()


def save_demo_spline():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    deg_file = os.path.join(script_dir, "res", "degraded.wav")
    det_file = os.path.join(script_dir, "bk.npy")
    out_file = os.path.join(script_dir, "output_cubicSplines.wav")
    clean_file = os.path.join(script_dir, "res", "clean.wav")

    clean_data, deg_data, det_data, fs, t = dp.read_data(
        clean_file, deg_file, det_file)
    data_len = len(clean_data)
    det_len = sum(det_data)

    res_data = cubic_spline_filter(deg_data, det_data, 21, out_file)


class cubic_unit_test(unittest.TestCase):
    def test_cubic_spline_filter(self):
        result = cubic_spline_filter([1, 3, 80, 7, 9], [0, 0, 1, 0, 0], 5, "")
        target = np.array([1, 3, 5, 7, 9])
        self.assertEqual(result.tolist(), target.tolist())

    def test_cubic_spline_filter_even_input(self):
        result = cubic_spline_filter([1, 3, 80, 7, 9, 11], [
                                     0, 0, 1, 0, 0, 0], 6, "")
        target = -1
        self.assertEqual(result, target)


if __name__ == '__main__':
    unittest.main()
