%-----------------------------------------------------------------------%
% Function Name : 
% Author        : Changhong Li
% Inputs:
% 1.ori_sig(original signal array)
% 2.bs(block size)
% 3.ol(overlap)
% Outputs:
% 1.blocked_signal  :matrix of blocked signal
% 2.res_num    :size of last block
% Description:
% divide origin signal into a lot of blocks, if there is data can not
% fill the block, extend the block with 0 values
%-----------------------------------------------------------------------%
function [blocked_signal, res_num] = blockSignal(ori_sig, bs, ol)
    ori_size = length(ori_sig);     % get size of ori sig
    % block size is analysis block size
    % analysis block size = error block size + ol
    err_blk_size = bs - ol;
    num_of_block = ceil((ori_size - ol) / err_blk_size); 
    blocked_signal = zeros(num_of_block, bs);
    % extend oringin signal
    new_length = err_blk_size * num_of_block + ol;
    res_num    = new_length - ori_size;
    ori_sig_e0 = [ori_sig; zeros(new_length - ori_size, 1)];
    for i = 1 : 1 : num_of_block
        start_add = (1 + (i -1) * err_blk_size);
        end_add = start_add + bs - 1;
        blocked_signal(i, :) = ori_sig_e0(start_add : end_add);
    end
end