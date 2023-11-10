% clean
%

clear;
close all;

% Past 1 Original signal
%

[x,Fs] = audioread('audio.wav'); % Read in audio file



figure(Name="Figure 1 Original Signal");

subplot(2,1,1);
tsetp = 1/Fs;
t = 0 : tsetp : tsetp * (length(x) - 1); 
plot(t, x);
title('Original x(t)') % title of the figure
xlabel('t(s)') % label for x
ylabel('Amplitude')    % label for y

% Plot to find out which frequency to remove from signal
subplot(2,1,2);
nfft = 2^10;        % point num of fft
X = fft(x, nfft);   % fast fourier transform
fstep = Fs/nfft;    % step size of the Frequency in figure
fvec = fstep * (0 : nfft/2-1); % x of the figure range from 0 to nfft/2 -1

fresp = 2*abs(X(1:nfft/2));     % take 1/2 abs val of X
plot(fvec,fresp)                % plot the figure 
title('Single-Sided Amplitude Spectrum of x(t)') % title of the figure
xlabel('Frequency (Hz)') % label for x
ylabel('|X(f)|')    % label for y

%sgtitle("Figure 1 Original Signal");

% Part 2 find max val of the spectrum
%

[Xf_max, Xf_max_index] =  max(fresp);   % find the peak val of the figure
Xf_max_f = fvec(Xf_max_index);      % find f in fvec with index of max Xf

fprintf("Xf_max = %.4f \r\n", Xf_max); % disp val of Xf
fprintf("Xf_max_f = %.4f \r\n", Xf_max_f); % disp val of f




% Part5 implement with the quantised high-pass filter

%HD = HPF3B;
HD = bandpass1;
filtered_x = double(filter(HD, x));

figure(Name="Figure 3 Final Filtered Signal(HPFQ)");

subplot(2,1,1);
tsetp = 1/Fs;
t = 0 : tsetp : tsetp * (length(filtered_x) - 1); 
plot(t, filtered_x);
title('Filtered x(t)') % title of the figure
xlabel('t(s)') % label for x
ylabel('Amplitude')    % label for y

% Plot to find out which frequency to remove from signal
subplot(2,1,2);
nfft = 2^10;        % point num of fft
filtered_X = fft(filtered_x, nfft);   % fast fourier transform
fstep = Fs/nfft;    % step size of the Frequency in figure
fvec = fstep * (0 : nfft/2-1); % x of the figure range from 0 to nfft/2 -1

fresp = 2*abs(filtered_X (1:nfft/2));     % take 1/2 abs val of X
plot(fvec,fresp)                % plot the figure 
title('Single-Sided Amplitude Spectrum of Filtered x(t)') % title of the figure
xlabel('Frequency (Hz)') % label for x
ylabel('|filtered X(f)|')    % label for y

%sgtitle("Figure 2 Final Filtered Signal(HPFQ)");

%sound(x, Fs);
sound(filtered_x , Fs);
audiowrite('final_filter.wav', filtered_x, Fs);

