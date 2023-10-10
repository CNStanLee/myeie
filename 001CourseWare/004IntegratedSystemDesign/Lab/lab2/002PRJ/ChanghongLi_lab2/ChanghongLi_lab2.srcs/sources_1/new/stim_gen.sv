`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.10.2023 17:16:25
// Design Name: 
// Module Name: stim_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module stim_gen
    #(parameter N = 8, T = 2, Ts = 300000, Ts2 =  600000)
    (
     output reg clk, reset,
     output reg a, b,
     output reg inc_exp, dec_exp
        );
    
    integer log_file;
    /* Generate the clk */
    always
    begin
            clk = 1'b1;
            #(T / 2);
            clk = 1'b0;
            #(T / 2);
    end
    
    /* Test procedure */
    initial
    begin
        initialize();
        test_reset();
        
        print_log("*******The Test begin*******");
        print_log("inc_exp   dec_exp   hold_exp  inc       dec       hold      pass");
        /* Forward Test */
        print_log("begin the forward test");
        print_log("begin the enter test");
        test_entrance(6);
        print_log("begin the exit test");
        test_exit(6);
        /* Backward Test */
        print_log("begin the backward test");
        print_log("begin the reach_low test");
        test_reach_low();
        print_log("begin the reach_max test");
        test_reach_max();
        print_log("begin the exit_fail test");
        test_exit_fail();
        print_log("begin the enter_fail test");
        test_enter_fail();
        /* End Test */

        print_log("*******The Test is done*******");
        $stop;
    end
    
    /* ****************************** */
    /* Task Definitions */   
    /* ****************************** */
    /* test task : initialize the para of the sys */
    task initialize();
    // system initialization
    begin
        a = 0;
        b = 0;
 
        inc_exp = 0;
        dec_exp = 0;

    end
    endtask
    /* test task : reset all the system */
    task test_reset();
    begin

        reset = 1;
        #Ts2;
        reset = 0;
        #Ts2;
    end
    endtask
    
    /****************************************************/
    /* Forward Testing */
    /****************************************************/
    
    /* test task : simulate the entrance sensor status */
    task test_entrance(input integer n);
    begin
        repeat(n) begin
        inc_exp <= 0;
        dec_exp <= 0;
        a = 1;
        #Ts;
        b = 1;
        #Ts;
        a = 0;
        #Ts;
        b = 0;
        @(posedge clk);
        inc_exp = 1;    // expected inc
        
        #Ts2;
        inc_exp = 0;
        dec_exp = 0;

        #Ts2;
        end
    end
    endtask
    /* test task : simulate the exit sensor status */
    task test_exit(input integer n);
    begin
        repeat(n) begin
        inc_exp <= 0;
        dec_exp <= 0;
        b = 1;
        #Ts;
        a = 1;
        #Ts;
        b = 0;
        #Ts;
        a = 0;
        @(posedge clk);
        dec_exp = 1;    // expected dec
        
        #Ts2;
        inc_exp = 0;
        dec_exp = 0;
    
        #Ts2;
        end
    end
    endtask
    /****************************************************/
    /* Backward Testing */
    /****************************************************/
    
    /* test task : simulate the exit when there is no car in the park */
    /* expected that the counter hold the value*/
    /* use dec_exp = 1 && inc_exp = 1 as the signal that the count should be hold*/
    task test_reach_low();
    begin
    
        /* reset the expected value*/
        inc_exp <= 0;
        dec_exp <= 0;
        #Ts2;
        test_reset();   /* reset the machine , reach the count to 0*/
        #Ts;
        

        /* begin to simulate the action to exit*/
        b = 1;
        #Ts;
        a = 1;
        #Ts;
        b = 0;
        #Ts;
        a = 0;
        @(posedge clk);
        /* dec = 1 inc = 1 indicates that the num should not be changed*/
        dec_exp <= 1;    
        inc_exp <= 1;
        #Ts2;
        
        
        inc_exp = 0;
        dec_exp = 0;
        #Ts2;        

    end
    endtask
    
    /* test task : simulate the exit when the car num in the park reach the max val */
    /* expected that the counter hold the value*/
    /* use dec_exp = 1 && inc_exp = 1 as the signal that the count should be hold*/
    task test_reach_max();
    begin
        /* reset the expected value*/
        inc_exp <= 0;
        dec_exp <= 0;
        #Ts2;
        test_reset();   /* reset the machine , reach the count to 0*/
        

        
        #Ts;
        
        // reach the max value
        repeat(15)begin
        a = 1;
        #Ts;
        b = 1;
        #Ts;
        a = 0;
        #Ts;
        b = 0;
        #Ts2;
        end

       /* reach the max value , still enter a car*/ 
        a = 1;
        #Ts;
        b = 1;
        #Ts;
        a = 0;
        #Ts;
        b = 0;
        
        @(posedge clk);
        /* dec = 1 inc = 1 indicates that the num should not be changed*/
        dec_exp <= 1;    
        inc_exp <= 1;
        
        #Ts2;
        inc_exp = 0;
        dec_exp = 0;
        
        
        #Ts2;
    end
    endtask
    
    /* test task : simulate the car didnt finish the enter action,it pretends to enter the park,but he regrets to do that */
    /* expected that the counter hold the value*/
    /* use dec_exp = 1 && inc_exp = 1 as the signal that the count should be hold*/
    task test_enter_fail();
    begin
        /* reset the expected value*/
        inc_exp <= 0;
        dec_exp <= 0;
        #Ts2;
        test_reset();   /* reset the machine , reach the count to 0*/
        

        #Ts;
        
        a = 1;
        #Ts;
        b = 1;
        #Ts;
        a = 0;
        #Ts;
        b = 0;
        #Ts2;
       /* reach the enter sensor and then exit*/ 
        a = 1;
        #Ts;
        a = 0;
        
        @(posedge clk);
        /* dec = 1 inc = 1 indicates that the num should not be changed*/
        dec_exp <= 1;    
        inc_exp <= 1;
        
        
        #Ts2;
        inc_exp = 0;
        dec_exp = 0;
        
        
        #Ts2;
    end
    endtask
    
    /* test task : simulate the car didnt finish the enter action,it pretends to exit the park,but he regrets to do that */
    /* expected that the counter hold the value*/
    /* use dec_exp = 1 && inc_exp = 1 as the signal that the count should be hold*/
    task test_exit_fail();
    begin
        /* reset the expected value*/
        inc_exp <= 0;
        dec_exp <= 0;
        #Ts2;
        test_reset();   /* reset the machine , reach the count to 0*/
        

        
        #Ts;
        
        /* entered one car*/
        a = 1;
        #Ts;
        b = 1;
        #Ts;
        a = 0;
        #Ts;
        b = 0;
        #Ts2;
        
        
        #Ts
       /* reach the exit sensor and regret to exit*/ 
        b = 1;
        #Ts;
        b = 0;
        
        @(posedge clk);
        /* dec = 1 inc = 1 indicates that the num should not be changed*/
        dec_exp <= 1;    
        inc_exp <= 1;
        
        #Ts2;
        inc_exp = 0;
        dec_exp = 0;
        
        
        #Ts2;
    end
    endtask
    /* print in the logfile and tcl*/
    task print_log(input string log_msg);
    begin  
        log_file = $fopen("score_board_log.txt", "a");
        /* check logfile avaliable*/
        if(!log_file)begin
            $display("cannot open log file");
        end
        $fdisplay(log_file, "%s", log_msg);
        $display("%s", log_msg);
        $fclose(log_file);
    end
    endtask
    
endmodule
