% --------------------------------- %
% Lab2 Exercise 1 Q2 Compare with 4-QAM BER in AWGN channel
% --------------------------------- %
clear;
clc;
close all;
% --------------------------------- %
% parameter define
% --------------------------------- %

M = 4;
snr_db_arr = 0 : 2 : 30;
iter_time = 100;
sub_carrier_num = 64;     % Number of subcarrier
symbol_num = 6;           % Number of symbols in each subcarrier
Bw = 39/50 * 1e6;
h = generateChannel(Bw);
testh = h; % TDLC channel
% --------------------------------- %
% 4-QAM AWGN channel
% --------------------------------- %
BER_arr = zeros(iter_time, length(snr_db_arr));
BER_mean_arr = zeros(1, length(snr_db_arr));

for i = 1 : 1 : length(snr_db_arr)
    for j = 1 : 1 : iter_time
        BER_arr(j, i) = testChannel(snr_db_arr(i) , M, 0, testh);
    end
    BER_mean_arr(i) = mean(BER_arr(:, i)); 
end
snr_db_arr_4QAM = snr_db_arr;
BER_mean_arr_4QAM = BER_mean_arr;
% --------------------------------- %
% 4-QAM OFDM channel
% --------------------------------- %
BER_arr = zeros(iter_time, length(snr_db_arr));
BER_mean_arr = zeros(1, length(snr_db_arr));

for i = 1 : 1 : length(snr_db_arr)
    for j = 1 : 1 : iter_time
        BER_arr(j, i) = testOFDM(M, sub_carrier_num, symbol_num, snr_db_arr(i), testh, 0.1);
    end
    BER_mean_arr(i) = mean(BER_arr(:, i)); 
end

snr_db_arr_OFDM = snr_db_arr;
BER_mean_arr_OFDM = BER_mean_arr;
% --------------------------------- %
% figure the BER vs SNR (4-QAM and OFDM)
% --------------------------------- %
figure;
semilogy(snr_db_arr, BER_mean_arr_OFDM, '-*g');
hold on;
semilogy(snr_db_arr, BER_mean_arr_4QAM, '-*r');
xlabel("SNR(dB)");
ylabel("BER");
grid on;
legend('OFDM', '4-QAM');















