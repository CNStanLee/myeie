import matplotlib.pyplot as plt
from scipy.io import wavfile
import numpy as np

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
    clean_data, deg_data = read_data()
    # find real residual of the signal
    real_residual = abs(clean_data - deg_data)
    bk = (real_residual > 0.1).astype(int) 
    # plot figure of the data
    # plot_input_fig(t, clean_data, deg_data, bk)
    # save bk data to file
    np.save("bk.npy", bk)
    
def cal_mse(res_data, clean_data, det_len):
    return np.sum((res_data - clean_data) ** 2) / det_len