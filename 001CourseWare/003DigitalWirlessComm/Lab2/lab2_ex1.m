clc;
clear;
close all;


clear;
clc;
close all;

M = 16;
snr_db_arr = [15, 20, 25, 30];
iter_time = 1000;


testChannelWithOFDM(snr_db_arr(1) , M, 1);
  




% --------------------------------- %
% function define
% --------------------------------- %

function [BER] = testChannelWithOFDM(snr_db, M, plot_enable)
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

    % OFDM parameters

    sub_carrier_num = 64; % Subcarrier Number


    % --------------------------------- %
    % Generate Channel
    % --------------------------------- %

    % interpolating and taking the value for required delays
    newpowers = interp1(delay_actual, Power_db, newdelays);
    % converting log scale to linear
    pow_prof = 10.^(0.1 * newpowers);
    len = length(pow_prof);
    
    % channel coeff
    h = sqrt(pow_prof.'/2) .* (randn(len, 1) + 1i * randn(len, 1));
    
    % --------------------------------- %
    % main simulation
    % --------------------------------- %
    
    % --------------------------------- %
    % transimitter
    % --------------------------------- %

    % Information Bit Generation

    nbit = log2(M) * N;   % transfer bits
    data_bits = randi([0 1], nbit, 1); % information bits generation
    data_bit_Matrix = reshape(data_bits, N, log2(M)); % arranging bits to form bit matrix
    dataSymbols = bi2de(data_bit_Matrix); % converting bits todecimal numbers
    
    %  Modulation
    x = qammod(dataSymbols, M, 'UnitAveragePower', true);
    
    % IFFT

    x_ofdm = (1 / sqrt(sub_carrier_num)) * ifft(x, sub_carrier_num);

    % Adding Prefix

    cp_coe = 0.1;
    
    cp_size = round(cp_coe * length(dataSymbols));
    identity_matrix = eye(sub_carrier_num);
    Acp = [identity_matrix(end -  cp_size: end, :) ; identity_matrix];

    Stx = Acp * x_ofdm;
    stx = Stx(:);

    % --------------------------------- %
    % Channel
    % --------------------------------- %

    % snr_db = EbNo_dB + 10 * log10(log2(M));
    y_1 = conv(stx, h, 'same'); % utilize the gerated channel
    
    % only AWGN
    %y_awgn = awgn(stx, snr_db); % only use AWGN
    
    % AWGN + Wireless Channel
    y = awgn(y_1, snr_db); % final recerive signal
    
    
    % --------------------------------- %
    % receiver
    % --------------------------------- %

    Srx = reshape(y, sub_carrier_num + cp_size, N);

    % Removing CP

    Srx_nocp = Srx(cp_size + 1 : end, :);

    % FFT

    Srx_fft = (1 / sqrt(sub_carrier_num)) * fft(Srx_nocp, sub_carrier_num);
      
    % Equalization
    y_eq = Srx_fft / h;

    % demodulate
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