clear
clc
%% wav input
[x,Fs] = audioread('audio.wav');
nfft = 2^17;
%x = x(:,2);
X = fft(x, nfft);
fstep = Fs/nfft;
fvec = fstep*(0: nfft/2 - 1);
fresp = 2*abs(X(1:nfft/2));
plot(fvec, fresp)
title('Signle-Sided Amplitude Spectrum of x1(t)')
xlabel('Frequency (Hz)')
ylabel('|X(f)|')
ylim([0, 250])
xlim([0, 1000])
%sound(x,Fs)
max_point = max(fresp);
for i = 1: nfft/2
    if ( max_point == (2 * abs(X(i, 1))))
        nfft_point = i;
    end
end
fvec_point = fstep * (nfft_point - 1);
for i = 1: nfft/2
    if ( max_point == (2 * abs(X(i, 2))))
        nfft_point = i;
    end
end
fvec_point_2 = fstep * (nfft_point - 1);
disp(max_point);
disp(fvec_point);
disp(fvec_point_2);
%% Design the full-precision FIR
Hd = Audio_stop;
d(:,1) = filter(Hd, x(:, 1));
d(:, 2) = filter(Hd, x(:, 2));
X_new = fft(d, nfft);
fstep = Fs/nfft;
fvec = fstep*(0: nfft/2 - 1);
fresp_new = 2*abs(X_new(1:nfft/2, 2));
figure(2); 
plot(fvec, fresp_new)
ylim([0, 250])
title('signal pass through filter')
xlim([0, 1000]) 
sound(d, Fs)
figure(3);
t = 1 : 240000;
subplot(2,1,1)
plot(t,x)
subplot(2,1,2)
plot(t,d)