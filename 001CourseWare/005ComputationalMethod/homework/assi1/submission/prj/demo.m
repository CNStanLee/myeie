%-----------------------------------------------------------------------%
% clear
%-----------------------------------------------------------------------%
clear;
close all;
%-----------------------------------------------------------------------%
% parameters
%-----------------------------------------------------------------------%
bs = 1200;          % block size
p = 3;              % model order
threshold = 0.35;
overlap = 2;
mduration = 10;   

%-----------------------------------------------------------------------%
% process
%-----------------------------------------------------------------------%

% input signal
[clean, fc, yd, fd] = inputSignal("clean.wav", "degraded.wav");
ds = mduration * fc;

% split signal
clean = clean(1 : ds); 
yd = yd(1 : ds);

% process signal
clean = clean ./ 2;
bko = (abs(clean - yd)) > 0.1;
tic;
[datap, bkp] = click_removal(bs, p, threshold, yd, overlap);
runtime = toc;
[MSE, FPR, TPR, ME] = modelEvaluate(clean, datap, bko, bkp);

%-----------------------------------------------------------------------%
% generate files
%-----------------------------------------------------------------------%



% sound
% data_size_c default 5s
ds5 = mduration / 2 * fc;

combine_music = [yd(1 : ds5) ; datap(ds5 + 1 : 2 * ds5)];

sound(combine_music, fc);

% generate output.wav
audiowrite("output.wav", combine_music, fd);


%-----------------------------------------------------------------------%
% result print and figure
%-----------------------------------------------------------------------%
%%
%fprintf( " TestBegin \r " );
%fprintf( " Parameter \r " );
fprintf("BS = %.6f\r", bs);
fprintf("P = %.6f\r", p);
fprintf("THR = %.6f\r", threshold);
fprintf("OL = %.6f\r", overlap);
%fprintf("Result1\r");
fprintf("MSE = %.6f\r", MSE);
fprintf("FPR = %.6f\r", FPR);
fprintf("TPR = %.6f\r", TPR);
fprintf("ME = %.6f\r", ME);
%fprintf("Result2\r");
fprintf("real      detections = %.6f\r", sum(bko));
%fprintf("different detections = %.6f\r", sum(bkp ~= bko));
fprintf("correct   detections = %.6f\r", sum((bkp == bko) & (bko == 1)));
fprintf("TPR / FPR = %.6f\r", TPR / FPR);
fprintf("runtime = %.6f\r", runtime);
t = 1 : 1 : length(datap);

figure(1);
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
