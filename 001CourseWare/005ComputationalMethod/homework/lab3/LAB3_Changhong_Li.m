% *****Clean******%
clear;
close all;

% ***** Demo Calculation time ******%
tic;    % begin to record time
A = rand(12000, 4400);  % generate random dataset A
B = rand(12000, 4400);  % generate random dataset B
disp(toc);  % display the time of generating the random dataset
C = A .* B; 
disp(toc);  % display the time of .*

% ***** Demo Calculation time of sum ******%
sample_size = 5;
n = zeros(0, sample_size);
time = zeros(0, sample_size);
% generate n : n = 10^i
for i = 1 : 1 : sample_size
    n(i) = 10 .^ i;
end
tic;    % begin to cal time
% call the function FindSum with dataset n & record time
for i = 1 : 1 : sample_size
    FindSum(n(i));
    time(i) = toc; % save the cal time into the array
end
% plot running time vs n
figure;
plot(n, time);
title('Fig1 ExecTime to Num(SUM)');
xlabel('Number n');
ylabel('Execution Time');

% **** Compute the factorial of 5, 10, 15, 20 **%
sample_size = 4;
n = zeros(1, sample_size);
time_of_fac = zeros(0, sample_size);
tic;    % begin to record time 
% call the function CalFactorial and record the running time
for i = 1 : 1 : sample_size
    disp(CalFactorial(i * 5));
    n(i) = i * 5;
    time_of_fac(i) = toc;
end
% plot running time(factorial) vs n
% y = n!
figure;
plot(n, time_of_fac);
title('Fig2 ExecTime to Num(factorial)');
xlabel('Number i');
ylabel('Execution Time');

% *****Part 2 Re-design Lab2 Code******%
% testify three function
ErrorMAD(0.5);
ErrorMAPE(0.5);
ErrorRate(0.56);
% exhaustive approach
tic;
for i = 0.1 : 0.1 : 2
    step_size = 2-i;
    disp("step_size = " + step_size);
    current_err = ErrorRate(step_size);
    disp("err = " + current_err);
end
time1 = toc;   % record time of exhaustive approach
% adaptive h step method
for i = 0.1 : 0.1 : 2
    step_size = 2-i;
    disp("step_size = " + step_size);
    current_err = ErrorRate(step_size);
    disp("err=" + current_err);
    if(current_err < 5)
      disp("The Critical Step Size has been found as " + step_size);
      disp("Error = " + current_err + "%");
      current_err = ErrorRate(step_size);
      break;
    end  
end
% compare two excution time
time2 = toc - time1;
disp("exhaustive approach");
disp(time1);
disp("adaptive h");
disp(time2);

% **************Function Def***************%
% Find the sum of (1, n) and return
function [sum] = FindSum( n )
    sum_l = 0 ;   % clean the sum local var
    for i = 1 : 1 : n
        sum_l = sum_l + n;
    end
    sum = sum_l;
end

% Find the factorial of the input positive int n
function [factorial] = CalFactorial(n)
    % avoid the input is not positive int
    if((rem(n,1) ~= 0) || (n < 0)) 
        disp('n must be positive integer')
        return;
    end
    if (n > 0)
        factorial = n * CalFactorial(n - 1);
    else
        factorial = 1;
    end
end

% Computation of error between two solutions - mean abs difference
function [mad_err] = ErrorMAD(h)
    % Init mad err
    mad_err_l = 0;
    % Analy solution
    [va, ~] = AnalyticSolution(h);
    % Nume solution
    [vn, ~] = NumericalSolution(h);
    % Find the mean abs diff
    n = length(va);
    for t = 1 : 1 : (n - 1)
        mad_err_l = mad_err_l + abs(va(t) - vn(t));     % sum of the abs error
    end
    % mean() to find value
    % Find average
        mad_err = mad_err_l ./ n;
    disp('when h is');
    disp(h);
    disp('MeanAbsDifference is');
    disp(mad_err);
end

% Computation of error between two solutions - MAPE
function [mape_err] = ErrorMAPE(h)
    % Init mad err
    mape_err_l = 0;
    % Analy solution
    [va, ~] = AnalyticSolution(h);
    % Nume solution
    [vn, ~] = NumericalSolution(h);
    % Find the mean abs diff
    n = length(va);
    for t = 2 : 1 : (n - 1)
        % sum of the abs error
        error_rate = abs(va(t) - vn(t));

        error_rate = error_rate ./ va(t) ./ 100;
        mape_err_l = mape_err_l + error_rate ;    
    end
    % Find average
        mape_err = mape_err_l ./ n;
        
    disp('when h is');
    disp(h);
    disp('MAPE is');
    disp(mape_err);
end

% Computation of the error rate
function [max_err] = ErrorRate(h)
    % Analy solution
    [va, ~] = AnalyticSolution(h);
    % Nume solution
    [vn, ~] = NumericalSolution(h);
    % Find the mean abs diff
    n = length(va);
    err = zeros(1,n);
    for i = 1 : n
      if(va(i) == 0)
        err(i) = 0;
      else
        err(i) = (abs(va(i) - vn(i))./va(i)).*100;    %erro rate
      end
    end
    max_err = max(err);
    disp('when h is');
    disp(h);
    disp('Max Error Rate is');
    disp(max_err);
end

% Computation of analytic solution
function [v, t] = AnalyticSolution(h)
        % const
        m = 70;
        g = 9.81;
        c = 12.5;
        % find v
        t = 0 : h : 20.0;
        v = (g * m / c ) * ( 1 - exp ( - c * t / m ));
end
% Computation of numerical solution
function [v, t] = NumericalSolution(h)
        t = 0 : h : 20.0;
        n = length(t);
        v = zeros(1, n);
        
        for i = 1 : n - 1
            slope = differential1(v(i));  %cal
            v(i + 1) = v(i) + slope * h;
        end
end
% differential1
function [out_slope] = differential1(input_y)
    %Const Def
    g = 9.81;
    c = 12.5;
    m = 70;
    out_slope = g - ((c * input_y) / m); 
end
