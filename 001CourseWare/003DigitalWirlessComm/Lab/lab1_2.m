clear
clc
N = 8;
M = 4;
nbit = log2(M)*N;
MC = 100;
EbNo_dB = 0 : 2 : 20;
for ss = 1 : length(EbNo_dB)
    ber_count = 0;
    for mc = 1 : MC

        %% transitter
        data_bits = randi([0 1], nbit, 1);
        data_bit_Matrix = reshape(data_bits, N, log2(M));
        dataSymbols = bi2de(data_bit_Matrix);
        x = qammod(dataSymbols, M, 'UnitAveragePower',true);
        %% channel
        snr_db = EbNo_dB(ss) + 10*log10(log2(M));
        y = awgn(x, snr_db);
        %% receiver
        dataSymbols_demod = qamdemod(y, M, 'UnitAveragePower', true);
        data_Matrix_demod = de2bi(dataSymbols_demod, log2(M));
        data_demod = data_Matrix_demod(:);
        ber_i = mean(xor(data_bits, data_demod(:)));
        ber_count = ber_count + ber_i;
    end
    BER(ss) = ber_count/MC;
end
