%-----------------------------------------------------------------------%
% Function Name : inputSigy_cleannal
% Author        : Changhong Li
% Inputs:
% 1.cf(clean file path)
% 2.df(degraded file path)
% 3.duration(s)
% Outputs:
% 1.yc : clean waveform y
% 2.fsc: clean waveform sampling frequency
% 3.yd : degraded waveform y
% 4.fsd: degraded waveform sampling frequency
% Description:
% read waveform from files
%-----------------------------------------------------------------------%
function [yc, fsc, yd, fsd] = inputSignal(cf, df)
    
    [yc, fsc] = audioread(cf);   % input clean
    [yd, fsd] = audioread(df);    % input deg
end