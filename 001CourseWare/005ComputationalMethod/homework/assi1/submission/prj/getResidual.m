%-----------------------------------------------------------------------%
% Function Name : getResidual
% Author        : Changhong Li
% Inputs:
% 1.data    :
% 2.coeffs  :coeffs of the AR model
% Outputs:
% 1.residual between actual value and predicted value
% Description:
% find residual between actual value and predicted value(AR model)
%-----------------------------------------------------------------------%

function [residual] = getResidual(data, coeffs)
    coeffs = [1, coeffs];
    residual = conv(coeffs, data);
end