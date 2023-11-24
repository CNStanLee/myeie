import numpy as np
import unittest
import wave
from scipy.io import wavfile
import matplotlib.pyplot as plt
import os
from tqdm import tqdm

def read_data(clean_file, deg_file, det_file):
    """read audio data from files

    Returns:
        clean_data : clean audio data
        deg_data   : degraded audio data
        fs         : sampling frequency
        t          : time line of the data
    """
    fs_clean, clean_data = wavfile.read(clean_file)
    fs_deg, deg_data = wavfile.read(deg_file)

    # rerange the amplitude of the waveform signal
    clean_data = clean_data / 2**16
    deg_data = deg_data / 2**15
    t = np.arange(0, len(clean_data)) / fs_clean
    fs = fs_clean
    
    det_data = np.load(det_file)

    return clean_data, deg_data, det_data, fs, t

def plot_input_fig(t, clean_data, deg_data, bk_data, res_data):
    """ plot figure of the input data

    Args:
        t : time line of the data
        clean_data : clean audio data
        deg_data : degraded audio data
        bk_data : real detection data
    """
    plt.figure(figsize=(4, 10))
    # figsize=(4, 20)
    plt.subplot(4,1,1)
    plt.plot(t, clean_data)
    plt.xlabel("Time (s)")
    plt.ylabel("Amplitude")
    plt.title("Clean data")
    plt.ylim(-1, 1)

    plt.subplot(4,1,2)
    plt.plot(t, deg_data)
    plt.xlabel("Time (s)")
    plt.ylabel("Amplitude")
    plt.title("Degraded data")
    plt.ylim(-1, 1)
    
    plt.subplot(4,1,3)
    plt.plot(t, bk_data)
    plt.xlabel("Time (s)")
    plt.ylabel("Bk")
    plt.title("Bk data")
    plt.ylim(0, 1)
    
    plt.subplot(4,1,4)
    plt.plot(t, res_data)
    plt.xlabel("Time (s)")
    plt.ylabel("Res")
    plt.title("Res data")
    plt.ylim(-1, 1)

    plt.show()

def data_prepare():
    # read audio data from the files
    clean_data, deg_data, fs, t = read_data()
    # find real residual of the signal
    real_residual = abs(clean_data - deg_data)
    bk = (real_residual > 0.1).astype(int) 
    # plot figure of the data
    # plot_input_fig(t, clean_data, deg_data, bk)
    # save bk data to file
    np.save("bk.npy", bk)
    
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

def cal_mse(res_data, clean_data, det_len):
    return np.sum((res_data - clean_data) ** 2) / det_len

def find_best_mse_median():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    deg_file = os.path.join(script_dir, "res", "degraded.wav")
    det_file = os.path.join(script_dir, "bk.npy")
    out_file = os.path.join(script_dir, "output.wav")
    clean_file = os.path.join(script_dir, "res", "clean.wav")

    clean_data, deg_data, det_data, fs, t = read_data(clean_file, deg_file, det_file)
    data_len = len(clean_data)
    det_len = sum(det_data)
    
    res_data = median_filter(deg_data, det_data, 5, out_file)
    # plot_input_fig(t, clean_data, deg_data, det_data, res_data)
    print("MSE = ", cal_mse(res_data, clean_data, det_len))
    
    # find best mse using median filter
    mse_arr = []
    for i in [1, 3, 5, 7, 9]:
        res_data = median_filter(deg_data, det_data, i, out_file)
        # plot_input_fig(t, clean_data, deg_data, det_data, res_data)
        c_mse = cal_mse(res_data, clean_data, det_len)
        print("size = ", i, "MSE = ", c_mse)
        mse_arr.append(c_mse)
    print(mse_arr)
    

if __name__ == '__main__':
    script_dir = os.path.dirname(os.path.abspath(__file__))
    deg_file = os.path.join(script_dir, "res", "degraded.wav")
    det_file = os.path.join(script_dir, "bk.npy")
    out_file = os.path.join(script_dir, "output.wav")
    clean_file = os.path.join(script_dir, "res", "clean.wav")

    clean_data, deg_data, det_data, fs, t = read_data(clean_file, deg_file, det_file)
    data_len = len(clean_data)
    det_len = sum(det_data)
    
    res_data = median_filter(deg_data, det_data, 5, out_file)
    # plot_input_fig(t, clean_data, deg_data, det_data, res_data)
    print("MSE = ", cal_mse(res_data, clean_data, det_len))
    
    # find best mse using median filter
    mse_arr = []
    for i in [1, 3, 5, 7, 9]:
        res_data = median_filter(deg_data, det_data, i, out_file)
        # plot_input_fig(t, clean_data, deg_data, det_data, res_data)
        c_mse = cal_mse(res_data, clean_data, det_len)
        print("size = ", i, "MSE = ", c_mse)
        mse_arr.append(c_mse)
    print(mse_arr)
    
    
    
    


    


    



