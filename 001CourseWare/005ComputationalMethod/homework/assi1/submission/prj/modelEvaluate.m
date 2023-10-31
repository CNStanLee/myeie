%-----------------------------------------------------------------------%
% Function Name : modelEvaluate
% Author        : Changhong Li
% Inputs:
% 1.datao    :origin  data
% 2.datap    :process data
% 3.bko      :origin  bk
% 4.bkp      :process bk
% Outputs:
% 1.MSE      : mean squared error between two signals
% 2.FPR      : false positive rate
% 3.TPR      : true positive rate
% 4.ME       : MaxErr
% Description:
% find residual between actual value and predicted value(AR model)
%-----------------------------------------------------------------------%

function [MSE, FPR, TPR, ME] = modelEvaluate(datao, datap, bko, bkp)

    TN = sum((bkp == 0) & (bko == 0));% TRUE  NEGATIVE
    FN = sum((bkp == 0) & (bko == 1));% FALSE NEGATIVE
    FP = sum((bkp == 1) & (bko == 0));% FALSE POSITIVE
    TP = sum((bkp == 1) & (bko == 1));% TRYE  POSITIVE

    TPR = TP / (TP + FN);       % RECALL
    FPR = FP / (FP + TN);       % FALSE ALARM
    MSE = mean((datap - datao) .^ 2);
    ME = max(abs((datap - datao))); 
end