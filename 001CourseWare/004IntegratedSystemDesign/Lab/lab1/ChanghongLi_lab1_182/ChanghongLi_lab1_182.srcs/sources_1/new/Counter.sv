`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.09.2023 12:16:31
// Design Name: 
// Module Name: Counter
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


module Counter #(parameter N = 4)(
    input clk,
    input reset,
    input inc,
    input dec,
    output reg [3:0]q 
    );
    
    reg  [N-1:0]r_cnt;
    wire [N-1:0]r_next;
    
    reg inc_p;
    reg dec_p;
    
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_cnt <= 0;
        end else
        
        if(inc && !inc_p) begin
            if(r_cnt < 4'b1111)begin
                r_cnt <= r_cnt + 1;
            end
        end else
        
        if(dec && !dec_p) begin
            if(r_cnt > 4'b0000)begin
                r_cnt <= r_cnt - 1;
            end
        end
        
        inc_p <= inc;
        dec_p <= dec;
        
        
    end
    
    assign q = r_cnt;
    
endmodule
