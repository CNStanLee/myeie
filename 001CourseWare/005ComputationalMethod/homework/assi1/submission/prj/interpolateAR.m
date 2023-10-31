%-----------------------------------------------------------------------%
% Function Name : interpolateAR
% Author        : Changhong Li
% Inputs:
% 1.datablock
% 2.detection
% 3.coeffs      :coeffients of the AR model
% Outputs:
% 1.res (residual)
% 2.Ak  (A known)
% 3.Au  (A unknown)
% 4.yk  (y known)
% Description:
% Based on the detection results, the untrusted data in the data block
% is replaced with the model prediction data
%-----------------------------------------------------------------------%

function [res, Ak, Au, yk] = interpolateAR(datablock, detection, coeffs)
    coeffs = [1 coeffs];    % 20231023 add 1 before coff
    p = length(coeffs);     % order of the algo 
    n = length(datablock);  % num of the datablock data
    % find A with coeffs
    A = zeros(n - p, n);    % e = Ay
    for i = 1 : 1 : (n - p + 1)
        for j = 1 : 1 : p
            A(i, j + i - 1) = coeffs(p - j + 1);
        end
    end
    Au = A(:, detection == 1);
    Ak = A(:, detection == 0);
    yk = datablock(detection == 0);
    res = datablock;
    yu = -1 * ((Au' * Au)) ^ (-1) * Au' * (Ak * yk);% cal yu
    res(detection == 1) = yu;
    yk = yk - mean(yk);

    %if(max(res) > 0.2)
    %    print("error")
    %end
end