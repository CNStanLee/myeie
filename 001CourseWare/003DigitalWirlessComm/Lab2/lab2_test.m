% --------------------------------- %
% Lab2 Exercise 1
% --------------------------------- %
clear;
close all;
clc;
% --------------------------------- %
% Lab2 Exercise 1
% --------------------------------- %

% Parameter Define

M = 4;                   % Model Order 4QAM M = 4
sub_carrier_num = 64;     % Number of subcarrier
symbol_num = 6;           % Number of symbols in each subcarrier
SNR_dB = 30;              % Eb/N0
%Bw = 1e6;
Bw = 39/50 * 1e6;
h = generateChannel(Bw);
%BER = simulateOFDM(M, sub_carrier_num, symbol_num, SNR_dB, h);
BER = testOFDM(M, sub_carrier_num, symbol_num, SNR_dB, 1);

%% Exercise 1.1

subcarrierSpacing = Bw / sub_carrier_num;
fprintf("subcarrierSpacing = %.2f kHz\n", subcarrierSpacing / 1000);

dur_of_OFDM_symbol = sub_carrier_num / Bw;
fprintf("dur_of_OFDM_symbol = %.2f us\n", dur_of_OFDM_symbol * 1e6);

%% Exercise 1.2 Compare with 4-QAM BER in AWGN channel
clear;
clc;
close all;

% 4QAM

%Bw = 39/50 * 1e6;
Bw = 1e6;
h = generateChannel(Bw);

testh = 1;
%testh = h;

M = 4;
snr_db_arr = [-10,-5, 0, 5, 10, 15, 20];
iter_time = 1000;

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

% OFDM


M = 4;                   % Model Order 4QAM M = 4
sub_carrier_num = 64;     % Number of subcarrier
symbol_num = 6;           % Number of symbols in each subcarrier

iter_time = 1000;

Bw = 39/50 * 1e6;
h = generateChannel(Bw);

BER_arr = zeros(iter_time, length(snr_db_arr));
BER_mean_arr = zeros(1, length(snr_db_arr));

for i = 1 : 1 : length(snr_db_arr)
    for j = 1 : 1 : iter_time
        BER_arr(j, i) = testOFDM(M, sub_carrier_num, symbol_num, snr_db_arr(i), testh);
    end
    BER_mean_arr(i) = mean(BER_arr(:, i)); 
end

snr_db_arr_OFDM = snr_db_arr;
BER_mean_arr_OFDM = BER_mean_arr;

figure;

semilogy(snr_db_arr, BER_mean_arr_OFDM, '-*g', 'DisplayName', '4QAM BER - M');
xlabel("SNR(dB)");
ylabel("BER");
grid on;
hold on;
semilogy(snr_db_arr, BER_mean_arr_4QAM, '-*r', 'DisplayName', '4QAM BER - M');
legend('OFDM', '4QAM');



%%

function h = generateChannel(Bw)

    % Generate Wireless Channel
    
    % channel
    
    % bandwidth
    %Bw = 1e6;           % bandwidth to get a single-tap channel
    Ts = 1/Bw;
    
    % TDL-C parameter
    delay_norm = [0 0.2099 0.2219 0.2329 0.2176 0.6366 ...
        0.6448 0.6560 0.6584 0.7935 0.8213 0.9336 1.2285 ...
        1.3883 2.1704 2.7105 4.2589 4.6003 5.4902 5.6077 ...
        6.3065 6.6374 7.0427 8.6523]; % normalized delay as per standard
    
    Power_db = [-4.4 -1.2 -3.5 -5.2 -2.5 0 -2.2 -3.9 -7.4 ...
        -7.1 -10.7 -11.1 -5.1 -6.8 -8.7 -13.2 -13.9 -13.9 ...
        -15.8 -17.1 -16 -15.7 -21.6 -22.8];% Power of each delay
    
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
    
    % channel coeff
    h = sqrt(pow_prof.'/2) .* (randn(len, 1) + 1i * randn(len, 1));

end


function BER = testOFDM(M, sub_carrier_num, symbol_num, SNR_dB, h)
    % Calculate SNR_dB
    % SNR_dB = EbN0_dB + 10*log10(log2(M));
    % SNR_dB = 20;
    

    
    % --------------------------------- %
    % transimitter
    % --------------------------------- %
    
    % Information Bit Gneration
    
    dataSymbols = zeros(sub_carrier_num, symbol_num);
    
    for i = 1 : 1 : sub_carrier_num
        nbit = log2(M) * symbol_num;   % transfer bits each sub carrier
        data_bits = randi([0 1], nbit, 1); % information bits generation
        data_bit_Matrix = reshape(data_bits, symbol_num, log2(M)); % arranging bits to form bit matrix
        dataSymbols(i, :) = bi2de(data_bit_Matrix); % converting bits todecimal numbers
    end
    
    % Modulation
    
    x = qammod(dataSymbols, M, 'UnitAveragePower', true);
    
    % IFFT
    
    %x_ifft = (1 / sqrt(sub_carrier_num)) * dftmtx(sub_carrier_num) * x   ;
    s =  (1 / sqrt(sub_carrier_num)) * ifft(x, sub_carrier_num);
    
    % Cyclic Prefix
    
    Ncp = round(0.1 * length(dataSymbols));

    %Bw = 37/50 * 1e6;
    %dur_of_Cp = Ncp / Bw;
    %fprintf("dur_of_Cp = %.2f us\n", dur_of_Cp * 1e6);

    I = eye(sub_carrier_num);
    I_last = I((end - Ncp + 1) : end ,:);
    Acp = [I_last ; I];
    
    stx = Acp * s;
    
    % Parallel to Serial
    
    stx_serial = stx(:);
    
    
    % --------------------------------- %
    % Channel
    % --------------------------------- %
    
    % Wireless channel
    
    sch_wl = conv(stx_serial, h, 'same'); % utilize the gerated channel
    
    % AWGN channel
    
    sch_awgn = awgn(sch_wl, SNR_dB);
    
    % --------------------------------- %
    % Receiver
    % --------------------------------- %
    
    % Serial 2 Parallel
    
    srx = reshape(sch_awgn, sub_carrier_num + Ncp, symbol_num);
    
    % Remove CP
    
    srx_nocp = srx(Ncp + 1 : end, :);
    
    % FFT
    
    s_recv = sqrt(sub_carrier_num) * fft(srx_nocp, sub_carrier_num);
    
    % Equalization
    
    s_recv_eq = s_recv / h;
    
    % Demodulation
    
    dataSymbols_demod = qamdemod(s_recv_eq, M, 'UnitAveragePower', true);
    
    % Information Bit Detection
    
    err_num = sum(xor(dataSymbols_demod, dataSymbols));
    BER = mean(err_num / length(dataSymbols));
   
end


function [BER] = testChannel(snr_db, M, plot_enable, h)
    % --------------------------------- %
    % parameter define
    % --------------------------------- %
    
    N = 64 * 6;
    % --------------------------------- %
    % utilize the generated channel
    % --------------------------------- %
    
    nbit = log2(M) * N;   % transfer bits
    data_bits = randi([0 1], nbit, 1); % information bits generation
    data_bit_Matrix = reshape(data_bits, N, log2(M)); % arranging bits to form bit matrix
    dataSymbols = bi2de(data_bit_Matrix); % converting bits todecimal numbers
    x = qammod(dataSymbols, M, 'UnitAveragePower', true);
    
    % snr_db = EbNo_dB + 10 * log10(log2(M));
    y_1 = conv(x, h, 'same'); % utilize the gerated channel
    
    y_awgn = awgn(x, snr_db); % only use AWGN

    y = awgn(y_1, snr_db); % final recerive signal
    y_eq = y / h;

    % --------------------------------- %
    % demodulator
    % --------------------------------- %
    dataSymbols_demod = qamdemod(y_eq, M, 'UnitAveragePower', true);
    data_Matrix_demod = de2bi(dataSymbols_demod, log2(M));
    data_demod = data_Matrix_demod(:);

    BER = mean(xor(data_bits, data_demod(:)));
    %fprintf("The BER of this model = %f\r", BER);

    % --------------------------------- %
    % PLOT
    % --------------------------------- %
    if(plot_enable)
        %scatterplot(x);     % transmitted signal
        %title("transimitted signal");
        %scatterplot(y);     % received signal
        %title("received signal");

        noZeroCol = any(y_eq);
        scatterplot(y_eq(:,noZeroCol)); % after channel
        figtitle = sprintf("M = %d, SNR = %.2f, BER = %.6f", M, snr_db, BER);
        title(figtitle);
        %scatterplot(y_awgn); % only awgn
        %title("AWGN");

    end
end








