% clear
clear;
close all;
% generate random input val
%sample_size = 100;
%y_origin = randn(sample_size);
%t = 0 : 1 : sample_size - 1;

load("referenceARSignal.mat");
y_origin = data;

% detect the clicks and crakles

% 1.divide the data to different block

block_size = length(y_origin);  % replace with the block size
block_nums = length(y_origin) / block_size;
y_blocked = zeros(block_nums, block_size);
model_order_P = 3; % replace with the model order

for i = 1 : 1 : block_nums 
    start_add = (block_size * (i - 1)) + 1;
    end_add = start_add + block_size - 1;
    for j = start_add : 1 : end_add
        y_blocked(i) = y_origin(j); 
    end
end

% 2.Normalise the input signal

y_normalized = zeros(block_nums, block_size);

for i = 1 : 1 : block_nums
    y_normalized(i) = y_blocked(i) - mean(y_blocked(i));
end

% 3.Esgimate the AR




