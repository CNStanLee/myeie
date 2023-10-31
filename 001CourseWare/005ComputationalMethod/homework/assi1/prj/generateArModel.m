%-----------------------------------------------------------------------%
% Function Name : generateArModel
% Author        : Changhong Li
% Inputs:
% 1.N       : number of the samples 
% 2.coe     : coeffs of the AR model
% Outputs:
% 1.ar_sig  : artificial AR signal
% Description:
% generate a artificial AR signal with given coefficients
%-----------------------------------------------------------------------%
function ar_sig = generateArModel(N, coe)
    N = N + length(coe) - 1;
    % generate gaus distribution
    avg = 0;    % avg
    sigma = 1;
    ran_data = avg + sigma * randn(1, N);

    % generate AR with IIR
    iir_filter = filter(1, [1, -coe], ran_data);

    % ignore first n samples
    N_to_disregard = length(coe);
    ar_sig = iir_filter(N_to_disregard:end);
    ar_sig = ar_sig';
end
