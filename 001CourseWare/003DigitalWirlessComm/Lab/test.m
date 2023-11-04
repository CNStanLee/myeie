clear
clc
N = 10; % Number of modulated symbols
M = 4; % Order of modulation
nbit =log2(M)*N;
data_bits = randi([0 1], nbit, 1);
data_bit_Matrix = reshape(data_bits, N, log2(M));
dataSymbols = bi2de(data_bit_Matrix);
x = qammod(dataSymbols, M, 'UnitAveragePower',true);
scatterplot(x)%scatter plot
EbNo_dB = 1;
snr_db = EbNo_dB + 10*log10(log2(M));
y = awgn(x, snr_db);
scatterplot(y)
dataSymbols_demod = qamdemod(y, M, 'UnitAveragePower', true);
data_Matrix_demod = de2bi(dataSymbols_demod, log2(M));
data_demod = data_Matrix_demod(:);
ber = mean(xor(data_bits, data_demod(:)));

figure
plot(real(y), imag(y), 'ob'); hold on
plot(real(x), imag(x), '*')

