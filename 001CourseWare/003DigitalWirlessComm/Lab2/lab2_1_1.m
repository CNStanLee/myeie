% --------------------------------- %
% Lab2 Exercise 1 Q1
% --------------------------------- %
clear;
close all;
clc;

% Parameter Define

M = 4;                   % Model Order 4QAM M = 4
sub_carrier_num = 64;     % Number of subcarrier
symbol_num = 6;           % Number of symbols in each subcarrier
SNR_dB = 30;              % Eb/N0
Bw = 39/50 * 1e6;

subcarrierSpacing = Bw / sub_carrier_num;
fprintf("subcarrierSpacing = %.2f kHz\n", subcarrierSpacing / 1000);

dur_of_OFDM_symbol = sub_carrier_num / Bw;
fprintf("dur_of_OFDM_symbol = %.2f us\n", dur_of_OFDM_symbol * 1e6);

% Stem

Bw =  5e6;
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
