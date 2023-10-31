clear;
close all;

%-----------------------------------------------------------------------%
% para def
%-----------------------------------------------------------------------%
p  = 13;
bs = 800;
th = 0.38;
% file path
cf = 'clean.wav';
df = 'degraded.wav';

dm = 1;
ana_bs = bs;
thr = th;

err_blk_size = ana_bs - 2 * p;    % calculate size of err_blk

% default debug mode is 0: not debug
if(~exist('dm','var'))
    dm = 0; 
end
%-----------------------------------------------------------------------%
% process
%-----------------------------------------------------------------------%
% 1 input signal
% 1.1.signal input from files
[y_clean, ~, y_deg, fsd] = inputSignal(cf ,df);
% 1.2.divide signal with block_size
[ana_block] = blockSignal(y_deg, ana_bs, p * 2);
% 2.find clicks
num_of_blocks = size(ana_block, 1);
coeffs = zeros(num_of_blocks, p);
avgs = zeros(num_of_blocks, 1);
residuals = zeros(size(ana_block,1), size(ana_block,2) + p);
dets = zeros(num_of_blocks, err_blk_size);
res = zeros(num_of_blocks, err_blk_size);
ebd = ana_block(: , (1 + p) : (ana_bs - p));% error block data

for i = 1 : 1 : num_of_blocks
    % 2.1 find coeff and avg of each block
    [coeffs(i, :), avgs(i, 1)] = estimateARcoeffs(ana_block(i, :), p);
    % 2.2.find res of each analysis block
    [residuals(i, :)] = getResidual(ana_block(i, :), coeffs(i, :));
    % 2.3.mark error with thr
    [dets(i, :)] = markError(residuals(i, :), p, ana_bs, thr);
    % 3.clean clicks
    % 3.1.generate predicted waveform & interpolate
    [res(i, :)] = interpolateAR(ebd(i, :)', (dets(i, :)), coeffs(i, :));
end

% 4.combine fixed audio
% Merge each blocks
y_com = reshape(res', numel(res), 1);
det_end = reshape(dets', numel(dets), 1);
derr = reshape(residuals', numel(residuals), 1);

y_com = [y_deg(1:p, 1) ; y_com];
det_end = [zeros(p,1) ; det_end];
derr = [zeros(p,1) ; derr];

l_deg = length(y_deg);
l_com = length(y_com);

if(l_deg > l_com)
    err_size = l_deg - l_com;
    y_com = [y_com;y_deg(end - err_size + 1: end, 1)];
    det_end = [det_end ; zeros(err_size, 1)];
    derr = [derr; zeros(err_size, 1)];
else
    y_com = y_com(1:length(y_deg));
    det_end = det_end(1:length(y_deg));
    derr = derr(1:length(y_deg));
end

% 5.Cal result
y_clean_n = y_clean ./ 2;                           % Uniform Amp
act_det = abs((y_clean_n - y_deg)) > 0.02;% detect act err
% evaluate
% calculate Correct Detection

TN = sum((det_end == 0) & (act_det == 0));% TRUE  NEGATIVE
FN = sum((det_end == 0) & (act_det == 1));% FALSE NEGATIVE
FP = sum((det_end == 1) & (act_det == 0));% FALSE POSITIVE
TP = sum((det_end == 1) & (act_det == 1));% TRYE  POSITIVE

recall = TP / (TP + FN);    % RECALL
FPR = FP / (FP + TN);       % FALSE ALARM
pre = TP / (TP + FP);       % PRECISION
F1 = 2 * (recall * pre) / (pre + recall);

% calculate para
MSE = mean((y_com - y_clean_n).^2);
CD = recall;
FA = FPR;
max_err = max(abs(y_com - y_clean));

% debug output
if(dm == 1)
    % figure;
    % x = 1 : 1 : 105000; 
    % subplot(6,1,1);
    % plot(x,y_clean_n);
    % ylim([-1, 1]);
    % title('y clean');
    % subplot(6,1,2);
    % plot(x,y_deg);
    % ylim([-1, 1]);
    % title('y deg');
    % subplot(6,1,3);
    % plot(x,y_clean_n - y_deg);
    % ylim([-1, 1]);
    % title('acc err');
    % subplot(6,1,4);
    % plot(x,act_det);
    % title('acc det');
    % subplot(6,1,5);
    % plot(x,y_com);
    % ylim([-1, 1]);
    % title('result');
    % subplot(6,1,6);
    % plot(x,det_end);
    % title('result detect');

    figure(1);
    t = 0 : 1 / fsd : (length(y_deg) - 1) / fsd;
    %subplot(2, 1, 1);
    plot(t, y_deg - y_clean);
    xlabel('Time(s)');
    ylabel('clicks');
    print -depsc fig1.eps  
    % subplot(3, 1, 2);
    % plot(t, derr);
    % xlabel('Time(ms)');
    % ylabel('Prediction Error');

    % subplot(2, 1, 2);
    % plot(t, act_det);
    % xlabel('Time(ms)');
    % ylabel('|e| > 0.02');

    figure(2);
    

    subplot(3, 1, 1);
    plot(t, y_deg);
    xlabel('Time(s)');
    ylabel('degraded signal');

    subplot(3, 1, 2);
    plot(t, derr);
    xlabel('Time(s)');
    ylabel('Prediction Error')

    subplot(3, 1, 3);
    plot(t, act_det);
    xlabel('Time(s)');
    ylabel('|e| > 0.02');

    print -depsc fig3.eps  

    
    fprintf("--------para------------\n");
    fprintf("analysis blocksize: %.5f\n", ana_bs);
    fprintf("model order       : %.5f\n", p);
    fprintf("threshold         : %.5f\n", thr);

    fprintf("--------result----------\n");
    fprintf("actual   error num: %.5f\n", sum(act_det == 1));
    fprintf("detected error num: %.5f\n", sum(det_end == 1));
    fprintf("correct_detection : %.5f\n", CD);
    fprintf("false_alarm       : %.5f\n", FA);
    fprintf("precision         : %.5f\n", pre);
    fprintf("f1 score          : %.5f\n", F1);
    fprintf("max_err           : %.5f\n", max_err);
    fprintf("c / f             : %.5f\n", CD / FA);
    fprintf("mse               : %.10f\n", MSE);
    sound(y_com, fsd);
end