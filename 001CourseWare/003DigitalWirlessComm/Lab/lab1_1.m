% --------------------------------- %
% Exercise 1 - 1 Effect on AWGN on Signal Constellation
% --------------------------------- %
clear;
close all;
clc;
% --------------------------------- %
% parameter define
% --------------------------------- %
N = 100;            % Number of modulated symbols
M = 4;             % Order of modulation
nbit = log2(M) * N;   % transfer bits
% --------------------------------- %
% input information
% --------------------------------- %
data_bits = randi([0 1], nbit, 1); % original data
data_bit_Matrix = reshape(data_bits, N, log2(M));
dataSymbols = bi2de(data_bit_Matrix);
% --------------------------------- %
% modulator
% --------------------------------- %
x = qammod(dataSymbols, M, 'UnitAveragePower',true);
%figure;
scatterplot(x);  %scatter plot qam
title("figure of modulator");
% --------------------------------- %
% channel
% --------------------------------- %
EbNo_dB = 2;   % the BER will not be 0 anymore when EbNo is less than 5
snr_db = EbNo_dB + 10*log10(log2(M));
y = awgn(x, snr_db);
%figure;
scatterplot(y);
title("after the channel");
% --------------------------------- %
% demodulator
% --------------------------------- %
dataSymbols_demod = qamdemod(y, M, 'UnitAveragePower', true);
data_Matrix_demod = de2bi(dataSymbols_demod, log2(M));
data_demod = data_Matrix_demod(:);
% --------------------------------- %
% calculate BER
% --------------------------------- %
ber = mean(xor(data_bits, data_demod(:)));
fprintf("The BER of this model = %f", ber);

figure;
plot(real(y), imag(y), 'ob'); hold on
plot(real(x), imag(x), '*')
title("Compare");

