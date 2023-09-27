`timescale 1ns / 1ps

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
    always @(posedge clk, posedge reset)
        if(reset)
            state_reg <= s0;
        else
            state_reg <= state_next;
    // next state logic
    always @*
        case (state_reg)
            s0: if(a)
                    state_next = s2;
                else if(b)
                    state_next = s1;
                else
                    state_next = s0;
            s1: if(a)
                    state_next = s3;
                else if(!b)
                    state_next = s0;
                else
                    state_next = s1;
            s2: if(!a)
                    state_next = s0;
                else if(b)
                    state_next = s3;
                else
                    state_next = s2;
            s3: if(!a)
                    state_next = s1;
                else if(!b)
                    state_next = s2;
                else
                    state_next = s3;


endmodule