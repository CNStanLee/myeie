import os
import numpy as np
from tqdm import tqdm

import data_proc as dp


def median_filter(deg_data, det_data, filter_len, out_file):
    
    # judege filter length is not odd
    if(filter_len % 2 == 0):
        return -1
    
    # copy for result data
    res_data = np.array(deg_data)
    
    # find the bk point
    for i in tqdm(range(len(deg_data))):
        # judge if the detection is 1 means need interpolation
        if(det_data[i]):
            # error point detected, interpolation needed
            # find median array: filter_len / 2
            begin_addr = i - filter_len // 2
            end_addr = i + filter_len // 2
            median_arr = np.array([])
            for j in range(begin_addr, end_addr + 1):
                if j < 0 : 
                    median_arr = np.append(median_arr, 0)
                else:
                    median_arr = np.append(median_arr, deg_data[j])
            # sort the array
            median_arr.sort()
            median_val = median_arr[filter_len // 2]
            res_data[i] = median_val
    
    return res_data

def find_best_mse_median():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    deg_file = os.path.join(script_dir, "res", "degraded.wav")
    det_file = os.path.join(script_dir, "bk.npy")
    out_file = os.path.join(script_dir, "output.wav")
    clean_file = os.path.join(script_dir, "res", "clean.wav")

    clean_data, deg_data, det_data, fs, t = dp.read_data(clean_file, deg_file, det_file)
    data_len = len(clean_data)
    det_len = sum(det_data)
    
    res_data = median_filter(deg_data, det_data, 5, out_file)
    dp.plot_input_fig(t, clean_data, deg_data, det_data, res_data)
    print("MSE = ", dp.cal_mse(res_data, clean_data, det_len))
    
    # find best mse using median filter
    mse_arr = []
    for i in [1, 3, 5, 7, 9]:
        res_data = median_filter(deg_data, det_data, i, out_file)
        # plot_input_fig(t, clean_data, deg_data, det_data, res_data)
        c_mse = cal_mse(res_data, clean_data, det_len)
        print("size = ", i, "MSE = ", c_mse)
        mse_arr.append(c_mse)
    print(mse_arr)     