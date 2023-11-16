clc;
clear;
close;

bps = 4; % Number of bits per symbol
N_sc = 32; % Number of subcarriers
N_symb = 6; % Number of OFDM symbols

% Generate random data
information = randsrc(N_sc, N_symb, 0 : 2 ^ bps - 1);

% Map to 16-QAM symbols
qamSymbols = qammod(information, 2 ^ bps, "UnitAveragePower", true);


% % Display a scatter plot of the QAM symbols
% scatterplot(qamSymbols(:))
% title('QAM Symbols');


F_Nsc = (1/sqrt(N_sc))*exp(1i*2*(pi/N_sc)*(0:N_sc-1).'*(0:N_sc-1)); % Generating the normalized DFT matrix

X = F_Nsc'*qamSymbols; % OFDM modulation

% Generating A_cp matrix which adds the CP
N_cp = round(0.1 * length(information)); % CP length is 10% of the information length
I_Nsc = eye(N_sc);
A_cp = [I_Nsc(end-N_cp+1:end,:);I_Nsc];

S = A_cp*X; % CP addition to form OFDM signals on the columns of the matrix 'S'
s = S(:); % Parallel to Serial Conversion

S_received = reshape(s, N_sc + N_cp, N_symb);

% Remove the cyclic prefix
S_received_noCP = S_received(N_cp + 1:end, :);

% OFDM demodulation
X_received = F_Nsc * S_received_noCP;

% Demodulate the QAM symbols
dataReceived = qamdemod(X_received, 2 ^ bps, "UnitAveragePower", true);

% % Plot the real part of the carrier signals
% for i = 1 : 2 ^ bps
%     plot((1:16), real(carrySignal(i,:)))
%     hold on
% end
% 
% % Initialize the OFDM signal
% ofdmSignal = zeros(1, 2 ^ bps);
% 
% % Generate the OFDM signal
% for i = 1 : 2 ^ bps
%     subSignal = qamSymbols(i)' * carrySignal(i,:);
%     % Q2
%     % Using accumulation means having to wait for data. Does this impact 
%     % low latency?
%     ofdmSignal = ofdmSignal + subSignal;
% end
% 
% % Add a cyclic prefix
% cpLength = round(0.1 * length(information)); % CP length is 10% of the information length
% ofdmSignalWithCP = [ofdmSignal(end - cpLength + 1:end), ofdmSignal];
% 
% % Remove the cyclic prefix
% ofdmSignalReceived = ofdmSignalWithCP(cpLength + 1:end);
% 
% % Simulate the received signal
% % Q3
% % How does the receiver know which carrier signal has been used?
% qamSymbolsReceived = carrySignal * ofdmSignal';
% 
% % Perform QAM demodulation
% dataReceived = qamdemod(qamSymbolsReceived, 2^bps, "UnitAveragePower", true);
% 
% % Check bit error rate
% errors = sum(dataReceived ~= information);
% bitErrorRate = errors / length(information);
% disp(['Bit Error Rate: ', num2str(bitErrorRate)]);
% 
% % Plot the received QAM symbols
% scatterplot(qamSymbolsReceived);
% title('Received QAM Symbols');