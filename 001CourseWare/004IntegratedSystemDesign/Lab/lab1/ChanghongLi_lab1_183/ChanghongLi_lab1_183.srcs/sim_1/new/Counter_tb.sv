`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.09.2023 13:36:49
// Design Name: 
// Module Name: Counter_tb
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


module Counter_tb();
reg clk;
reg reset;
reg inc;
reg dec;
reg [3:0]q;
Counter cnt(
    .clk(clk),
    .reset(reset),
    .inc(inc),
    .dec(dec),
    .q(q) 
    );
    initial begin
        clk = 1;
        reset = 1;
        inc = 0;
        dec = 0;
        //q = 3'b000;
        #1 reset = 0;     
        #10 inc = 1;
        #5  inc = 0;
        #10 inc = 1;
        #5  inc = 0;
        #10 inc = 1;
        #5  inc = 0;
        #10 dec = 1;
        #5  dec = 0;
        
    end
    
    always #1 clk = ~clk;
endmodule
