function Hd = LPF2
%LPF2 Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 23.2 and Signal Processing Toolbox 23.2.
% Generated on: 11-Oct-2023 17:42:48

% Equiripple Lowpass filter designed using the FIRPM function.

% All frequency values are in kHz.
Fs = 20;  % Sampling Frequency

Fpass = 3.375;            % Passband Frequency
Fstop = 5.625;            % Stopband Frequency
Dpass = 0.0011512920378;  % Passband Ripple
Dstop = 0.0177827941;     % Stopband Attenuation
dens  = 20;               % Density Factor

% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fpass, Fstop]/(Fs/2), [1 0], [Dpass, Dstop]);

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, Fo, Ao, W, {dens});
Hd = dfilt.dffir(b);

% [EOF]
