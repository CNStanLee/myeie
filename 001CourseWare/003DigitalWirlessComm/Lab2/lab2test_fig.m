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
sub_carrier_num = 4;     % Number of subcarrier
symbol_num = 16;           % Number of symbols in each subcarrier
SNR_dB = 30;              % Eb/N0
%Bw = 1e6;
Bw = 37/50 * 1e6;

%BER = simulateOFDM(M, sub_carrier_num, symbol_num, SNR_dB, h);


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
    
    dataSymbols = dataSymbols'; % adapt to qammod function

    % Modulation
    
    x = qammod(dataSymbols, M, 'UnitAveragePower', true);

    scatterplot(x(:, 1));     % transmitted signal
    title("transimitted signal");

    %%
    % Plot调制后信号x的时域波形
    time_x = (0:length(x)-1) / sub_carrier_num;  % 时间轴，单位为符号时间
    figure;
    subplot(2, 1, 1);
    plot(time_x, real(x), 'b', time_x, imag(x), 'r');
    title('调制后信号x的时域波形');
    xlabel('时间 (符号时间)');
    ylabel('幅度');
    legend('实部', '虚部');
    grid on;

    %%
    subcarrierSpacing = Bw / sub_carrier_num;
    fftSize_x = 1024;  % FFT大小
    frequency_x = (-fftSize_x/2:fftSize_x/2-1) * subcarrierSpacing/1e6; % 频率轴，单位为兆赫兹
    x_fft = fftshift(fft(x, fftSize_x));
    figure;
    stem(frequency_x, 10*log10(abs(x_fft)));
    title('调制后信号x的频域波形');
    xlabel('频率 (MHz)');
    ylabel('幅度 (dB)');
    grid on;
    %%
    % IFFT
    
    %x_ifft = (1 / sqrt(sub_carrier_num)) * dftmtx(sub_carrier_num) * x   ;
    s =  (1 / sqrt(sub_carrier_num)) * ifft(x, sub_carrier_num);



    %%



    

    figure;

    fftSize = 1024;  % FFT大小
    frequency = (-fftSize/2:fftSize/2-1) * subcarrierSpacing/1e6; % 频率轴，单位为兆赫兹
    s_fft = fftshift(fft(s, fftSize));
    plot(frequency, 10*log10(abs(s_fft)));
    title('频域波形');
    xlabel('频率 (MHz)');
    ylabel('幅度 (dB)');
    grid on;


    %%

    scatterplot(x(:, 1));     % transmitted signal
    title("transimitted signal after IFFT");
    
    % Cyclic Prefix
    
    Ncp = round(0.1 * length(dataSymbols));
    I = eye(sub_carrier_num);
    I_last = I((end - Ncp + 1) : end ,:);
    Acp = [I_last ; I];
    
    


    %%
    stx = Acp * s;
    t = 1 : 1 : length(stx);
    plot(t, abs(stx));
    title("add prefix");
    % Parallel to Serial
    %%
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












