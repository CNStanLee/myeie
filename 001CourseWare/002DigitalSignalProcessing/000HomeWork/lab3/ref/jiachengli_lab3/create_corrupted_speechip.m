clear
clc
filename = 'OSR_us_000_0010_8k.wav';
[y, Fs] = audioread(filename);

%super-imposed tone created with createNote.m
%use same sampling frequency as the speech file i.e. fs=8000Hz
note = 105; % set note
note_2 = 30; %set note2
start = 1; % set start
d = 0.3; % set duration(0 - 1)
amplitude = 0.7; % set amplitude(0 - 1)
[x_noise,new_t] = createNote(d, note, Fs, start,amplitude);
[x_noise2,new_t_2] = createNote(d, note_2, Fs, start,amplitude);
%add the two signals (wav file and tone)
%x=...;
% for noise_1
x_l = length(x_noise);
y_l = length(y);
corrupted_speech = zeros(y_l, 2);
for  i = 1 : x_l
    corrupted_speech(i, 1) = x_noise(i) + y(i);
end
for i = (x_l + 1) : y_l
    corrupted_speech(i, 1) = y(i);
end
% for noise_2
x_l2 = length(x_noise2);
y_l2 = length(y);
for  i = 1 : x_l2
    corrupted_speech(i, 2) = x_noise2(i) + y(i);
end
for i = (x_l2 + 1) : y_l2
    corrupted_speech(i, 2) = y(i);
end
%listen to the resulting corrupted speech
% sound(corrupted_speech);

%% wav input
%% 1.3.1
% set noise and test
% t = 1 : 1 : y_l;
% t = t.';
% subplot(3, 1, 1)
% plot(t, y)
% subplot(3, 1, 2)
% plot(new_t, x_noise)
% subplot(3, 1, 3)
% plot(t, corrupted_speech)

%% 1.3.2
% filter design and test carefully
nfft = 2^17;
x = corrupted_speech;
for i = 1 : y_l 
   MSE_o = (1 / y_l) * (x(i) - y(i))^2;
end
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
    if ( max_point == (2 * abs(X(i))))
        nfft_point = i;
    end
end
fvec_point = fstep * (nfft_point - 1);
disp(max_point);
disp(fvec_point);

%% Design the full-precision FIR
Hd = clears;
d = zeros(y_l, 2);
d(:,1) = filter(Hd, x(:,1));
Hd = clears_2;
d(:,2) = filter(Hd, x(:,2));
X_new = fft(d, nfft);
fstep = Fs/nfft;
fvec = fstep*(0: nfft/2 - 1);
fresp_new = 2*abs(X_new(1:nfft/2));
figure(2); 
plot(fvec, fresp_new)
ylim([0, 250])
title('signal pass through filter')
xlim([0, 1000]) 
sound(d, Fs)
figure(3);
t = 1 : y_l;
subplot(2,1,1)
plot(t,x)
subplot(2,1,2)
plot(t,d)
% calculate MSE
for i = 1 : y_l 
   MSE_r = (1 / y_l) * (d(i) - x(i))^2;
end