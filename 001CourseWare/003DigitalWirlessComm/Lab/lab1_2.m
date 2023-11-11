% --------------------------------- %
% Exercise 1 - 2 Frequency-Selective Fading Channel Simulation
% --------------------------------- %
clear;
clc;
close all;
% --------------------------------- %
% parameter define
% --------------------------------- %
N = 8;            % Number of modulated symbols
M = 4;            % Order of modulation
nbit = log2(M) * N; % transfer bits
MC = 100;         % Number of Montecarlo itration
EbNo_dB = 0 : 2 : 20;   % Energy per bit to noise power spectral density
BER = zeros(1, length(EbNo_dB));
% --------------------------------- %
% find BER with different noise level
% --------------------------------- %
for ss = 1 : length(EbNo_dB)
    ber_count = 0;
    for mc = 1 : MC
        % transitter
        data_bits = randi([0 1], nbit, 1);
        data_bit_Matrix = reshape(data_bits, N, log2(M));
        dataSymbols = bi2de(data_bit_Matrix);
        x = qammod(dataSymbols, M, 'UnitAveragePower',true);
        % channel
        snr_db = EbNo_dB(ss) + 10*log10(log2(M));
        y = awgn(x, snr_db);
        % receiver
        dataSymbols_demod = qamdemod(y, M, 'UnitAveragePower', true);
        data_Matrix_demod = de2bi(dataSymbols_demod, log2(M));
        data_demod = data_Matrix_demod(:);
        % calculate the ber
        ber_i = mean(xor(data_bits, data_demod(:)));
        ber_count = ber_count + ber_i;
    end
    BER(ss) = ber_count / MC;
end
% --------------------------------- %
% plot the relationship between BER and the noise
% --------------------------------- %
semilogy(EbNo_dB, BER, '-*r', 'DisplayName', '4QAM awgn');
xlabel("EbNo(dB)");
ylabel("BER");
grid on;
%% find BER VS M
clear;
clc;
close all;
% --------------------------------- %
% parameter define
% --------------------------------- %
N = 8;            % Number of modulated symbols
M = [4, 8, 16, 32, 64];           % Order of modulation

MC = 100;         % Number of Montecarlo itration
%EbNo_dB = 0 : 2 : 20;   % noise
EbNo_dB = 1;
BER = zeros(1, length(EbNo_dB));
% --------------------------------- %
% find BER with different noise level
% --------------------------------- %
for ss = 1 : length(M)
    ber_count = 0;
    nbit = log2(M(ss)) * N; % transfer bits
    for mc = 1 : MC
        % transitter
        data_bits = randi([0 1], nbit, 1);
        data_bit_Matrix = reshape(data_bits, N, log2(M(ss)));
        dataSymbols = bi2de(data_bit_Matrix);
        x = qammod(dataSymbols, M(ss), 'UnitAveragePower',true);
        % channel
        snr_db = EbNo_dB + 10*log10(log2(M(ss)));
        y = awgn(x, snr_db);
        % receiver
        dataSymbols_demod = qamdemod(y, M(ss), 'UnitAveragePower', true);
        data_Matrix_demod = de2bi(dataSymbols_demod, log2(M(ss)));
        data_demod = data_Matrix_demod(:);
        % calculate the ber
        ber_i = mean(xor(data_bits, data_demod(:)));
        ber_count = ber_count + ber_i;
    end
    BER(ss) = ber_count / MC;
end
% --------------------------------- %
% plot the relationship between BER and the noise
% --------------------------------- %
semilogy(M, BER, '-*r', 'DisplayName', '4QAM awgn');
xlabel("M");
ylabel("BER");
grid on;
%% find erroneuous bit per 1000 bits
% --------------------------------- %
% parameter define
% --------------------------------- %
N = 167;            % Number of modulated symbols
M = 64;            % Order of modulation
nbit = log2(M) * N; % transfer bits
MC = 100;         % Number of Montecarlo itration
EbNo_dB = 0 : 2 : 20;   % noise
BER = zeros(1, length(EbNo_dB));
ERR_NUM = zeros(1, length(EbNo_dB));
% --------------------------------- %
% find BER with different noise level
% --------------------------------- %
for ss = 1 : length(EbNo_dB)
    ber_count = 0;
    err_num = 0;
    for mc = 1 : MC
        % transitter
        data_bits = randi([0 1], nbit, 1);
        data_bit_Matrix = reshape(data_bits, N, log2(M));
        dataSymbols = bi2de(data_bit_Matrix);
        x = qammod(dataSymbols, M, 'UnitAveragePower',true);
        % channel
        snr_db = EbNo_dB(ss) + 10*log10(log2(M));
        y = awgn(x, snr_db);
        % receiver
        dataSymbols_demod = qamdemod(y, M, 'UnitAveragePower', true);
        data_Matrix_demod = de2bi(dataSymbols_demod, log2(M));
        data_demod = data_Matrix_demod(:);
        % calculate the ber
        ber_i = mean(xor(data_bits, data_demod(:)));
        ber_count = ber_count + ber_i;
        err_num = max(err_num, sum(xor(data_bits, data_demod(:))));
    end
    BER(ss) = ber_count / MC;
    ERR_NUM(ss) = err_num;
end
% --------------------------------- %
% plot the relationship between BER and the noise
% --------------------------------- %
semilogy(EbNo_dB, ERR_NUM, '-*r', 'DisplayName', '4QAM awgn');
xlabel("EbNo(dB)");
ylabel("max erroneous per 1000 bits");
grid on;