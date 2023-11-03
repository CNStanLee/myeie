function Hd = clears_3
%CLEARS_3 返回离散时间滤波器对象。

% MATLAB Code
% Generated by MATLAB(R) 9.13 and Signal Processing Toolbox 9.1.
% Generated on: 03-Nov-2023 16:04:09

% Equiripple Bandpass filter designed using the FIRPM function.

% All frequency values are in Hz.
Fs = 8000;  % Sampling Frequency

Fstop1 = 200;             % First Stopband Frequency
Fpass1 = 500;             % First Passband Frequency
Fpass2 = 2500;            % Second Passband Frequency
Fstop2 = 2800;            % Second Stopband Frequency
Dstop1 = 0.001;           % First Stopband Attenuation
Dpass  = 0.057501127785;  % Passband Ripple
Dstop2 = 0.001;           % Second Stopband Attenuation
dens   = 20;              % Density Factor

% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fstop1 Fpass1 Fpass2 Fstop2]/(Fs/2), [0 1 ...
                          0], [Dstop1 Dpass Dstop2]);

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, Fo, Ao, W, {dens});
Hd = dfilt.dffir(b);

% [EOF]
