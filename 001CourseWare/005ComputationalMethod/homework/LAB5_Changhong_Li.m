% clear
clear;
close all;
% load the data in the mat
load("referenceARSignal.mat");
% 5a
residual = gennerateResidual(data, estimateARcoeffs(data, 3));

%% 5b1
% clear
clear;
close all;
% load the data in the mat
load("degradedARSignal.mat");
% plot the original data and detection vector b
figure(Name='Data Comparation');
t = 1 : 1 : 4096;
% origin data
subplot(2, 1, 1);
plot(t, degraded);
title('degraded');
% b
subplot(2, 1, 2);
plot(t, b);
title('b');

sgtitle('Fig1 Data Comparation');
%% 5b2
% clear
clear;
close all;
% load the data in the mat
load("degradedARSignal.mat");

interpolatedAR(degraded, b, estimateARcoeffs(degraded, 3));


% p = 3
function [restored, Ak, Au, ik] = interpolatedAR(datablock, detection, coeffs)
    
end

% function define find the error
function [residual] = gennerateResidual(data, coeffs)
    % find the order of the model
    p = length(coeffs);
    n = length(data);
    residual = zeros(n, 1);
    % find the residual of each val in data
    for k = (1 + p) : 1 : n
        for j = 1 : 1 : p
            residual(k) = data(k) - coeffs(j) * data(k - p);
        end
    end
    % conv version
    yk = zeros(1, p + 1);
    hk = zeros(1, p + 1);
    for k = (1 + p) : 1 : n
        % find yk
        for j = 0 : 1 : p 
            yk(j + 1) = y(k - j);
        end
        % find hk
        for j = 2 : 1 : p - 1 
            hk(j) = -coeffs(j - 1);
        end
        hk(1) = 1;
        % conv
        conv(yk, hk);
    end
    


end

% function define esitimateARcoeffs
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