%-----------------------------------------------------------------------%
% Function Name : click_removal
% Author        : Changhong Li
% Inputs:
% 1.ana_bs(analysis block size)
% 2.p(model order of the AR model)
% 3.thr(threshold)
% 4.y_deg(degraded signal)
% 5.ol(overlap)
% Outputs:
% 1.datap : processed data
% 2.bkp   : processed bk
% Description:
% find the para like MSE,CD,FA with input para by using AR interpolation
%-----------------------------------------------------------------------%
function [datap, bkp] = click_removal(ana_bs, p, thr, y_deg, ol)
%-----------------------------------------------------------------------%
% para def
%-----------------------------------------------------------------------%
    err_blk_size = ana_bs - ol;    % calculate size of err_blk

% default debug mode is 0: not debug
% if(~exist('dm','var'))
%     dm = 0; 
% end
%-----------------------------------------------------------------------%
% process
%-----------------------------------------------------------------------%
% 1 input signal
% 1.1.signal input from files
%[~, ~, y_deg, ~] = inputSignal(cf ,df);
% 1.2.divide signal with block_size
    [abk] = blockSignal(y_deg, ana_bs, ol); % overlap = 2p

% 2.find clicks
    nb = size(abk, 1);
    coeffs = zeros(nb, p);
    avgs = zeros(nb, 1);
    residuals = zeros(size(abk, 1), size(abk, 2) + p);
    dets = zeros(nb, err_blk_size);
    res = zeros(nb, err_blk_size);


% complete last block data with last block

%abk(nb, :) = [abk(nb - 1, (end-(ana_bs - rn - 1)) : end) abk(nb, 1 : rn)];
    ebd = abk(:, (1 + ol / 2) : (ana_bs - ol / 2));% error block data

    for i = 1 : 1 : nb
        % 2.1 find coeff and avg of each block
        [coeffs(i, :), avgs(i, 1)] = estimateARcoeffs(abk(i, :), p);
        % 2.2.find res of each analysis block
        [residuals(i, :)] = getResidual(abk(i, :), coeffs(i, :));
        % 2.3.mark error with thr
        [dets(i, :)] = markError(residuals(i, :), ol, ana_bs, thr, p);
        % 3.clean clicks
        % 3.1.generate predicted waveform & interpolate
        [res(i, :)] = interpolateAR(ebd(i, :)', (dets(i, :)), coeffs(i, :));
    end




% 4.combine fixed audio
% Merge each blocks
    y_com = reshape(res', numel(res), 1);
    det_en = reshape(dets', numel(dets), 1);
%derr = reshape(residuals', numel(residuals), 1);

    y_com = [y_deg(1:(ol / 2), 1) ; y_com];
    det_en = [zeros((ol / 2), 1) ; det_en];
%derr = [zeros(p,1) ; derr];

    l_deg = length(y_deg);
    l_com = length(y_com);

    if(l_deg > l_com)
        err_size = l_deg - l_com;
        y_com = [y_com;y_deg(end - err_size + 1: end, 1)];
        det_en = [det_en ; zeros(err_size, 1)];
        %derr = [derr; zeros(err_size, 1)];
    else
        y_com = y_com(1:length(y_deg));
        det_en = det_en(1:length(y_deg));
        %derr = derr(1:length(y_deg));
    end

    datap = y_com;
    bkp = det_en;

end

