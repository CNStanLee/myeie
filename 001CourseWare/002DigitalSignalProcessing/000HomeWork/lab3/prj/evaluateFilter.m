%-----------------------------------------------------------------------%
% Function Name : evaluateFilter
% Author        : Changhong Li
% Inputs:
% 1.xclean(clean voice signal)
% 2.xf1(filtered signal)
% Outputs:
% 1.mse : mean squared error between clean and filterd signal
% Description:
% evaluate the performance of the filter result
%-----------------------------------------------------------------------%
function [mse] = evaluateFilter(xclean, xf1)
mse = mean((xf1 - xclean) .^ 2);
end