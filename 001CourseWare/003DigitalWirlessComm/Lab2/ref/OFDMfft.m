clc;
clear;
close;
% Parameter Settings
bps = 4; % Number of bits per symbol
N_sc = 32; % Number of subcarriers
N_symb = 6; % Number of OFDM symbols

% Generate random data
data = randsrc(N_sc, N_symb, 0 : 2 ^ bps - 1);

% Map to 16-QAM symbols
qamSymbols = qammod(data, 2 ^ bps, "UnitAveragePower", true);

% Perform IFFT
ofdmSignal = (1/sqrt(N_sc))*ifft(qamSymbols, N_sc);

% Generating A_cp matrix which adds the CP
N_cp = round(0.1 * length(data)); % CP length is 10% of the information length
I_Nsc = eye(N_sc);
A_cp = [I_Nsc(end-N_cp+1:end,:);I_Nsc];

S = A_cp * ofdmSignal; % CP addition to form OFDM signals on the columns of the matrix 'S'
s = S(:); % Parallel to Serial Conversion

S_received = reshape(s, N_sc + N_cp, N_symb);

% Remove the cyclic prefix
S_received_noCP = S_received(N_cp + 1:end, :);

% Perform FFT
qamSymbolsReceived = sqrt(N_sc)*fft(S_received_noCP, N_sc);

% Demodulate the QAM symbols
dataReceived = qamdemod(qamSymbolsReceived, 2 ^ bps, "UnitAveragePower", true);

% Check bit error rate
errors = sum(dataReceived ~= data);
bitErrorRate = errors / length(data);

disp(['Bit Error Rate: ', num2str(bitErrorRate)]);