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

M = 16;                  % Model Order 4QAM M = 4
sub_carrier_num = 32;   % Number of subcarrier
symbol_num = 6;         % Number of symbols in each subcarrier
SNR_dB = 100;              % Eb/N0
Bw = 1e6;
h = generateChannel(Bw);
BER = simulateOFDM(M, sub_carrier_num, symbol_num, SNR_dB, 1);

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


function BER = simulateOFDM(M, sub_carrier_num, symbol_num, SNR_dB, h)
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
    BER = err_num / length(dataSymbols);
end











