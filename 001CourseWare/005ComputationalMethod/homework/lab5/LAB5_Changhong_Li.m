% clear
clear;
close all;
% load the data in the mat
load("referenceARSignal.mat");
% 5a
residual = getResidual(data, estimateARcoeffs(data, 3));

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

interpolateAR(degraded, b, estimateARcoeffs(degraded, 3)');


% p = 3
function [restored, Ak, Au, yk] = interpolateAR(datablock, detection, coeffs)
    % calculate the error
    m_residual = getResidual(datablock, coeffs);
    % find A with coeffs
    p = length(coeffs);     % order of the algo 
    n = length(datablock);  % num of the datablock data
    A = zeros(n - p, n);    % e = Ay
    % 1 coff
    coeffs_b = [-1, coeffs]';
    for i = 1 : 1 : (n - p)
        for j = 1 : 1 : (p + 1)
            A(i ,j + i - 1) = - coeffs_b(p - j + 2);
        end
    end

    % e = Ay
    % A'e = A'Ay
    % y = (A'A)^(-1)A'e
    % ****bonus***
    % by using this formula , we can get y without split A

      restored = ((A' * A)^(-1)) * A' * m_residual;
    %  restored = A' * A;
    %  restored = (restored)^(-1);
    %  restored = restored * A';
    %  restored = restored * m_residual;

    % Cal Ak & Au
    % detection = 1 => missing data
    % c0 means the matrix still contain 0
    Au_c0 = A .* detection;
    Ak_c0 = A .* (~detection);
    yk_c0 = datablock .* (~detection');
    % clear zero col
    % all means check if each col is all zero col
    Au = Au_c0( : , ~(all(Au_c0 == 0, 1)));
    Ak = Ak_c0( : , ~(all(Ak_c0 == 0, 1)));
    yk = yk_c0( ~(all(yk_c0 == 0, 2)) , : );

end

% function define find the error
function [residual] = getResidual(data, coeffs)
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
    residual = residual((p + 1):end, :);
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