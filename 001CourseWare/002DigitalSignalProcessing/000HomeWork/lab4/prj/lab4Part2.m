% --------------------------------- %
% Lab4 Part 2
% --------------------------------- %
clear;
close all;
clc;
% --------------------------------- %
% create signal
% --------------------------------- %

d_vect = 0.5 .* ones(1, 4);
note_vect = [25, 107, 25, 107];
fs = 8000;
start_vect = 0 : 1 : 4;
music1 = createMusic(d_vect, note_vect, fs, start_vect);
[Y, f] = my_FFT(music1, fs);
figure(3);
plot(f, abs(Y));
xlabel("frequency f");
ylabel("Y");
title("DFT of music");

% --------------------------------- %
% create ideal filter
% --------------------------------- %

%HLP = zeros(f);

%HHP = zeros(f);








