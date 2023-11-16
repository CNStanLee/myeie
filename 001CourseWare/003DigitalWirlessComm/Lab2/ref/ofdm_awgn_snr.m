clc;
clear;
close;
% Parameter Settings
bps = 4; % Number of bits per symbol
N_sc = 128; % Number of subcarriers
N_symb = 7; % Number of OFDM symbols
snrdB = (1:20); % Eb/No values (dB)
times = 1000;
overAllData = [N_sc * times, N_symb];
overAllDataReceived = [N_sc * times, N_symb];
bitErrorRate = [1,20];

for n = 1 : 20
    for i = 1 : times
        % Generate random data
        data = randsrc(N_sc, N_symb, 0 : 2 ^ bps - 1);
        overAllData((i - 1) * N_sc + 1 : i * N_sc, 1 : N_symb) = data;
    
        % Map to 16-QAM symbols
        qamSymbols = qammod(data, 2 ^ bps, "UnitAveragePower", true);
        
        % Perform IFFT
        ofdmSignal = (sqrt(N_sc))*ifft(qamSymbols, N_sc);
        
        % Generating A_cp matrix which adds the CP
        N_cp = round(0.1 * length(data)); % CP length is 10% of the information length
        I_Nsc = eye(N_sc);
        A_cp = [I_Nsc(end-N_cp+1:end,:);I_Nsc];
        
        S = A_cp * ofdmSignal; % CP addition to form OFDM signals on the columns of the matrix 'S'
        s = S(:); % Parallel to Serial Conversion
        s_noise = awgn(s,snrdB(n),'measured');
        S_received = reshape(s_noise, N_sc + N_cp, N_symb);
        
        % Remove the cyclic prefix
        S_received_noCP = S_received(N_cp + 1:end, :);
        
        % Perform FFT
        qamSymbolsReceived = (1/sqrt(N_sc))*fft(S_received_noCP, N_sc);
        
        % Demodulate the QAM symbols
        dataReceived = qamdemod(qamSymbolsReceived, 2 ^ bps, "UnitAveragePower", true);
        overAllDataReceived((i - 1) * N_sc + 1 : i * N_sc, 1 : N_symb) = dataReceived;
    end
    
    % Check bit error rate
    errors = biterr(overAllData, overAllDataReceived);
    bitErrorRate(n) = errors / (bps*N_sc*N_symb*times);
    disp(['Bit Error Rate: ', num2str(bitErrorRate(n))]);
end
%% 

semilogy(snrdB, bitErrorRate);
xlabel('snr (dB)')
ylabel('Bit Error Rate')