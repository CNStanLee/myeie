% --------------------------------- %
% Exercise 2 - 1 Effect of Flat-Fading Channel on Signal Constelllation
% --------------------------------- %
clear;
clc;
close all;
% --------------------------------- %
% parameter define
% --------------------------------- %
Bw = 6e6;           % bandwidth
Ts = 1/Bw;

% sampling period
fc = 5.9 * 16 ^ 9;  % carrier frequency

delay_norm = [0 0.2099 0.2219 0.2329 0.2176 0.6366 ...
    0.6448 0.6560 0.6584 0.7935 0.8213 0.9336 1.2285 ...
    1.3883 2.1704 2.7105 4.2589 4.6003 5.4902 5.6077 ...
    6.3065 6.6374 7.0427 8.6523]; % normalized delay as per standard

Power_db = [-4.4 -1.2 -3.5 -5.2 -2.5 0 -2.2 -3.9 -7.4 ...
    -7.1 -10.7 -11.1 -5.1 -6.8 -8.7 -13.2 -13.9 -13.9 ...
    -15.8 -17.1 -16 -15.7 -21.6 -22.8];% Power of each delay
% converting log scale to linear
pow_prof_ori = 10.^(0.1 * Power_db);

figure;
stem(delay_norm, pow_prof_ori);

Ds = 100e-9;                     % nominal delay spread as per standard
delay_actual = delay_norm * Ds;  % actual delay 
maxdelay = delay_actual(end);    % max delay as per standard
newdelays = (0 : Ts : maxdelay); % delays according to sampling rate

% --------------------------------- %
% interpolating and generating channel with given para
% --------------------------------- %
% interpolating and taking the value for required delays
newpowers = interp1(delay_actual, Power_db, newdelays);
% converting log scale to linear
pow_prof = 10.^(0.1 * newpowers);
len = length(pow_prof);

figure;
stem(newdelays, pow_prof);

% channel coeff
h = sqrt(pow_prof.'/2) .* (randn(len, 1) + 1i * randn(len, 1));
% --------------------------------- %
% utilize the generated channel
% --------------------------------- %
N = 100;            % Number of modulated symbols
M = 64;             % Order of modulation
nbit = log2(M) * N;   % transfer bits
data_bits = randi([0 1], nbit, 1); % information bits generation
data_bit_Matrix = reshape(data_bits, N, log2(M)); % arranging bits to form bit matrix
dataSymbols = bi2de(data_bit_Matrix); % converting bits todecimal numbers
x = qammod(dataSymbols, M, 'UnitAveragePower', true);
EbNo_dB = 7;
snr_db = EbNo_dB + 10 * log10(log2(M));
y_1 = conv(x, h, 'same'); % utilize the gerated channel
y = awgn(y_1, snr_db); % final recerive signal
y_awgn = awgn(x, snr_db); % only use AWGN
% --------------------------------- %
% compare the effects
% --------------------------------- %
scatterplot(x);     % transmitted signal
title("transimitted signal");
scatterplot(y);     % received signal
title("received signal");
mm = y / h;
noZeroCol = any(mm);
scatterplot(mm(:,noZeroCol)); % after channel
title("received signal after rotation");
scatterplot(y_awgn); % only awgn
title("AWGN");

