% --------------------------------- %
% Exam for CM  5:25
% --------------------------------- %
clear;
close all;
clc;
% --------------------------------- %
% Question 1
% Calculate sum of the main diagonal elements in an N x N matrix
% --------------------------------- %
fprintf("------test1 sum test------\r");
x = [1, 2, 3; 4, 5, 6; 7, 8, 9];
result1 = find_sum_of_diagonal(x);
fprintf("sum of diagonal is : %d\r", result1);
%%
% --------------------------------- %
% Question 2
% Test if the matrix is not square
% --------------------------------- %
fprintf("------test2 square check------\r");
x = [1, 2, 3; 4, 5, 6; 7, 8, 9; 10, 11, 12];
result2 = find_sum_of_diagonal(x);
fprintf("sum of diagonal is : %d\r", result2);
%%
% --------------------------------- %
% Question 3
% Determine if  the matrix is a identity matrix
% --------------------------------- %
fprintf("------test3 identity------\r");
x = my_eye(4);
result2 = find_sum_of_diagonal(x);
fprintf("sum of diagonal is : %d\r", result2);


% --------------------------------- %
% Funtion define
% --------------------------------- %
function diag_sum = find_sum_of_diagonal(x)
    size_x = size(x, 1);
    size_y = size(x, 2);
    if(size_x ~= size_y)
    % judge if the matrix is a square matrix
        disp("Please input a matrix with the same number of rows and columns");
        disp("The input matrix is not an identity matrix");
        diag_sum = -1;
    else
        n = length(x);
        % start to judge if it is a identity matrix
        if(x == my_eye(n))
            disp("The input matrix is an identity matrix");
        else
            disp("The input matrix is not an identity matrix");
        end
        % start calculate sum of main diagonal elements
        sum_l = 0;
        for i = 1 : 1 : n
            sum_l = sum_l + x(i, i);
        end
        diag_sum = sum_l;
    end
end

function eye_matrix = my_eye(n)
    eye_matrix_l = zeros(n);
    for i = 1 : 1 : n
        eye_matrix_l(i, i)= 1; 
    end
    eye_matrix = eye_matrix_l;
end

