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
        
        test_entrance(6);
        test_exit(6);
        test_entrance(6);
        test_exit(6);
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
        reset = 1;
        inc_exp = 0;
        dec_exp = 0;

    end
    endtask
    /* test task : reset all the system */
    task test_reset();
    begin
        #Ts;
        reset = 0;
    end
    endtask
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
        end
    end
    endtask
    
    
endmodule
