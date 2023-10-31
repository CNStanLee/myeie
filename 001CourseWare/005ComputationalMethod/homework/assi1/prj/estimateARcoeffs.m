%-----------------------------------------------------------------------%
% Function Name : estimateARcoeffs
% Author        : Changhong Li
% Inputs:
% 1.data
% 2.model_order
% Outputs:
% 1.coeffs(coefficients of the AR model)  *** with a minus symbol ***
% 2.avg(average value of the datablock)
% Description:
% estimate the coeffs of the AR model using coeffs = R ^ (-1) * r;
%-----------------------------------------------------------------------%
function [coeffs, avg] = estimateARcoeffs(data, model_order)
    % data load 
    y = data;
    Num = length(y);
    % 1.normalization
    avg = mean(y(model_order + 1 : end));           % cal the mean val
    y_n = y - avg;  % normalization
    % 2.solve r
    r = zeros(model_order, 1);
    for p = 1 : model_order
        for k = model_order + 1 : Num
            r(p, 1) = r(p, 1) + y_n(k) .* y_n(k - p); 
        end
    end
    % 3.solve R
    R = zeros(model_order, model_order);
    for p2 = 1: model_order
        for p = 1 : model_order
            for k = model_order + 1 : Num
                R(p, p2) = R(p, p2) + y_n(k - p2) .* y_n(k - p); 
            end
        end
    end
    % 4.solve a
    coeffs = R ^ (-1) * r;
    coeffs = -coeffs;
end