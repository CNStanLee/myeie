`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/30 13:03:56
// Design Name: 
// Module Name: exam_tb
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


module exam_tb(
    );
    reg clk; 
    reg [2:0] a;
    reg signed [2:0] b;
    reg signed [1:0] c;
    reg signed [3:0] d1, d2, d3;

    reg [31:0] count;
    reg [0:0] div2;
    
    always
    begin
            clk = 1'b1;
            #1;
            clk = 1'b0;
            #1;
    end
    
    initial
    begin
        assign a = 3'd2; 
        assign b = 3'd2;
        assign c = -2'd1;
        
        d1 = a + c;
        d2 = b[1:0] + c;
        d3 = $signed(a) + b;
        

        toggle_div2(10);
    end

    
      // Task to toggle div2 signal for N clock cycles
      task toggle_div2(input [31:0] N);
        reg [31:0] cnt;
        begin
          div2 = 0; // Initialize div2 to 0
          cnt  = 0;
          for(cnt = 0; cnt < N; cnt++)begin
             @(posedge clk);
             div2 = ~div2;
          end
        end
      endtask
    
    
endmodule
