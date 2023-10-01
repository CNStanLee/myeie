`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.09.2023 16:30:12
// Design Name: 
// Module Name: lab1_top
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


module lab1_top(
    /* system */
    input sysclk,
    input [3:0]btn,
    output   reg [3:0]led
    );
    
    reg [2:0] status_o;
    reg [2:0] next_status_o;
    
    
    /* sys */
    wire reset;
    wire clk;
    assign reset = btn[3];
    assign clk = sysclk;
    
    /* fsm */
    wire a;
    wire b;

    assign a = btn[0];
    assign b = btn[1];

    
    wire enter;
    wire exit;
    
    /* debouncer */

    wire filtered_a;
    wire filtered_b;
    
    /* counter */
    reg [3:0]q;
    assign led = q;
    
    
    debouncer mdebouncer1(
        .clk(clk), //clock signal
        .reset(reset),
        .button(a), //input button
        .button_db(filtered_a) //debounced signal to logic analyzer
    );
    
    debouncer mdebouncer2(
        .clk(clk), //clock signal
        .reset(reset),
        .button(b), //input button
        .button_db(filtered_b) //debounced signal to logic analyzer
    );
    
    FSM mfsm(
       .clk(clk),
       .reset(reset),
       .a(filtered_a),   
       .b(filtered_b),
       .enter(enter),
       .exit(exit)
    );
    

    
    Counter mcounter(
        .clk(clk),
        .reset(reset),
        .inc(enter),
        .dec(exit),
        .q(q) 
    );
    

    
    
    
endmodule
