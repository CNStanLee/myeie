function Hd = clears
%CLEARS 返回离散时间滤波器对象。

% MATLAB Code
% Generated by MATLAB(R) 9.13 and Signal Processing Toolbox 9.1.
% Generated on: 03-Nov-2023 14:56:57

% Equiripple Lowpass filter designed using the FIRPM function.

% All frequency values are in Hz.
Fs = 8000;  % Sampling Frequency

Fpass = 3000;            % Passband Frequency
Fstop = 3500;            % Stopband Frequency
Dpass = 0.057501127785;  % Passband Ripple
Dstop = 0.0001;          % Stopband Attenuation
dens  = 20;              % Density Factor

% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fpass, Fstop]/(Fs/2), [1 0], [Dpass, Dstop]);

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, Fo, Ao, W, {dens});
Hd = dfilt.dffir(b);

% [EOF]