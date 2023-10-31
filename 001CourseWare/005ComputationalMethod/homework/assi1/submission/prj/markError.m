%-----------------------------------------------------------------------%
% Function Name : markError
% Author        : Changhong Li
% Inputs:
% 1.res(residuals):
% 2.ol(over lap):
% 3.ana_bs(analysis block size):
% 4.threshold
% 5。p
% Outputs:
% 1.detections:
% Description:
% Use the threshold to determine the error value and then flag the error
%-----------------------------------------------------------------------%
function [detections] = markError(res, ol, ana_bs, threshold, p)
% map the error block data residual
res2 = res(1 : end - p);                    % remove useless data
err_blk_res = res2((1 + ol / 2) : (ana_bs - ol / 2));
% judege data and find clicks
detections = abs(err_blk_res) > threshold ; % 1 -> error
end
