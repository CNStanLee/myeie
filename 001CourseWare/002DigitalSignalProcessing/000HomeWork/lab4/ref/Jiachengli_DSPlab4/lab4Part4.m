clear
clc
% Load the audio file
file_path = 'OSR_us_000_0010_8k.wav';
[y, fs] = audioread(file_path);
noise = randn(1000,fs);
y_new = Gnoisegen(y, noise);
% Set parameters for the spectrogram
desired_window_duration = 0.10; % 100 ms
window_length = 2^nextpow2(round(desired_window_duration * fs)); % Round up to the nearest power of two
overlap = round(window_length / 2); % Set the overlap to be half the window length
nfft = window_length; % Number of FFT points, equal to window length for no zero-padding

% Create the spectrogram
[S, F, T] = spectrogram(y_new, window_length, overlap, nfft, fs);

% Plot the spectrogram in grayscale with white background
imagesc(T, F, 10*log10(abs(S)), [min(min(10*log10(abs(S)))) max(max(10*log10(abs(S))))]);

set(gca, 'YDir', 'normal'); % This is to ensure that the frequency axis is displayed correctly

% Set the figure background color to white
set(gcf, 'color', 'w');

% Add labels and title
xlabel('Time (seconds)');
ylabel('Frequency (Hz)');
title('Spectrogram of 100ms');

% Add a colorbar to show intensity
colorbar;

function[y] = Gnoisegen(x, noise)
    d = round(5000 * rand ( size (x)));
    N = length(x);
    noise_p = zeros(N, 1);
    for i = 1 : d : N
    noise_p(i) = noise(i);
    end
    y = x + noise_p;
end
