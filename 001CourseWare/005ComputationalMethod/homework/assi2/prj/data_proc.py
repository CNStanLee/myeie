import matplotlib.pyplot as plt
from scipy.io import wavfile
import numpy as np
import wave


def read_data(clean_file, deg_file, det_file):
    """Read data from the voice file and adjust its size

    Args:
        clean_file (String): file path of the clean voice file
        deg_file (String): file path of the degraded voice file
        det_file (String): file pathe of the detection file

    Returns:
        clean_data: clean data array
        dege_data : degraded data array
        det_data: detection data array
        fs: sampling frequency
        t: time axis of the voice data

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

    plt.subplot(2, 1, 1)
    plt.plot(t, clean_data)
    plt.xlabel("Time (s)")
    plt.ylabel("Amplitude")
    plt.title("Clean data")
    plt.ylim(-1, 1)

    plt.subplot(2, 1, 2)
    plt.plot(t, deg_data)
    plt.xlabel("Time (s)")
    plt.ylabel("Amplitude")
    plt.title("Degraded data")
    plt.ylim(-1, 1)

    plt.show()

    plt.figure(figsize=(4, 10))
    plt.subplot(2, 1, 1)
    plt.plot(t, bk_data)
    plt.xlabel("Time (s)")
    plt.ylabel("Bk")
    plt.title("Bk data")
    plt.ylim(0, 1)

    plt.subplot(2, 1, 2)
    plt.plot(t, res_data)
    plt.xlabel("Time (s)")
    plt.ylabel("Res")
    plt.title("Res data")
    plt.ylim(-1, 1)

    plt.show()


def data_prepare():
    """ Used for generate detection data file
    """
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
    """calculate the mse between original data and restored data

    Args:
        res_data (1Darray): restored data after process
        clean_data (1Darray): original clean data
        det_len (int): total number of the error detections

    Returns:
        mse : mse between two data
    """
    return np.sum((res_data - clean_data) ** 2) / det_len


def save_wav(filename, data, sample_rate):
    """
    Save array to wav file 

    Parameters:
    - filename: name of the wavfile
    - data: audio data array
    - sample_rate: fs of the wav file
    """
    with wave.open(filename, 'w') as wf:
        wf.setnchannels(1)
        wf.setsampwidth(2)
        wf.setframerate(sample_rate)
        # transform the data back to original size
        wf.writeframes((data * 32767).astype(np.int16).tobytes())
