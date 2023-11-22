function BER = testOFDM(M, sub_carrier_num, symbol_num, SNR_dB, h, Cpcoe)
    
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
    s =  (sqrt(sub_carrier_num)) * ifft(x, sub_carrier_num);
    
    % Cyclic Prefix

    
    Ncp = round(Cpcoe * length(dataSymbols));

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