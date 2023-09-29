`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.09.2023 11:40:31
// Design Name: 
// Module Name: FSM
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.09.2023 11:38:18
// Design Name: 
// Module Name: FSM1
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


module FSM
  (input    wire clk,
   input    wire reset,
   input    wire a,
   input    wire b,
   output   reg enter,
   output   reg exit
);
    // symbolic state declaration
    localparam [1:0] s0 = 2'b00,
                     s1 = 2'b01,
                     s2 = 2'b10,
                     s3 = 2'b11;
    // signal declaration
    reg [1:0] state_reg, state_next;
    
    // state register
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            state_reg <= s0;

        end
        else begin
            state_reg <= state_next;
        end
    end
    
    // next state logic
    always @* begin
        case (state_reg)
            s0: if(a) begin
                    state_next = s2;
                end
                else if(b) begin
                    state_next = s1;
                end
                else begin
                    state_next = s0;
                end
            s1: if(a) begin
                    state_next = s3;
                end
                else if(!b) begin
                    state_next = s0;
                end
                else begin
                    state_next = s1;
                end
            s2: if(!a) begin
                    state_next = s0;
                end
                else if(b) begin
                    state_next = s3;
                end
                else begin
                    state_next = s2;
                end
            s3: if(!a) begin
                    state_next = s1;
                end
                else if(!b) begin
                    state_next = s2;
                end
                else begin
                    state_next = s3;
                end
        endcase
    end
    
    
    assign enter = (state_reg == s1) & (!b);
    assign exit = (state_reg == s2) & (!a); 
    //state_reg state_next
    

endmodule

