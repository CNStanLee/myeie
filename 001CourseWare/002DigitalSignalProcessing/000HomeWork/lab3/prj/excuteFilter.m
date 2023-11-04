%-----------------------------------------------------------------------%
% Function Name : excuteFilter
% Author        : Changhong Li
% Inputs:
% 1.xclean(clean voice signal)
% 2.fs(sampling frequency of the input signal)
% 3.note(note of the distortion)
% Outputs:
% 1.xdis : distorted signal
% 2.t : time series of the distorted signal
% Description:
% excute filter and get result
%-----------------------------------------------------------------------%
function [xf1, t, order] = excuteFilter(xdis, fs, filter_type, Fpass, Fstop, Apass, Astop)

tsetp = 1/fs;
d     = tsetp * (length(xdis) - 1);
t = 0 : tsetp : d; 

% Fpass = 1000; % First Passband Frequency
% Fstop = 3000; % Second Stopband Frequency
% Apass = 1; % Passband Ripple (dB)
% Astop = 80; % Second Stopband Attenuation (dB)
match = 'stopband'; % Ban d to match exactly

% filter1
h = fdesign.lowpass(Fpass, Fstop, Apass, Astop, fs);
Hd = design(h, filter_type, 'MatchExactly', match);
order = Hd.order;
% excute filter
xf1 = filter(Hd, xdis);

end