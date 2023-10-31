%-----------------------------------------------------------------------%
% Function Name : clickGen
% Author        : Changhong Li
% Inputs:
% 1.signal: original signal
% 2.amp: amplitude of the click
% 3.num: numbers of the click
% Outputs:
% 1.detections:
% Description:
% insert clicks to the original signal
%-----------------------------------------------------------------------%
function [signal_c, bk] = clickGen(signal, amp, num)

signal_c = signal;                           % assign origin value
sz = length(signal);
click_amp = 2 * amp * (rand(1, sz) - 0.5);   % generate random clicks amp
pos = ceil(sz * (rand(1, num)));             % generate random clicks loc
click_amp = click_amp';
signal_c(pos) = signal(pos) + click_amp(pos);% insert clicks
bk = zeros(sz, 1);
bk(pos) = 1;                                 % generate bk vector
end