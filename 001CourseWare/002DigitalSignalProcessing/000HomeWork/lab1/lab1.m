%    Title:DspLab1
%    Author:Changhong Li
%    Date:2023/09/18
%    Version:1_0_0

%2.2

%clear
clear;
close all;


%figure data
    figure;
    %input data
    x = [1,2,0,-1,1,2];
    %basic data
    t = 0 : 1 : 5;

    stem (t , x); % x as a function of t

%Style
    title ('Lab1Fig1 '); % Figure title
    xlabel ('TimeIndex n ');
    ylabel ('Amplitude');
    xlim ([-10 10]); % Restrict x values between 0 and 1
    ylim ([-3 3]); % Restrict y values between -1 and 1
    grid on;

%2.3
    figure;
    %original signal
    subplot(3,1,1);
    stem (t , x);
    hold on;

    title ('Lab1Fig2-1 original signal '); % Figure title
    xlabel ('TimeIndex n ');
    ylabel ('Amplitude');
    xlim ([-10 10]); % Restrict x values between 0 and 1
    ylim ([-3 3]); % Restrict y values between -1 and 1
    grid on;

    %delayed signal
    subplot(3,1,2);
    x_delay = horzcat(zeros(1, 2), x);
    t = 0 : 1 : 7;
    stem (t, x_delay);
    hold on;
    
    title ('Lab1Fig2-2 delayed signal '); % Figure title
    xlabel ('TimeIndex n ');
    ylabel ('Amplitude');
    xlim ([-10 10]); % Restrict x values between 0 and 1
    ylim ([-3 3]); % Restrict y values between -1 and 1
    grid on;

    %advanced signal
    subplot(3,1,3);
    x_advanced = horzcat(x, zeros(1, 3));
    t = -3 : 1 : 5;
    stem (t, x_advanced);

    title ('Lab1Fig2-3 advanced signal '); % Figure title
    xlabel ('TimeIndex n ');
    ylabel ('Amplitude');
    xlim ([-10 10]); % Restrict x values between 0 and 1
    ylim ([-3 3]); % Restrict y values between -1 and 1
    grid on;

%2.4
    x1 = [0, -1, 3, 0, 0];
    x2 = [0, 3, 3, 1, 2];
    t = 0 :1 :4;
    figure;
        subplot(3,1,1);
        stem(t, x1);
        title('Lab1Fig3-1 x1');
        xlabel ('TimeIndex n ');
        ylabel ('Amplitude');

        subplot(3,1,2);
        stem(t, x2);
        title('Lab1Fig3-2 x2');
        xlabel ('TimeIndex n ');
        ylabel ('Amplitude');

        subplot(3,1,3);
        stem(t, x1 + x2);
        title('Lab1Fig3-2 x1 + x2');
        xlabel ('TimeIndex n ');
        ylabel ('Amplitude');
%2.5
    % AddSeq(rand([1 3]),rand([1 3]),rand([1 3]),rand([1 3]));

    AddSeq([4,2,6,1],[5,7,6,2],[12,5,6,9],[5,7,6,2]);

%2.6
figure
x = [1, 0, 0, 0, -1, 0, -1];
h = [0, 0, 0, 1, 0, 0, 0];
y = conv(x,h);
t = -3 : 1 : (length(y) - 4);
stem(t, horzcat(x, zeros(1, 6)));
hold on;
stem(t, y);
title('Lab1Fig5');
xlabel ('TimeIndex n ');
ylabel ('Amplitude');
legend('x', 'y');
% y is the fig that x delayed,h will delay the input signal and the result 
% signal will begin from n = a

%2.7
T = readtable("IRL_DLY_RR_2021_grid.csv");
Tarray = table2array(T);
s = Tarray(1, 3 : end);


h1 = [0.9 0.1];
h2 = [0.01 0.99];
h3 = [0.1 0.2 0.3 0.4];

figure;

subplot(4,1,1);
y = s;
t = 1 : 1 : length(y);
stem(t, y);
title('Lab1Fig6-1 origin data');
xlabel ('TimeIndex n ');
ylabel ('Amplitude');

subplot(4,1,2);
y = conv(s, h1);
t = 1 : 1 : length(y);
stem(t, y);
title('Lab1Fig6-2 average filter [0.9 0.1]');
xlabel ('TimeIndex n ');
ylabel ('Amplitude');

subplot(4,1,3);
y = conv(s, h2);
t = 1 : 1 : length(y);
stem(t, y);
title('Lab1Fig6-3 average filter [0.01 0.99]');
xlabel ('TimeIndex n ');
ylabel ('Amplitude');

subplot(4,1,4);
y = conv(s, h3);
t = 1 : 1 : length(y);
stem(t, y);
title('Lab1Fig6-4 average filter [0.1 0.2 0.3 0.4]');
xlabel ('TimeIndex n ');
ylabel ('Amplitude');


%3

fs = 8000;
d = 2;
f0 = 800;
t = 0 : (1/fs) : (d-(1/fs));
x = sin(2 * pi * f0 * t);

figure;
stem(t,x);

title('sinewave model');
xlabel ('TimeIndex n ');
ylabel ('Amplitude');
%xlim ([1 800]); 
%ylim ([-3 3]); 











