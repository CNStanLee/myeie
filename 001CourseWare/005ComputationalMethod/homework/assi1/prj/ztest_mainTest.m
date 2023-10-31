clear;
close all;
clc;

% para
ana_bs = 100;     % analysis block size of AR model
p = 2  ;     % order of AR model
threshold    = 0.3;     % threhold of the error

% file path
cf = 'clean.wav';
df = 'degraded.wav';

% find best para

%% 1.find how AR sizes affects the performance
% AR = 2, 5, 10

test_size = 100;
MSE = zeros(test_size, 5);
CD  = zeros(test_size, 5);
FA  = zeros(test_size, 5);
PT  = [3, 13, 14, 15, 20];

figure;
for j = 1 : 1 : 5
    p = PT(j);
    for i = 1 : 1 : test_size
        bs = 100;
        th = 0.1 + 0.01 * i;
        [MSE(i, j), CD(i, j), FA(i, j)] = click_removal(bs, p, th, cf, df);
    end
plot(FA(:, j), CD(:, j));
hold on;
end
legend('p = 3', 'p = 13', 'p = 14', 'p = 15', 'p = 20');
hold on;

% best AR model order 14
%% 2.find how block sizes affects the performance
% Block Size = 50 109 110 111 1024

test_size = 100;
MSE = zeros(test_size, 5);
CD  = zeros(test_size, 5);
FA  = zeros(test_size, 5);
BS  = [50, 109, 110, 111, 1024];

figure;
for j = 1 : 1 : 5
    p = 14;
    bs = BS(j);
    for i = 1 : 1 : test_size
        th = 0.1 + 0.01 * i;
        [MSE(i, j), CD(i, j), FA(i, j)] = click_removal(bs, p, th, cf, df);
    end
plot(FA(:, j), CD(:, j));
hold on;
end
legend('bs = 50', 'bs = 109', 'bs = 110', 'bs = 111', 'bs = 1024');

% bs 110
%% 2.1 find how block sizes affects the performance
% Block Size = 50 109 110 111 1024

test_size = 50;
MSE = zeros(test_size, 5);
CD  = zeros(test_size, 5);
FA  = zeros(test_size, 5);
BS  = [50, 109, 110, 111, 1024];

figure;
for j = 1 : 1 : 5
    p = 14;
    bs = BS(j);
    for i = 1 : 1 : test_size
        th(i, j) = 0.1 + 0.01 * i;
        [MSE(i, j), CD(i, j), FA(i, j)] = click_removal(bs, p, th(i, j), cf, df);
    end
plot(th(:, j), CD(:, j) ./ FA(:, j));

hold on;
end
legend('bs = 50', 'bs = 109', 'bs = 110', 'bs = 111', 'bs = 1024');

% th 0.38
%% 3.find interpolation performance

test_size = 30;
MSE = zeros(test_size, 5);
CD  = zeros(test_size, 5);
FA  = zeros(test_size, 5);
BS  = [100, 109, 110, 111, 1024];
PV  = zeros(test_size, 5);

figure;
for j = 1 : 1 : 5
    bs = BS(j);
    for i = 1 : 1 : test_size
        p = 1 + i;
        PV(i, j) = p;
        th = 0.38;
        [MSE(i, j)] = click_removal(bs, p, th, cf, df);
    end
plot(PV(:, j), MSE(:, j));
hold on;
end
legend('bs = 100', 'bs = 109', 'bs = 110', 'bs = 111', 'bs = 1024');
hold on;
%% 3.1 find max err
test_size = 15;
MSE = zeros(test_size, 5);
CD  = zeros(test_size, 5);
FA  = zeros(test_size, 5);
BS  = [100, 400, 800, 1600, 1300];
PV  = zeros(test_size, 5);
ME  = zeros(test_size, 5);
F12 = zeros(test_size, 5);

figure;
for j = 1 : 1 : 5
    bs = BS(j);
    for i = 1 : 1 : test_size
        p = 1 + i;
        PV(i, j) = p;
        th = 0.38;
        [MSE(i, j), CD(i, j), FA(i, j), F12(i, j), ME(i, j)] = click_removal(bs, p, th, cf, df);
    end
plot(PV(:, j), ME(:, j));
hold on;
end
legend('bs = 100', 'bs = 400', 'bs = 800', 'bs = 1024', 'bs = 1300');
hold on;

%% 4.plot waveform
close all;
p  = 13;
bs = 800;
th = 0.38;
click_removal(bs, p, th, cf, df, 1);

%% 5.find best coeff

for i = 1 : 1 : 10
    p = 5 + i;
    for j = 1 : 1 : 10
        bs = 100 + 200 * (j - 1);
        for k = 1 : 1 : 15
            th = 0.28 + k * 0.01;
            [MSE(i, j, k), CD(i, j, k), FA(i, j, k), F12(i, j, k), ME(i, j, k)] = click_removal(bs, p, th, cf, df, 0);
        end
    end
end



%%
% --------para------------
% analysis blocksize: 102.00000
% model order       : 14.00000
% threshold         : 0.34400
% --------result----------
% actual   error num: 134.00000
% detected error num: 130.00000
% correct_detection : 0.97015
% false_alarm       : 0.00000
% precision         : 1.00000
% f1 score          : 0.98485
% max_err           : 0.63461
% c / f             : Inf
% mse               : 0.0000271144

% --------para------------
% analysis blocksize: 1024.00000
% model order       : 14.00000
% threshold         : 0.38000
% --------result----------
% actual   error num: 134.00000
% detected error num: 201.00000
% correct_detection : 0.97015
% false_alarm       : 0.00068
% precision         : 0.64677
% f1 score          : 0.77612
% max_err           : 0.39999
% c / f             : 1432.89678
% mse               : 0.0000083986
 