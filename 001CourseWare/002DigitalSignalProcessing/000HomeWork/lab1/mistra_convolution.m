% Program 2_2
% Illustration of Convolution
% Original code from Mistra book, edited by NH
%
display('You will be asked to input two sequences')
display('The output sequence plotted is the discrete convolution of your two input sequences')
clear all % all stored parameters wiped
close all % all open figures closed
a = input('Type in the first sequence = '); %can be h[n]
b = input('Type in the second sequence = '); % can be [x[n]
c = conv(a, b); % can think of c as sytem output y[n]
M = length(c)-1;
n = 0:1:M;
disp('output sequence =');disp(c)
stem(n,c)
xlabel('Time index n'); ylabel('Amplitude');