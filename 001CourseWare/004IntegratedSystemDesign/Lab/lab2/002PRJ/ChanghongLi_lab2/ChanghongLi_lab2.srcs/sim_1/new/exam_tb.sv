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
    reg signed [2:0] a;
    reg        [2:0] b;
    reg signed [3:0] c;
    reg signed [5:0] d1, d2, d3;

    reg [31:0] count;
    reg [0:0] div2;
    reg [0:0] div8;
    
    always
    begin
            clk = 1'b1;
            #1;
            clk = 1'b0;
            #1;
    end
    
    initial
    begin
        assign a = 3'd3; 
        assign b = 3'd4;
        assign c = -4'sd1;
        
        d1 = a + c;
        d2 = $signed(b) + c[0];
        d3 = $signed(b) * a;
        

        //toggle_div2(10);
        test_div8(2);
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
      
      task test_div8(input [31:0] N);
        reg [31:0] cnt1;
        reg [31:0] cnt2;
        begin
            div8 = 0;
            for(cnt1 = 0;cnt1 < N;cnt1++)begin
                for(cnt2 = 0;cnt2 < 4'd8;cnt2++)begin
                    if(cnt2 >= 4'd7)begin
                        div8 = 1;
                    end
                    else begin
                        div8 = 0;
                    end
                     @(posedge clk);
                end
              div8 = 0;
            end
        end
      endtask
    
    
endmodule
