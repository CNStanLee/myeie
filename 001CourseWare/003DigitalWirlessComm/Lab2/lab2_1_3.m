% --------------------------------- %
% Lab2 Exercise 1 Q3 Compare CP length in AWGN channel
% --------------------------------- %
clear;
clc;
close all;
% --------------------------------- %
% parameter define
% --------------------------------- %
testh = 1; % ideal channel
M = 4;
snr_db_arr = 0 : 2 : 20;
iter_time = 100;
sub_carrier_num = 64;     % Number of subcarrier
symbol_num = 6;           % Number of symbols in each subcarrier

cp_arr = 0 : 0.1 : 0.5;


figure;
for k = 1 : 1 : length(cp_arr)
    % --------------------------------- %
    % 4-QAM OFDM channel
    % --------------------------------- %
    BER_arr = zeros(iter_time, length(snr_db_arr));
    BER_mean_arr = zeros(1, length(snr_db_arr));
    
    for i = 1 : 1 : length(snr_db_arr)
        for j = 1 : 1 : iter_time
            BER_arr(j, i) = testOFDM(M, sub_carrier_num, symbol_num, snr_db_arr(i), testh, cp_arr(k));
        end
        BER_mean_arr(i) = mean(BER_arr(:, i)); 
    end
    
    snr_db_arr_OFDM = snr_db_arr;
    BER_mean_arr_OFDM = BER_mean_arr;
    % --------------------------------- %
    % figure the BER vs SNR (4-QAM and OFDM)
    % --------------------------------- %

    semilogy(snr_db_arr, BER_mean_arr_OFDM);
    hold on;
    xlabel("SNR(dB)");
    ylabel("BER");
    grid on;    
end

legend('0', '0.10', '0.20', '0.30', '0.40', '0.50');












