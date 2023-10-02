`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.09.2023 17:15:04
// Design Name: 
// Module Name: lab1_top_tb
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


module lab1_top_tb #(parameter stepsize = 2000)();
    
    reg sysclk;
    reg [3:0]btn;
    reg [3:0]led;
    reg inc_o;
    reg dec_o;

    lab1_top lab1_top1(
    .sysclk(sysclk),
    .btn(btn),
    .led(led),
    .inc_o(inc_o),
    .dec_o(dec_o)
    );
    
    initial begin
        btn = 4'b0000;
        sysclk = 0;
        //led = 4'b0000;
        
        #stepsize ;
        btn[3] = 1;
        #stepsize ;
        btn[3] = 0;
        
        #stepsize;
        btn[0] = 1;
        #stepsize;
        btn[1] = 1;
        #stepsize;
        btn[0] = 0;
        #stepsize;
        btn[1] = 0;
        
        #stepsize;
        btn[0] = 1;
        #stepsize;
        btn[1] = 1;
        #stepsize;
        btn[0] = 0;
        #stepsize;
        btn[1] = 0;
        
        #stepsize;
        btn[1] = 1;
        #stepsize;
        btn[0] = 1;
        #stepsize;
        btn[1] = 0;
        #stepsize;
        btn[0] = 0;
        
        #stepsize;
        btn[1] = 1;
        #stepsize;
        btn[0] = 1;
        #stepsize;
        btn[1] = 0;
        #stepsize;
        btn[0] = 0;
        
    end
    
    always #1 sysclk = ~sysclk;
endmodule
