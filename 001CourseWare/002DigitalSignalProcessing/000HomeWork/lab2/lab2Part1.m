% clear
close all;
clear;
clc;
% 1.1 Model
%fs = 8000; % sample frequency(Hz)
f0 = 800;  % fundamental frequency(Hz)
d  = 2;    % duration(s)
% t = 0 : (1/fs) : (d-(1/fs));
% xt = sin(2 * pi * f0 * t);

% figure;
% plot(t, xt);
% 1.2 Nyquist criterion
% 1.2.1
fs_min = 2 * f0;
fprintf('1.2.1 minimux val of fs = %d\n', fs_min);
%% 1.2.2
fs = 1000;
t = 0 : (1/fs) : (d -(1/fs));
xt = sin(2 * pi * f0 * t);

sound(xt, fs);
%% 1.2.3
fs = 8000;

figure("Name",'Figure 1 Waveform of sinewaves');

subplot(2, 1, 1);
f0 = 800;
t = 0 : (1/fs) : (d-(1/fs));
xt = sin(2 * pi * f0 * t);
xt1 = xt;
plot(t, xt);
title('sinewave(f0 = 800)');
xlabel('time t(s)');
ylabel('Amplitude');
xlim([0, 0.01]);
ylim([-1, 1]);
grid on;

subplot(2, 1, 2);
f0 = 7200;
t = 0 : (1/fs) : (d-(1/fs));
xt = sin(2 * pi * f0 * t);
xt2 = xt;
plot(t, xt);
title('sinewave(f0 = 7200)');
xlabel('time t(s)');
ylabel('Amplitude');
xlim([0, 0.01]);
ylim([-1, 1]);
grid on;

sgtitle('Figure 1 Waveform of sinewaves');
%sound(xt1, fs);
sound(xt2, fs);% listen to these two sounds and find out the difference

%% 1.2.4
figure("Name",'Figure 2 handel in different Fs');
xlim1 = 1;
xlim2 = 1.05;
% origin
load handel.mat;
filename = 'handel.wav';
audiowrite(filename, y, Fs);
clear y Fs;
[y, Fs] = audioread('handel.wav');
fprintf('1.2.4 Fs of orginal signal = %d\n', Fs);
%sound(y);

t = 0 : 1/Fs : (length(y) - 1)/Fs;
subplot(4, 1, 1);
plot(t, y);
title('origin');
xlabel('time t(s)');
ylabel('Amplitude');
xlim([xlim1, xlim2]);
ylim([-1.5, 1.5]);
grid on;

% 7000
fsn = 7000;
load handel.mat;
y = resample(y ,fsn , 8192);
filename = 'handel.wav';
audiowrite(filename, y, fsn);
clear y Fs;
[y, Fs] = audioread('handel.wav');

t = 0 : 1/Fs : (length(y) - 1)/Fs;
subplot(4, 1, 2);
plot(t, y);
title('sinewave(f0 = 7000)');
xlabel('time t(s)');
ylabel('Amplitude');
xlim([xlim1, xlim2]);
ylim([-1.5, 1.5]);
grid on;

% 6000
fsn = 6000;
load handel.mat;
y = resample(y ,fsn , 8192);
filename = 'handel.wav';
audiowrite(filename, y, fsn);
clear y Fs;
[y, Fs] = audioread('handel.wav');


t = 0 : 1/Fs : (length(y) - 1)/Fs;
subplot(4, 1, 3);
plot(t, y);
title('sinewave(f0 = 6000)');
xlabel('time t(s)');
ylabel('Amplitude');
xlim([xlim1, xlim2]);
ylim([-1.5, 1.5]);
grid on;

% 3000
fsn = 3000;
load handel.mat;
y = resample(y ,fsn , 8192);
filename = 'handel.wav';
audiowrite(filename, y, fsn);
clear y Fs;
[y, Fs] = audioread('handel.wav');
%sound(y, Fs);


t = 0 : 1/Fs : (length(y) - 1)/Fs;
subplot(4, 1, 4);
plot(t, y);
title('sinewave(f0 = 3000)');
xlabel('time t(s)');
ylabel('Amplitude');
xlim([xlim1, xlim2]);
ylim([-1.5, 1.5]);
grid on;

sgtitle('Figure 2 handel in different Fs');

%%



