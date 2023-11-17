clear 
clc
T = readtable ('ptbdb_abnormal.csv') ;
Tarray = table2array ( T ) ;
normalPatient = Tarray (1 ,1: end) ;
plot(Tarray, normalPatient);
verv = Tarray(1: end, 1);
S = Tarray;
T = normalPatient ;
F = verv;
% Set parameters for the spectrogram

% Plot the spectrogram in grayscale with white background
imagesc(T, F, 10*log10(abs(S)), [min(min(10*log10(abs(S)))) max(max(10*log10(abs(S))))]);

set(gca, 'YDir', 'normal'); % This is to ensure that the frequency axis is displayed correctly

% Set the figure background color to white
set(gcf, 'color', 'w');

% Add labels and title
xlabel('Time (seconds)');
ylabel('Frequency (Hz)');
title('Abnormal Patients');

% Add a colorbar to show intensity
colorbar;
