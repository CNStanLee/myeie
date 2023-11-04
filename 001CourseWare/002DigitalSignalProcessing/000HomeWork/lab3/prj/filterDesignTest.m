%% 1.3.1(test) & 1.3.2
% 1.3.1 is fully implemented in create_corrupted_speech.m
% ------------------------------------------------
% clean
% ------------------------------------------------
clear;
close all;
% ------------------------------------------------
% input signal and make notes insertion
% ------------------------------------------------

[xclean, fs] = audioread('OSR_us_000_0010_8k.wav'); % Read in audio file
tsetp = 1/fs;
d     = tsetp * (length(xclean) - 1);
t = 0 : tsetp : d; 

% create notes and insert
% para of notes
note = 105;
start = 1;
amplitude = 0.5;
d_note = 30;
[note1, note1_t] = createNote(d_note, note, fs, start, amplitude);

% make size same
% add two signal up
note1 = [note1 ; zeros(length(xclean) - length(note1), 1)];
xdis = xclean + note1;

% plot origin waveform
figure(Name = "Signal with note");
subplot(3, 1, 1);
plot(t, xclean);
title('Original x(t)') % title of the figure
xlabel('t(s)') % label for x
ylabel('Amplitude')    % label for y
subplot(3, 1, 2);
plot(t, note1);
title('note signal') % title of the figure
xlabel('t(s)') % label for x
ylabel('Amplitude')    % label for y
subplot(3, 1, 3);
plot(t, xdis);
title('distorted signal') % title of the figure
xlabel('t(s)') % label for x
ylabel('Amplitude')    % label for y
sgtitle("Signal with note");

% ------------------------------------------------
% analysis of the distorted signal
% ------------------------------------------------

% fft
nfft = 2^10;        % point num of fft
X = fft(xdis, nfft);   % fast fourier transform
fstep = fs/nfft;    % step size of the Frequency in figure
fvec = fstep * (0 : nfft/2-1); % x of the figure range from 0 to nfft/2 -1
fresp = 2*abs(X(1:nfft/2));     % take 1/2 abs val of X

% plot of the fft analysis

figure(Name="Analysis of Corrupted Signal");
subplot(2,1,1);
% plot origin signal
plot(t, xdis);
title('Original x(t)') % title of the figure
xlabel('t(s)') % label for x
ylabel('Amplitude')    % label for y
% plot to find out which frequency to remove from signal
subplot(2,1,2);
plot(fvec, fresp)                % plot the figure 
title('Single-Sided Amplitude Spectrum of x(t)') % title of the figure
xlabel('Frequency (Hz)') % label for x
ylabel('|X(f)|')    % label for y
sgtitle("Analysis of Corrupted Signal");

% find max freq and their loc
[dis_val, dis_val_loc] = max(fresp);
dis_loc = fvec(dis_val_loc);

fprintf("dis_freq_val = %.2f\n", dis_val);
fprintf("dis_freq_loc = %.2f\n", dis_loc);

%sound(xdis, fs);

% ------------------------------------------------
% filtering
% ------------------------------------------------

% parameter of the filter

filter_type = 'butter';
Fpass = 1000; % First Passband Frequency
Fstop = 3500; % Second Stopband Frequency
Apass = 1; % Passband Ripple (dB)
Astop = 60; % Second Stopband Attenuation (dB)
match = 'stopband'; % Ban d to match exactly

% lowpass filter

% filter1
h = fdesign.lowpass(Fpass, Fstop, Apass, Astop, fs);
Hd = design(h, filter_type, 'MatchExactly', match);

% excute filter
xf1 = filter(Hd, xdis);

% plot origin waveform
figure(Name = "Result of the filter");
subplot(3, 1, 1);
plot(t, xclean);
title('Original x(t)') % title of the figure
xlabel('t(s)') % label for x
ylabel('Amplitude')    % label for y
subplot(3, 1, 2);
plot(t, xdis);
title('x distorted') % title of the figure
xlabel('t(s)') % label for x
ylabel('Amplitude')    % label for y
subplot(3, 1, 3);
plot(t, xf1);
title('x filtered') % title of the figure
xlabel('t(s)') % label for x
ylabel('Amplitude')    % label for y
sgtitle("Result of the filter");

sound(xf1, fs);
% ------------------------------------------------
% evaluation
% ------------------------------------------------

DMSE = mean((xdis - xclean) .^ 2);
fprintf("distorted mse = %.4f\n", DMSE);

MSE = mean((xf1 - xclean) .^ 2);
fprintf("filter: %s , filter mse = %.4f\n",filter_type, MSE);

%% 1.3.2 evaluate performance of different filter(Optional stretch goal)
% ------------------------------------------------
% clean
% ------------------------------------------------
clear;
close all;

% ------------------------------------------------
% generate corrupted speech
% ------------------------------------------------
[xclean, fs] = audioread('OSR_us_000_0010_8k.wav'); % Read in audio file
xdis = ceateCorSpe(xclean, fs, 105);
% ------------------------------------------------
% filter & evaluate
% ------------------------------------------------

fprintf("-----Test Begin-----\n");
fprintf("type\tFpass\tFstop\tApass\tAstop\tMSE  \tOrder\n");

%filter_type = 'butter';
%Fpass = 1000; % First Passband Frequency
%Fstop = 3000; % Second Stopband Frequency
Apass = 1; % Passband Ripple (dB)
%Astop = 80; % Second Stopband Attenuation (dB)
%match = 'stopband'; % Ban d to match exactly

filter_type_array = {'butter', 'cheby1'};
Fpass_array = [800 1000 1100];
Fstop_array = [3000 3500 3800];
Astop_array = [50 60 70];

for i = 1 : 1 : 2
    for j = 1 : 1 : 3
        for k = 1: 1 : 3
            for h = 1 : 1 : 3
                [xf1, t ,p] = excuteFilter(xdis, fs, filter_type_array{i}, Fpass_array(j), Fstop_array(k), Apass, Astop_array(h));
                mse = evaluateFilter(xclean, xf1);
                fprintf("%s\t%.1f\t%d\t%.4f\t%.4f\t%.6f\t%d\n",filter_type_array{i}, Fpass_array(j), Fstop_array(k), Apass, Astop_array(h), mse, p);
            end
        end
    end
end

fprintf("-----Test End-----\n");

%% 1.3.3 deal with super-imposed tone

% ------------------------------------------------
% clean
% ------------------------------------------------
clear;
close all;

% ------------------------------------------------
% generate corrupted speech
% ------------------------------------------------
[xclean, fs] = audioread('OSR_us_000_0010_8k.wav'); % Read in audio file
[xdis, t] = ceateCorSpe(xclean, fs, 30);
% ------------------------------------------------
% filter & evaluate
% ------------------------------------------------

filter_type = 'butter';
Fpass = 300; % First Passband Frequency
Fstop = 50; % Second Stopband Frequency
Apass = 1; % Passband Ripple (dB)
Astop = 80; % Second Stopband Attenuation (dB)
match = 'stopband'; % Ban d to match exactly

% highpass filter

% filter1

h = fdesign.highpass(Fstop, Fpass, Astop, Apass, fs);
Hd = design(h, filter_type, 'MatchExactly', match);

% excute filter
xf1 = filter(Hd, xdis);

% plot origin waveform
figure(Name = "Result of the filter");
subplot(3, 1, 1);
plot(t, xclean);
title('Original x(t)') % title of the figure
xlabel('t(s)') % label for x
ylabel('Amplitude')    % label for y
subplot(3, 1, 2);
plot(t, xdis);
title('x distorted') % title of the figure
xlabel('t(s)') % label for x
ylabel('Amplitude')    % label for y
subplot(3, 1, 3);
plot(t, xf1);
title('x filtered') % title of the figure
xlabel('t(s)') % label for x
ylabel('Amplitude')    % label for y
sgtitle("Result of the filter");

%sound(xf1, fs);
% ------------------------------------------------
% evaluation
% ------------------------------------------------

MSE = mean((xf1 - xclean) .^ 2);
fprintf("fpass : %d,filter: %s , filter mse = %.4f\n",Fpass, filter_type, MSE);

%sound(xdis, fs);
%% 1.3.4 deal with two super-imposed tone

% ------------------------------------------------
% clean
% ------------------------------------------------
clear;
close all;

% ------------------------------------------------
% generate corrupted speech
% ------------------------------------------------
[xclean, fs] = audioread('OSR_us_000_0010_8k.wav'); % Read in audio file
[xdis] = ceateCorSpe(xclean, fs, 30);
[xdis, t] = ceateCorSpe(xdis, fs, 105);
% ------------------------------------------------
% filter & evaluate
% ------------------------------------------------

% highpass filter
filter_type = 'butter';
Fpass = 300; % First Passband Frequency
Fstop = 50; % Second Stopband Frequency
Apass = 1; % Passband Ripple (dB)
Astop = 80; % Second Stopband Attenuation (dB)
match = 'stopband'; % Ban d to match exactly

% filter1

h = fdesign.highpass(Fstop, Fpass, Astop, Apass, fs);
Hd = design(h, filter_type, 'MatchExactly', match);

% excute filter1
xf1 = filter(Hd, xdis);

% lowpass filter
filter_type = 'butter';
Fpass = 1000; % First Passband Frequency
Fstop = 3500; % Second Stopband Frequency
Apass = 1; % Passband Ripple (dB)
Astop = 60; % Second Stopband Attenuation (dB)
match = 'stopband'; % Ban d to match exactly

% lowpass filter

% filter1
h = fdesign.lowpass(Fpass, Fstop, Apass, Astop, fs);
Hd = design(h, filter_type, 'MatchExactly', match);

% excute filter
xf2 = filter(Hd, xf1);

% plot origin waveform
figure(Name = "Result of the filter");
subplot(3, 1, 1);
plot(t, xclean);
title('Original x(t)') % title of the figure
xlabel('t(s)') % label for x
ylabel('Amplitude')    % label for y
subplot(3, 1, 2);
plot(t, xdis);
title('x distorted') % title of the figure
xlabel('t(s)') % label for x
ylabel('Amplitude')    % label for y
subplot(3, 1, 3);
plot(t, xf2);
title('x filtered') % title of the figure
xlabel('t(s)') % label for x
ylabel('Amplitude')    % label for y
sgtitle("Result of the filter");

sound(xf2, fs);
% ------------------------------------------------
% evaluation
% ------------------------------------------------

MSE = mean((xf2 - xclean) .^ 2);
fprintf("fpass : %d,filter: %s , filter mse = %.4f\n",Fpass, filter_type, MSE);

%sound(xdis, fs);