% clear
close all;
clear;
% Information Bit Generation
N = 10; % number of symbols
M = 4 ; % order  of modulation
nbit = log2(M) * N;%niumber of bits required
data_bits = randi([0 1], nbit, 1);
% Bits to symbol mapping
data_bit_matrix = reshape(data_bits, N, log2(M));
dataSymbols = bin2dec(data_bit_matrix);
