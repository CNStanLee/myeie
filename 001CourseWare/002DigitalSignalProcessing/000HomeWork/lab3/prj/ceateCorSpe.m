%-----------------------------------------------------------------------%
% Function Name : createCorSpe(create corrupted speech)
% Author        : Changhong Li
% Inputs:
% 1.xclean(clean voice signal)
% 2.fs(sampling frequency of the input signal)
% 3.note(note of the distortion)
% Outputs:
% 1.xdis : distorted signal
% 2.t : time series of the distorted signal
% Description:
% distort the origin signal with given note
%-----------------------------------------------------------------------%
function [xdis, t] = ceateCorSpe(xclean, fs, note)

% prameter of original signal

tsetp = 1/fs;
d     = tsetp * (length(xclean) - 1);
t = 0 : tsetp : d; 

% para of notes
% default value
start = 1;
amplitude = 0.5;
d_note = 30;

% generate note signal
note1 = createNote(d_note, note, fs, start, amplitude);
% make size same
note1 = [note1 ; zeros(length(xclean) - length(note1), 1)];
% add two signal up
xdis = xclean + note1;

end