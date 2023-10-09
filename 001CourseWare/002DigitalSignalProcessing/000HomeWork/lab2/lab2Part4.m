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


figure(Name='Figure 7 DownSampling');
%original signal

y_o = y;
fs = 8192;
t = 0 : 1/fs : (length(y) - 1)/fs;

%plot original signal
subplot(2,1,1);
plot(t, y);
title('Original Signal');
xlabel('time t(s)');
ylabel('Amplitude');
xlim([0, 0.05]);
ylim([-1, 1]);
grid on;

%resample the signal

L = 2; % sampling factor
fs2 = L * fs; 
y = zeros(1, ceil(L * length(t)));
y(1 : L : length(y)) = y_o;
t2 = 0 : (1/fs2) : (length(y)/fs2 -(1/fs2));

%plot downsampling signal
subplot(2,1,2);
plot(t2, y);
title('Downsampled Signal');
xlabel('time t(s)');
ylabel('Amplitude');
xlim([0, 0.05]);
ylim([-1, 1]);
grid on;

%Reload handel

filename = 'handel.wav';
audiowrite(filename, y, fs2);
clear y fs2;
[y, fs2] = audioread('handel.wav');

sound(y, fs2);



