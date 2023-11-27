import os
import numpy as np
from tqdm import tqdm

import data_proc as dp
from data_proc import cal_mse
from data_proc import plot_input_fig
from data_proc import read_data

def cubic_spline_filter(deg_data, det_data, filter_len, out_file):
        
    # judge filter length is not odd
    if(filter_len % 2 == 0):
        return -1
    # judge filter length is 1
    if(filter_len  == 1):
        return deg_data
    
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
            
            # get data addr array
            addr_range = np.arange(begin_addr, end_addr + 1)
            # get data array
            spline_arr = np.array([])
            for j in range(begin_addr, end_addr + 1):
                if j < 0 : 
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
    
    return res_data   

def find_best_mse_spline():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    deg_file = os.path.join(script_dir, "res", "degraded.wav")
    det_file = os.path.join(script_dir, "bk.npy")
    out_file = os.path.join(script_dir, "output.wav")
    clean_file = os.path.join(script_dir, "res", "clean.wav")

    clean_data, deg_data, det_data, fs, t = read_data(clean_file, deg_file, det_file)
    data_len = len(clean_data)
    det_len = sum(det_data)
    
    res_data = cubic_spline_filter(deg_data, det_data, 81, out_file)
    print("MSE = ", cal_mse(res_data, clean_data, det_len))
    plot_input_fig(t, clean_data, deg_data, det_data, res_data)
    # find best mse using median filter
    mse_arr = []
    for i in range(1, 100, 2):
        res_data = cubic_spline_filter(deg_data, det_data, i, out_file)
        # plot_input_fig(t, clean_data, deg_data, det_data, res_data)
        c_mse = cal_mse(res_data, clean_data, det_len)
        print("size = ", i, "MSE = ", c_mse)
        mse_arr.append(c_mse)
    print(mse_arr)