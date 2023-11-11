% --------------------------------- %
% Exercise 3 - Effect of Flat-Fading Channel on Signal Constellation
% --------------------------------- %
clear;
clc;
close all;

%snr_db = 15;
%M = 4;

%testChannel(snr_db, M, 1);

%% 3-1 Test Increase SNR check Constellation

clear;
clc;
close all;

M = 4;
snr_db_arr = [15, 20, 25];

for i = 1 : 1 : length(snr_db_arr)
    testChannel(snr_db_arr(i), M, 1);
end

%% 3-2 Test Increase M check BER

clear;
clc;
close all;

M_arr = [4, 8, 16, 32, 64];
snr_db = 15;
iter_time = 100;

BER_arr = zeros(iter_time, length(M_arr));
BER_mean_arr = zeros(1, length(M_arr));

for i = 1 : 1 : length(M_arr)
    for j = 1 : 1 : iter_time
        BER_arr(j, i) = testChannel(snr_db , M_arr(i), 0);
    end
    BER_mean_arr(i) = mean(BER_arr(:, i)); 
end

semilogy(M_arr, BER_mean_arr, '-*r', 'DisplayName', '4QAM BER - M');
xlabel("M");
ylabel("BER");
grid on;

%% 3-2 Test Increase SNR check BER

clear;
clc;
close all;

M = 4;
snr_db_arr = [15, 20, 25, 30];
iter_time = 100;

BER_arr = zeros(iter_time, length(snr_db_arr));
BER_mean_arr = zeros(1, length(snr_db_arr));

for i = 1 : 1 : length(snr_db_arr)
    for j = 1 : 1 : iter_time
        BER_arr(j, i) = testChannel(snr_db_arr(i) , M, 0);
    end
    BER_mean_arr(i) = mean(BER_arr(:, i)); 
end

semilogy(snr_db_arr, BER_mean_arr, '-*r', 'DisplayName', '4QAM BER - M');
xlabel("SNR(dB)");
ylabel("BER");
grid on;



% --------------------------------- %
% function define
% --------------------------------- %

function [BER] = testChannel(snr_db, M, plot_enable)
    % --------------------------------- %
    % parameter define
    % --------------------------------- %
    
    % channel
    
    % bandwidth
    Bw = 1e6;           % bandwidth to get a single-tap channel
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
    
    % original signal datapoint
    N = 100;            % Number of modulated symbols

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
