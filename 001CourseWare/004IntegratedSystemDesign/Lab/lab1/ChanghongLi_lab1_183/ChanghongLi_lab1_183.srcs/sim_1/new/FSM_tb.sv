`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.09.2023 15:18:15
// Design Name: 
// Module Name: FSM_tb
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


module FSM_tb();


    reg clk;
    reg reset;
    reg a;
    reg b;
    reg enter;
    reg exit;

    FSM fsm(
       .clk(clk),
       .reset(reset),
       .a(a),   
       .b(b),
       .enter(enter),
       .exit(exit)
    );
    
    initial begin
        clk = 1;
        reset = 1;
        a = 0;
        b = 0;
        
        #1 reset = 0;
        
        #2 a = 1;
        #2 b = 1;
        #2 a = 0;
        #2 b = 0;
        
        #2 a = 1;
        #2 b = 1;
        #2 a = 0;
        #2 b = 0;
        
        #2 b = 1;
        #2 a = 1;
        #2 b = 0;
        #2 a = 0;

       
    end
    
    always #1 clk = ~clk;
    
    
endmodule
