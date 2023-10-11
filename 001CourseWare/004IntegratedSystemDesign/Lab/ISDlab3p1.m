[x,Fs] = audioread('speech_3.wav'); % Read in audio file


% Plot to find out which frequency to remove from signal
nfft = 2^10;        % point num of fft

X = fft(x, nfft);   % fast fourier transform
fstep = Fs/nfft;    % step size of the Frequency in figure
fvec = fstep*(0: nfft/2-1); % x of the figure range from 0 to nfft/2 -1

fresp = 2*abs(X(1:nfft/2));     % take 1/2 abs val of X
plot(fvec,fresp)                % plot the figure 
title('Single-Sided Amplitude Spectrum of x(t)') % title of the figure
xlabel('Frequency (Hz)') % label for x
ylabel('|X(f)|')    % label for y

% 4.2 I
[Xf_max, Xf_max_index] =  max(fresp);   % find the peak val of the figure
Xf_max_f = fvec(Xf_max_index);      % find f in fvec with index of max Xf
disp(Xf_max);   % disp val of Xf
disp(Xf_max_f); % disp val of f

% Utilize the filter
HD = LPF2;

X = filter(HD, X);
fstep = Fs/nfft;    % step size of the Frequency in figure
fvec = fstep*(0: nfft/2-1); % x of the figure range from 0 to nfft/2 -1


figure;

fresp = 2*abs(X(1:nfft/2));     % take 1/2 abs val of X
plot(fvec,fresp)                % plot the figure 
title('Single-Sided Amplitude Spectrum of x(t)') % title of the figure
xlabel('Frequency (Hz)') % label for x
ylabel('|X(f)|')    % label for y


