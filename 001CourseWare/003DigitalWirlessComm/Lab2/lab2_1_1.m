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
