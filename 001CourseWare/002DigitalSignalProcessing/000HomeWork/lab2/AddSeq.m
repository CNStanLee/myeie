function [y, nout] = AddSeq(x1 ,n1, x2, n2)
%ADDSEQ Add two seq
%   a function that takes as input two sequences, their respective time indices, and outputs the signal which is the sum of the two input sequences, and its time indices. It should also plot the inputted sequences and output in a single figure

% Confident for 
% 1.null input
% 2.single element input
% 3.x gets different size with n
% 4.input n is not in order
% 5.step size of two inputs can be different
% 6.can accept double type step
% 7.can avoid row add col
% 8.input row output row;input col output col
% 9.can tolerate different input data symbol size


% avoid same time two different val & avoid null array
if( isempty(x1) || isempty(x2) || isempty(n1) || isempty(n2) )
    disp('there is null array in the input variable');
    return;
end

% avoid num of x is diff from num of n1
if((length(x1) ~= length(n1)) || (length(x2) ~= length(n2)))
    disp('length of x is diff from n');
    return;
end

%avoid row + col

colnum = (iscolumn(x1) + iscolumn(n1) + iscolumn(x2) + iscolumn(n2));
if((colnum ~= 0) && (colnum ~= 4))
    disp('cant add row with col');
    return;
end







% find time variance
%nmin = min(horzcat(n1, n2));
%nmax = max(horzcat(n1, n2));
% 9.can tolerate different input data symbol size
nmin = min([min(n1) min(n2)]);
nmax = max([max(n1) max(n2)]);


% find min step
%step_n1 = (max(n1) - min(n1))./(size(n1) - 1);
%step_n2 = (max(n2) - min(n2))./(size(n2) - 1);
%to solve the case that the time is not in order

%disp(length(n1));
if(length(n1) == 1)
    n1_single = 1;
else
    for i = 1 : 1 : (length(n1))
    for j = (i+1) : 1 : (length(n1))
        step_size_cur = abs(n1(i) - n1(j));
        if((i == 1) && (j == 2))
            step_size_n1_min = step_size_cur;
        elseif(step_size_cur < step_size_n1_min)
            step_size_n1_min = step_size_cur;
        else
            
        end
    end
    end
    n1_single = 0;
end


if(length(n2) == 1)
    n2_single = 1;
else
    for i = 1 : 1 : length(n2)
        for j = (i+1) : 1 : length(n2)
            step_size_cur = abs(n2(i) - n2(j));
            if((i == 1) && (j == 2))
                step_size_n2_min = step_size_cur;
            elseif(step_size_cur < step_size_n2_min)
                step_size_n2_min = step_size_cur;
            else
                
            end
        end
    end
    n2_single = 0;
end
% if exist single array
if(n1_single == 0 && n2_single == 0)
    step_min = min([step_size_n1_min step_size_n2_min]);
elseif(n1_single == 1 && n2_single == 0)
    step_min = step_size_n2_min;
elseif(n1_single == 0 && n2_single == 1)
    step_min = step_size_n1_min;
else
    step_min = abs(n2(1) - n1(1));
end
% generate time variance
nout = nmin : step_min : nmax ;
x1_out = zeros(size(nout));
x2_out = zeros(size(nout));
%x_add_out = zeros(nmin : step_min : nmax);

% find if there is a value in seq1 or seq 2

for i = nmin : step_min : nmax 
    %find if there is a value in n1 or n2
    for j = 1 : 1 : length(n1)
        %test = n1(j);

        %if(i == n1(j))
        if(abs(i - n1(j))<0.00001)
            x1_out(((i - nmin) ./ step_min) + 1) = x1(j);
        end
    end

    for j = 1 : 1 : length(n2)
        if(abs(i - n2(j))<0.00001)
            x2_out(((i - nmin) ./ step_min) + 1) = x2(j);
        end
    end
end

% add x1 x2 up
x_add_out = x1_out + x2_out;

y = x_add_out;

if(iscolumn(x1))
    y = y';
    nout = nout';
end
