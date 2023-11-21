import numpy as np
import unittest
import wave
from scipy.io import wavfile
import matplotlib.pyplot as plt


if __name__ == '__main__':

    fs_clean, clean_data = wavfile.read('./res/clean.wav')
    fs_deg, deg_data = wavfile.read('./res/degraded.wav')

    # rerange the amplitude of the waveform signal
    clean_data = clean_data / 2**16
    deg_data = deg_data / 2**15

    t = np.arange(0, len(clean_data)) / fs_clean


    # plt.figure(figsize=(10, 4)) 
    # plt.plot(t, clean_data)
    # plt.xlabel("Time (s)")
    # plt.ylabel("Amplitude")
    # plt.show()

    # find real residual of the signal

    real_residual = abs(fs_clean - fs_deg)

    plt.figure(figsize=(4, 10))

    plt.subplot(2,1,1)
    plt.plot(t, clean_data)
    plt.xlabel("Time (s)")
    plt.ylabel("Amplitude")
    plt.title("Clean data")
    plt.ylim(-1, 1)

    plt.subplot(2,1,2)
    plt.plot(t, deg_data)
    plt.xlabel("Time (s)")
    plt.ylabel("Amplitude")
    plt.title("Degraded data")
    plt.ylim(-1, 1)

    plt.show()


