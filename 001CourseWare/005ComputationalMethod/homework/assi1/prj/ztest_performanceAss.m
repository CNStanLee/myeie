%% Test artificial signal 1.1
clear;
close all;

ds     = 1000;
bs     = 200;
p      = 3;
threshold   = 3;
overlap     = 0;

datao = generateArModel(ds, [0.3, -0.4, 0.1]);  % generate original ar sig
[so_deg, bko] = clickGen(datao, 10, 20);        % generate random click
[datap, bkp] = click_removal(bs, p, threshold, so_deg, overlap);
[MSE, FPR, TPR, ME] = modelEvaluate(datao, datap, bko, bkp);

fprintf("-----TestBegin-----\r");
fprintf("-----Parameter-----\r");
fprintf("BS  = %.6f\r", bs);
fprintf("P   = %.6f\r", p);
fprintf("THR = %.6f\r", threshold);
fprintf("OL  = %.6f\r", overlap);
fprintf("-----Result1-------\r");
fprintf("MSE = %.6f\r", MSE);
fprintf("FPR = %.6f\r", FPR);
fprintf("TPR = %.6f\r", TPR);
fprintf("ME  = %.6f\r", ME);
fprintf("-----Result2-------\r");
fprintf("real      detections = %.6f\r", sum(bko));
fprintf("different detections = %.6f\r", sum(bkp ~= bko));
fprintf("correct   detections = %.6f\r", sum((bkp == bko) & (bko == 1)));
fprintf("TPR / FPR            = %.6f\r", TPR / FPR);

t = 1 : 1 : ds;
figure;
subplot(7, 1, 1);
plot(t, datao);
title("datao");

subplot(7, 1, 2);
plot(t, so_deg);
title("so deg");

subplot(7, 1, 3);
plot(t, so_deg - datao);
title("dif");

subplot(7, 1, 4);
plot(t, datap);
title("datap");

subplot(7, 1, 5);
plot(t, datap - datao);
title("err")

subplot(7, 1, 6);
plot(t, bko);
title("bko")

subplot(7, 1, 7);
plot(t, bkp);
title("bkp")
%% Test artificial signal plot different distortion 1.2

clear;
close all;

ds     = 1000;
bs     = 200;
p      = 3;
%threshold   = 3;
overlap     = 0;
test_size   = 20;

do = generateArModel(ds, [0.3, -0.4, 0.1]);

MSE = zeros(20, 100);
FP = zeros(20, 100);
TP = zeros(20, 100);


figure;

for i = 1 : 1 : 3
    deg_lev = i * 4;
    for j = 1 : 1 : 100
        threshold = 2 + (j - 1) * 0.02;
        [so_deg, bko] = clickGen(do, deg_lev, 20);        
        [dp, bkp] = click_removal(bs, p, threshold, so_deg, overlap);
        [MSE(i, j), FP(i, j), TP(i, j)] = modelEvaluate(do, dp, bko, bkp);
    end
    % plot origin result
    scatter(FP(i, :), TP(i, :));

    leg_str{2 * i - 1} = ['deg = ', num2str(deg_lev)];
    %legend(sprintf("deg lev = %d", deg_lev));
    hold on;
    % plot fitting result
    fitresult = fit(FP(i, :)', TP(i, :)', 'poly2');
    xv = linspace(min(FP(i, :)), max(FP(i, :)), 100);
    yv = feval(fitresult, xv);
    plot(xv, yv);
    leg_str{2 * i} = ['deg = ', num2str(deg_lev)];
    hold on;
end

legend(leg_str);
xlabel("FPR");
ylabel("TPR");

 print -depsc fig4.eps  
%% Test artificial signal plot different distortion MSE 1.3

clear;
close all;

ds     = 1000;
bs     = 200;

%threshold   = 3;
overlap     = 0;
test_size   = 20;

do = generateArModel(ds, [0.3, -0.4, 0.1]);

MSE = zeros(3, 20);
FP  = zeros(3, 20);
TP  = zeros(3, 20);
pm  = zeros(3, 20);

figure;
threshold = 3;

for i = 1 : 1 : 3
    deg_lev = i * 4;
    for j = 1 : 1 : 20
        p = j;
        [so_deg, bko] = clickGen(do, deg_lev, 20);        
        [dp, bkp] = click_removal(bs, p, threshold, so_deg, overlap);
        [MSE(i, j), FP(i, j), TP(i, j)] = modelEvaluate(do, dp, bko, bkp);
        pm(i, j) = p;
    end
    % plot origin result
    plot(pm(i, :), MSE(i, :));
    ylim([0, 0.5]);
    xlim([1, 20]);
    leg_str{i} = ['deg = ', num2str(deg_lev)];
    hold on;
end

legend(leg_str);
xlabel("Order");
ylabel("MSE");

print -depsc fig5.eps  

%% test with degraded clean signal 2.1

clear;
close all;

bs = 1200;
p  = 3;
threshold = 0.35;
overlap = 0;

[clean, fc, yd, fd] = inputSignal("clean.wav", "degraded.wav");

clean = clean ./ 2;

[so_deg, bko] = clickGen(clean, 2, 100);  

[datap, bkp] = click_removal(bs, p, threshold, so_deg, overlap);
[MSE, FPR, TPR, ME] = modelEvaluate(clean, datap, bko, bkp);


fprintf("-----TestBegin-----\r");
fprintf("-----Parameter-----\r");
fprintf("BS  = %.6f\r", bs);
fprintf("P   = %.6f\r", p);
fprintf("THR = %.6f\r", threshold);
fprintf("OL  = %.6f\r", overlap);
fprintf("-----Result1-------\r");
fprintf("MSE = %.6f\r", MSE);
fprintf("FPR = %.6f\r", FPR);
fprintf("TPR = %.6f\r", TPR);
fprintf("ME  = %.6f\r", ME);
fprintf("-----Result2-------\r");
fprintf("real      detections = %.6f\r", sum(bko));
fprintf("different detections = %.6f\r", sum(bkp ~= bko));
fprintf("correct   detections = %.6f\r", sum((bkp == bko) & (bko == 1)));
fprintf("TPR / FPR            = %.6f\r", TPR / FPR);

t = 1 : 1 : length(datap);

figure;
subplot(3, 1, 1);
plot(t, clean);
title('clean');
subplot(3, 1, 2);
plot(t, so_deg);
title('yd');
subplot(3, 1, 3);
plot(t, datap);
title('datap');

print -depsc fig9v2.eps
%%
subplot(6, 1, 4);
plot(t, clean - yd);
title('err');
subplot(6, 1, 5);
plot(t, bkp);
title('detp');
subplot(6, 1, 6);
plot(t, bko);
title('detr');

%% test with degraded clean signal 2.2 different p 

clear;
close all;

bs = 1200;
p  = 3;
threshold = 0.35;
overlap = 0;

[clean, fc, yd, fd] = inputSignal("clean.wav", "degraded.wav");

clean = clean ./ 2;

pset = [2, 5, 10];

FP  = zeros(3, 100);
TP  = zeros(3, 100);
pm  = zeros(3, 100);


[so_deg, bko] = clickGen(clean, 2, 100); 

figure;

for i = 1 : 1 : 3
    p = pset(i);
    for j = 1 : 1 : 40
        threshold = 0.01 * j;
        [datap, bkp] = click_removal(bs, p, threshold, so_deg, overlap);
        [~, FP(i, j), TP(i, j)] = modelEvaluate(clean, datap, bko, bkp);
    end

    plot(FP(i, :), TP(i, :));
    leg_str{i} = ['p = ', num2str(p)];

    hold on;
end

legend(leg_str);
xlim([0, 0.6]);
ylim([0.8, 1]);
xlabel("FPR");
ylabel("TPR");

print -depsc fig6.eps

%% test with degraded clean signal 2.3 different bs

clear;
close all;

bs = 1200;
p  = 10;
threshold = 0.35;
overlap = 0;

[clean, fc, yd, fd] = inputSignal("clean.wav", "degraded.wav");

clean = clean ./ 2;

pset = [2, 14, 20];
dsset = [1024, 2048, 4096];

FP  = zeros(3, 100);
TP  = zeros(3, 100);
pm  = zeros(3, 100);


[so_deg, bko] = clickGen(clean, 2, 100); 

figure;

for i = 1 : 1 : 3
    bs = dsset(i);
    for j = 1 : 1 : 50
        threshold = 0.01 * j;
        [datap, bkp] = click_removal(bs, p, threshold, so_deg, overlap);
        [~, FP(i, j), TP(i, j)] = modelEvaluate(clean, datap, bko, bkp);
    end

    plot(FP(i, :), TP(i, :));
    leg_str{i} = ['bs = ', num2str(bs)];

    hold on;
end

legend(leg_str);
xlim([0, 0.6]);
ylim([0.8, 1]);
xlabel("FPR");
ylabel("TPR");

print -depsc fig7.eps

%% test with degraded clean signal distortion MSE 2.4

clear;
close all;

clear;
close all;

bs = 1200;
p  = 10;
threshold = 0.35;
overlap = 0;

[clean, fc, yd, fd] = inputSignal("clean.wav", "degraded.wav");

clean = clean ./ 2;

pset = [2, 14, 20];
dsset = [1024, 2048, 4096];

FP  = zeros(3, 30);
TP  = zeros(3, 30);
pm  = zeros(3, 30);
MSE = zeros(3, 30);

[so_deg, bko] = clickGen(clean, 2, 100); 

figure;

for i = 1 : 1 : 3
    bs = dsset(i);
    for j = 1 : 1 : 30
        p = j;
        [datap, bkp] = click_removal(bs, p, threshold, so_deg, overlap);
        [MSE(i, j)]  = modelEvaluate(clean, datap, bko, bkp);
        pm(i, j)     = p;
    end

    plot(pm(i, :), MSE(i, :));
    leg_str{i} = ['bs = ', num2str(bs)];

    hold on;
end

legend(leg_str);
xlabel("p");
ylabel("MSE");

print -depsc fig8.eps 

%% test with degraded signal 3.1

clear;
close all;

clear;
close all;

bs = 1200;
p  = 3;
threshold = 0.35;
overlap = 2;

[clean, fc, yd, fd] = inputSignal("clean.wav", "degraded.wav");

clean = clean ./ 2;
bko = (abs(clean - yd)) > 0.1;
tic;
[datap, bkp] = click_removal(bs, p, threshold, yd, overlap);
runtime = toc;
[MSE, FPR, TPR, ME] = modelEvaluate(clean, datap, bko, bkp);

fprintf("-----TestBegin-----\r");
fprintf("-----Parameter-----\r");
fprintf("BS  = %.6f\r", bs);
fprintf("P   = %.6f\r", p);
fprintf("THR = %.6f\r", threshold);
fprintf("OL  = %.6f\r", overlap);
fprintf("-----Result1-------\r");
fprintf("MSE = %.6f\r", MSE);
fprintf("FPR = %.6f\r", FPR);
fprintf("TPR = %.6f\r", TPR);
fprintf("ME  = %.6f\r", ME);
fprintf("-----Result2-------\r");
fprintf("real      detections = %.6f\r", sum(bko));
%fprintf("different detections = %.6f\r", sum(bkp ~= bko));
fprintf("correct   detections = %.6f\r", sum((bkp == bko) & (bko == 1)));
fprintf("TPR / FPR            = %.6f\r", TPR / FPR);
fprintf("runtime              = %.6f\r", runtime);
t = 1 : 1 : length(datap);

figure;
subplot(6, 1, 1);
plot(t, clean);
title('clean');
subplot(6, 1, 2);
plot(t, yd);
title('yd');
subplot(6, 1, 3);
plot(t, datap);
title('datap');
subplot(6, 1, 4);
plot(t, clean - yd);
title('err');
subplot(6, 1, 5);
plot(t, bkp);
title('detp');
subplot(6, 1, 6);
plot(t, bko);
title('detr');

print -depsc fig12.eps 

%% test with degraded clean signal 3.2 different p 

clear;
close all;

bs = 1200;
p  = 3;
threshold = 0.35;
overlap = 0;

[clean, fc, yd, fd] = inputSignal("clean.wav", "degraded.wav");

clean = clean ./ 2;
bko = (abs(clean - yd)) > 0.1;

pset = [2, 5, 10];

FP  = zeros(3, 100);
TP  = zeros(3, 100);
pm  = zeros(3, 100);

figure;

for i = 1 : 1 : 3
    p = pset(i);
    for j = 1 : 1 : 40
        threshold = 0.01 * j;
        [datap, bkp] = click_removal(bs, p, threshold, yd, overlap);
        [~, FP(i, j), TP(i, j)] = modelEvaluate(clean, datap, bko, bkp);
    end

    plot(FP(i, :), TP(i, :));
    leg_str{i} = ['p = ', num2str(p)];

    hold on;
end

legend(leg_str);
xlabel("FPR");
ylabel("TPR");
xlim([0, 0.04]);
ylim([0.8, 1]);
print -depsc fig9.eps 

%% test with degraded clean signal 3.3 different bs

clear;
close all;

bs = 1200;
p  = 10;
threshold = 0.35;
overlap = 0;

[clean, fc, yd, fd] = inputSignal("clean.wav", "degraded.wav");

clean = clean ./ 2;
bko = (abs(clean - yd)) > 0.1;

pset = [2, 14, 20];
dsset = [1024, 2048, 4096];

FP  = zeros(3, 100);
TP  = zeros(3, 100);
pm  = zeros(3, 100);


[so_deg, bko] = clickGen(clean, 2, 100); 

figure;

for i = 1 : 1 : 3
    bs = dsset(i);
    for j = 1 : 1 : 50
        threshold = 0.01 * j;
        [datap, bkp] = click_removal(bs, p, threshold, yd, overlap);
        [~, FP(i, j), TP(i, j)] = modelEvaluate(clean, datap, bko, bkp);
    end

    plot(FP(i, :), TP(i, :));
    leg_str{i} = ['bs = ', num2str(bs)];

    hold on;
end

legend(leg_str);
xlabel("FPR");
ylabel("TPR");
xlim([0, 0.6]);
ylim([0.8, 1]);
print -depsc fig10.eps 

%% test with degraded clean signal distortion MSE 3.4

clear;
close all;

clear;
close all;

bs = 1200;
p  = 10;
threshold = 0.35;
overlap = 0;

[clean, fc, yd, fd] = inputSignal("clean.wav", "degraded.wav");

clean = clean ./ 2;
bko = (abs(clean - yd)) > 0.1;

pset = [2, 14, 20];
dsset = [1024, 2048, 4096];

FP  = zeros(3, 100);
TP  = zeros(3, 100);
pm  = zeros(3, 100);
MSE = zeros(3, 100);

[so_deg, bko] = clickGen(clean, 2, 100); 

figure;

for i = 1 : 1 : 3
    bs = dsset(i);
    for j = 1 : 1 : 30
        p = j;
        [datap, bkp] = click_removal(bs, p, threshold, yd, overlap);
        [MSE(i, j)]  = modelEvaluate(clean, datap, bko, bkp);
        pm(i, j)     = p;
    end

    plot(pm(i, :), MSE(i, :));
    leg_str{i} = ['bs = ', num2str(bs)];

    hold on;
end

legend(leg_str);
xlabel("p");
ylabel("MSE");

print -depsc fig11.eps 
%%
ds     = 500;
datao = generateArModel(ds, [0.3, -0.4, 0.1]);  % generate original ar sig
datao = [datao; zeros(300, 0)];
[coeffs, avg] = estimateARcoeffs(datao, 3);

