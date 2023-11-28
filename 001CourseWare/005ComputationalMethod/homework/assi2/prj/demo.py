import numpy as np
import unittest
import wave
import matplotlib.pyplot as plt
import os
from tqdm import tqdm
from median_fil import find_best_mse_median
from median_fil import save_demo_median
from spline_fil import find_best_mse_spline
from spline_fil import save_demo_spline
from scipy.io import wavfile


if __name__ == '__main__':
    """
    main funciton to demo two median filter
    """   
    # demostrate finding best filter length
    # find_best_mse_median()
    # find_best_mse_spline()
    # demostrate saving the result audio to file
    save_demo_median()
    save_demo_spline()
    
    script_dir = os.path.dirname(os.path.abspath(__file__))
    median_file = os.path.join(script_dir, "output_medianFilter.wav")
    fs_median, median_data = wavfile.read(median_file)
    median_data = median_data / 2**15
    t = np.arange(0, len(median_data)) / fs_median 
    plt.figure(figsize=(8, 5))
    plt.plot(t, median_data)
    plt.xlabel("Time (s)")
    plt.ylabel("Amplitude")
    plt.title("Median Result data")
    plt.show()
    
    script_dir = os.path.dirname(os.path.abspath(__file__))
    spline_file = os.path.join(script_dir, "output_cubicSplines.wav")
    fs_spline, spline_data = wavfile.read(spline_file)
    spline_data = spline_data / 2**15 
    t = np.arange(0, len(spline_data)) / fs_spline 
    plt.figure(figsize=(8, 5))
    plt.plot(t, spline_data)
    plt.xlabel("Time (s)")
    plt.ylabel("Amplitude")
    plt.title("Spline Result data")
    plt.show()
    

    
    
    
    


    


    



