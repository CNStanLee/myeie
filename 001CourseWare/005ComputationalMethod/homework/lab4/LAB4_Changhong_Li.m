% clear
clear;
close all;

% data load
load("referenceARSignal.mat");
y = data;
model_order = 2;
Num = length(y);

% 1.normalization
avg = mean(y);           % cal the mean val
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
a = - (R ^ (-1) * r);
disp(a);

[fun_coeffs, fun_avg] = estimateARcoeffs(y, 2);
disp(fun_coeffs);
disp(fun_avg);





% function define
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
