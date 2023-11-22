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
