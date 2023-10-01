`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/01 23:32:39
// Design Name: 
// Module Name: debouncer_tb
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


module debouncer_tb(

    );
    reg reset;
    reg clk;
    reg b;
    reg filtered_b;
    
    
    debouncer mdebouncer(
        .clk(clk), //clock signal
        .reset(reset),
        .button(b), //input button
        .button_db(filtered_b) //debounced signal to logic analyzer
    );
    
    
        initial begin
        clk = 1;
        reset = 1;

        b = 0;
        
        #1 reset = 0;
        
        #3 b = 1;
        


       
    end
    
    always #1 clk = ~clk;
    
    
    
    
endmodule
