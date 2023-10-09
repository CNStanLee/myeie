`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.10.2023 17:11:07
// Design Name: 
// Module Name: lab2_top_tb
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


module lab2_top_tb(
    );
    /* Debug Variables */
    integer log_file;
    
    
    /* variables of stim_gen */
    reg clk, reset      ;
    reg a, b            ;
    reg inc_exp, dec_exp ;
    
    /* variables of score board */
    reg [3:0]count;
    
    /* variables of DUT */

    reg [3:0]btn;
    reg [3:0]led;
    reg filtered_a_o;
    reg filtered_b_o;

    
    /* map the var to the dut */
    assign btn[0] = a;
    assign btn[1] = b;
    assign btn[2] = reset;
    assign btn[3] = reset;
    
    assign count = led;
    
    stim_gen m_stim_gen(
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .inc_exp(inc_exp),
        .dec_exp(dec_exp)
    );
    
    scoreboard m_scoreboard(
    .inc_exp(inc_exp),
    .dec_exp(dec_exp),
    .clk(clk), 
    .reset(reset),
    .count(count)
    );
       
    lab1_top DUT(
    .sysclk(clk),
    .btn(btn),
    .led(led),
    .filtered_a_o(filtered_a_o),
    .filtered_b_o(filtered_b_o)
    );
    
    initial
    begin
        test_file_operation();
    end
    
    
    task test_file_operation;
    begin
        $display("this is a display test"); // a means add up but not re-write
        log_file = $fopen("my_log.txt", "a");
        if(log_file == 0)
            $display("Fail to open log file");
        $fseek(log_file, 0, 2);
        $fdisplay(log_file, "hello world 9");
        $fdisplay(log_file, "hello world 10");
        $fclose(log_file);
    end
    endtask
    
endmodule
