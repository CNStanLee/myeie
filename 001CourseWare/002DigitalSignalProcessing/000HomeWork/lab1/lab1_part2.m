%clear
clear;
close all;


fs = 8000;
d = 2;
f0 = 800;


%4.2
N = ceil(fs * d); % one more sample maybe better
%4.3
n = (0 : 1 : (N - 1))';
t = n./(fs);        %0-d
%4.4
x = sin(2 * pi * f0 * t);
%4.5
%sound(x, fs);
%soundsc(x, fs);
%when the f0 get higher,the sounds is transforming from deep to
%high-pitched

%4.6

figure;
stem(t,x);
title('Lab1Fig7 x in [0,4T0]');
xlabel ('TimeIndex n ');
ylabel ('Amplitude');
xlim([0 (4*(1/f0))]);
ylim([-1 1]);

%4.7
figure;
delay = 2 * fs;
delayed_signal = sin(2 * pi  * ( n - delay) * f0 / fs);
stem(t, delayed_signal);
xlabel ('TimeIndex n ');
ylabel ('Amplitude');
xlim([0 (4*(1/f0))]);
ylim([-1 1]);


%4.8

fs = 8000;
d = 2;
f0 = 800;
N = ceil(fs * d); % one more sample maybe better
n0 = (0 : 1 : (N - 1))';
t0 = n0./(fs);        %0-d
x = sin(2 * pi * f0 * t0);

figure;
stem(t0, x);
xlim([0 (4*(1/f0))]);
ylim([-1 1]);

fs = 8000;
d = 2;
f0 = 400;
N = ceil(fs * d); % one more sample maybe better
n1 = (0 : 1 : (N - 1))';
t1 = n1./(fs);        %0-d
y1 = sin(2 * pi * f0 * t1);

figure;
stem(t1, y1);
xlim([0 (4*(1/f0))]);
ylim([-1 1]);

fs = 8000;
d = 4;
f0 = 400;
N = ceil(fs * d); % one more sample maybe better
n2 = (0 : 1 : (N - 1))';
t2 = n2./(fs);        %0-d
y2 = sin(2 * pi * f0 * t2);

fs = 8000;
d = 2;
f0 = 400;
N = ceil(fs * d); % one more sample maybe better
n3 = ((0 : 1 : (N - 1)) + (ceil((1/d)*(N - 1))))';
t3 = n3./(fs);        %0-d
y3 = sin(2 * pi * f0 * t3);

figure;
stem(t3, y3);
ylim([-1 1]);


[x_y1,x_y1_t] = AddSeq(x ,t0, y1, t1);
[x_y1_y2,x_y1_y2_t] = AddSeq(x_y1 ,x_y1_t, y2, t2);
AddSeq(x_y1_y2 ,x_y1_y2_t, y3, t3);

[x_y1,x_y1_t] = MulSeq(x ,t0, y1, t1);
[x_y1_y2,x_y1_y2_t] = MulSeq(x_y1 ,x_y1_t, y2, t2);
MulSeq(x_y1_y2 ,x_y1_y2_t, y3, t3);

[x_y1,x_y1_t] = ConvSeq(x ,t0, y1, t1);
[x_y1_y2,x_y1_y2_t] = ConvSeq(x_y1 ,x_y1_t, y2, t2);
ConvSeq(x_y1_y2 ,x_y1_y2_t, y3, t3);



