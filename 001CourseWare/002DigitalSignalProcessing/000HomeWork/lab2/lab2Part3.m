
% 1.4.3
note_durations = [0.25, 0.125, 0.125, 0.25, 0.125];
note_pitch = [64, 64, 62, 64, 57];
fs = 8000;


melody = createMelody(note_durations, note_pitch, fs);
d = sum(note_durations); % calculate the total time
t = 0 : 1/fs : (d - 1 / fs);

%sound(melody, fs);

% save the melody
filename = 'Melody1.wav';
audiowrite(filename, melody, fs);

figure;
plot(t, melody);
xlabel('time t(s)');
ylabel('Amplitude');
xlim([0, d]);
ylim([-2, 2]);
title('Figure 5 Melody Waveform');
grid on;

% 1.4.4
note_pitch2 = note_pitch + 12;
note_durations2 = note_durations ./ 1.5;

melody2 = createMelody(note_durations2, note_pitch2, fs);
%d = sum(note_durations2); % calculate the total time
%t = 0 : 1/fs : (d - 1 / fs);

sound(melody2, fs);

% save the melody
filename = 'Melody1_Fast_highPatch.wav';
audiowrite(filename, melody2, fs);

%%
%1.4.5
%Create Music Test

fs = 8000;

note_durations = [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5];
note_pitch = [60, 60, 67, 67, 69, 69, 67];
start_time = [1, 2, 3, 4, 5, 6, 7];

music = createMusic(note_durations, note_pitch, start_time, fs);

d = length(music) / fs;
t = 0 : 1/fs : (d - 1 / fs);

filename = 'Music.wav';
audiowrite(filename, music, fs);

figure;
plot(t, music);
xlabel('time t(s)');
ylabel('Amplitude');
xlim([0, d]);
ylim([-2, 2]);
title('Figure 6 Music Waveform');
grid on;

sound(music, fs);

%%
%clear
clear;
close all;
%parameter define
fs = 4000;
d = 2;
f0 = 261.63; %60 C4

t = 0 : (1/fs) : (d -(1/fs));
xt = sin(2 * pi * f0 * t);

%plot the origin signal
figure("Name",'Figure 6 sinewave(f0 = 261.63 C4)')

subplot(2, 1, 1);
plot(t, xt);
title('Origin Singal');
xlabel('time t(s)');
ylabel('Amplitude');
xlim([0, 0.05]);
ylim([-1, 1]);
grid on;



%xt2 = resample(xt, fs2, fs);

%resample the signal

L = 2; % sampling factor
fs2 = L * fs; 
y = zeros(1, L * length(t));
y(1 : L : length(y)) = xt;

%plot the resampled signal
t2 = 0 : (1/fs2) : (d -(1/fs2));

subplot(2, 1, 2);
plot(t2, y);
title('Upsampled Signal');
xlabel('time t(s)');
ylabel('Amplitude');
xlim([0, 0.05]);
ylim([-1, 1]);
grid on;

sgtitle('Figure 6 sinewave(f0 = 261.63 C4)');
%%
% 1.5.2

load handel.mat;

% find the freq of the origin signal

figure(Name='Figure 7 UpSampling');
%original signal

y_o = y;
fs = 8192;
t = 0 : 1/fs : (length(y) - 1)/fs;

%plot original signal
subplot(3,1,1);
plot(t, y);
title('Original Signal');
xlabel('time t(s)');
ylabel('Amplitude');
xlim([0, 0.01]);
ylim([-1, 1]);
grid on;

%resample the signal

L = 3; % sampling factor
fs2 = L * fs; 
y = zeros(1, ceil(L * length(t)));
y(1 : L : length(y)) = y_o;
t2 = 0 : (1/fs2) : (length(y)/fs2 -(1/fs2));

%plot downsampling signal
subplot(3,1,2);
plot(t2, y);
title('Upsampled Signal');
xlabel('time t(s)');
ylabel('Amplitude');
xlim([0, 0.01]);
ylim([-1, 1]);
grid on;

%fft of origin signal
nfft = 2^10;
yf = fft(y_o, nfft);
fstep = fs/nfft;
fvec = fstep * (0 : nfft/2-1);
fresp = 2*abs(yf(1:nfft/2)); 

subplot(3,1,3);

plot(fvec,fresp)                 % plot the figure 
title('Single-Sided Amplitude Spectrum of x(t) (origin)') % title of the figure
xlabel('Frequency (Hz)') % label for x
ylabel('|X(f)|')    % label for y
grid on;

%Reload handel

filename = 'handel_upsamp.wav';

audiowrite(filename, y, fs2);
clear y fs2;
[y, fs2] = audioread('handel_upsamp.wav');



sgtitle('Figure 7 UpSampling');
%sound(y, fs2);






