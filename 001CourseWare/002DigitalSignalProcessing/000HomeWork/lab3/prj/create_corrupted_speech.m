%% 1.3.1
% ------------------------------------------------
% clean
% ------------------------------------------------
clear;
close all;
% ------------------------------------------------
% input signal and make notes insertion
% ------------------------------------------------

filename = 'OSR_us_000_0010_8k.wav';

[y, fs] = audioread(filename); % Read in audio file
tsetp = 1/fs;
d     = tsetp * (length(y) - 1);
t = 0 : tsetp : d; 

% create notes and insert
% para of notes
note = 105;
start = 1;
amplitude = 0.5;
d_note = 30;
[x, new_t] = createNote(d_note, note, fs, start, amplitude);

% make size same
% add two signal up
x = [x ; zeros(length(y) - length(x), 1)];
corrupted_speech = y + x;
%sound(corrupted_speech);

% plot origin waveform
figure(Name = "Signal with note");
subplot(3, 1, 1);
plot(t, y);
title('Original x(t)') % title of the figure
xlabel('t(s)') % label for x
ylabel('Amplitude')    % label for y
subplot(3, 1, 2);
plot(t, x);
title('note signal') % title of the figure
xlabel('t(s)') % label for x
ylabel('Amplitude')    % label for y
subplot(3, 1, 3);
plot(t, corrupted_speech);
title('distorted signal') % title of the figure
xlabel('t(s)') % label for x
ylabel('Amplitude')    % label for y
sgtitle("Signal with note");

DMSE = mean((x - y) .^ 2);
fprintf("distorted mse = %.4f\n", DMSE);
