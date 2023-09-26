%Title:ex1_eulers_ODE
%Author:Changhong Li
%Date:16/09/2023
%Version:1_0_0

%Clear
clear;
close all;

%Scripts
    %find the best step size
    for i = 0.1 : 0.001 : 2
        step_size = 2-i;
        disp("step_size = " + step_size);

        current_err = CalMaxErr(step_size,0);
        disp("err=" + current_err);

        if(current_err < 5)
          disp("The Critical Step Size has been found as " + step_size);
          disp("Error = " + current_err + "%");
          current_err = CalMaxErr(step_size,1);
          break;
        end  
    end

%Functions
    
    %function_name : CalMaxErr
    %function_description : find max err with different step size
    function [max_err] = CalMaxErr(step_size,plot_flag)
        %ideal func
        %ParaDef
        %h = 1;            %Step size
        h = step_size;
        m = 70;
        g = 9.81;
        c = 12.5;
        t = 0 : h : 20.0;
        v= (g * m / c ) * ( 1 - exp ( - c * t / m ));
        if(plot_flag)
            plot(t,v,'r-');
            hold on;
        end
    %Euler
        %Para Def

        x = 0 : h : 20.0;    %Time Sample
        n = length(x);       %Sample Num
        y = zeros(1,n);      %Initial y to zero array
        y(1) = 0;            %y = 0 when x = 0
        %v(n+1) = vn +(g-cvn/m)(tn+1-tn)
    
        for i = 1 : n - 1
          slope = differential1(y(i));  %cal
          y(i+1) = y(i) + slope * h;
        end
        if(plot_flag)
        plot(x,y);           %plot my fig
        hold on;
        end
        
        err = zeros(1,n);
        for i = 1 : n
          %err = (abs(v - y)./v).*100;    %erro rate
          if(v(i) == 0)
            err(i) = 0;
          else
            err(i) = (abs(v(i) - y(i))./v(i)).*100;    %erro rate
          end
        end

        if(plot_flag)
        plot(x,err);
        hold on;
        end

        max_err = max(err);
        %disp(max(err));  %show the max of err ; destin < 0.5
    end


    %function_name : differential1
    %function_description : find dy/dt
    %slope = g - cvn/m
    function [out_slope] = differential1(input_y)
        %Const Def
        g = 9.81;
        c = 12.5;
        m = 70;
        out_slope = g - ((c * input_y) / m); 
    end