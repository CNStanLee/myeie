`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.10.2023 17:16:46
// Design Name: 
// Module Name: scoreboard
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


module scoreboard(
    input inc_exp, dec_exp,
    input clk, reset,
    input [3:0]count
    );
    
    integer log_file, console_file, out_file;
    reg [3:0]expected_num;
    reg [3:0]score;
    reg inc_exp_p;
    reg dec_exp_p;
    reg hold_exp_p;
    reg [3:0]count_p;
    reg pass;
    
    reg [1:0]IncDec;
    reg [1:0]IncDec_p;
    
    reg [2:0]flag_idh;  //expected increase decrease hold
    reg [2:0]result_idh;
    
    reg [3:0]begin_cnt_val;//when the test begin, record the original cnt val
    

    
//    Counter cnt(
//        .clk(clk),
//        .reset(reset),
//        .inc(inc_exp),
//        .dec(dec_exp),
//        .q(expected_num) 
//    );
    
    
    always @(posedge clk, posedge reset)
    begin
        if(reset)begin
            /* system has been reset, clear the score cnt */
            score = 4'b0000;
            pass = 0;

            flag_idh = 3'b000;
            result_idh = 3'b000;
            begin_cnt_val = 3'b000;
            
        end else begin
            /* system is running now*/
            
            IncDec = {inc_exp, dec_exp};
            IncDec_p = {inc_exp_p, dec_exp_p};
                  
            if((IncDec_p == 2'b00) && (IncDec != 2'b00))begin
                /* begin one test ; Inc OR Dec is changed and exist not-zero value, it means there must be a test has begun*/
              
                case(IncDec)
                    2'b11:begin
                        flag_idh = 3'b001;  // the value of cnt should be hold
                    end
                    2'b10:begin
                        flag_idh = 3'b100;  // the value of cnt should be increase;
                    end
                    2'b01:begin
                        flag_idh = 3'b010;  // the value of cnt should be decrease.
                    end
                    default:begin
                        flag_idh = 3'b001;  // should be hold
                    end
                endcase
                begin_cnt_val = count;  //record current cnt val into the begin cnt val
            end else if((IncDec_p != 2'b00) && (IncDec == 2'b00)) begin
                /* end of one test; we need to check the result at the end of the test */
                result_idh[0] = (count == begin_cnt_val)?1'b1:1'b0;
                result_idh[1] = (begin_cnt_val - count == 1)?1'b1:1'b0;
                result_idh[2] = (count - begin_cnt_val == 1)?1'b1:1'b0;
                pass = (flag_idh == result_idh)?1'b1:1'b0; 
                record_result();
                /* end the of test clear the recorded status*/
                flag_idh = 3'b000;
                result_idh = 3'b000;
                begin_cnt_val = 3'b000;
            end
        end      
        /* storage last status */
        inc_exp_p = inc_exp;
        dec_exp_p = dec_exp;
        count_p = count;
        pass = 0;   //reset the pass val to default val 0
    end
    
    

    /* the score board begin to record*/
    task record_result();
    begin  
        log_file = $fopen("score_board_log.txt", "a");
        /* check logfile avaliable*/
        if(!log_file)begin
            $display("cannot open log file");
        end
        $fdisplay(log_file, "%d              %d              %d              %d           %d           %d           %d",
            flag_idh[2], flag_idh[1], flag_idh[0],
            result_idh[2], result_idh[1], result_idh[0], pass);
        $display("%d              %d              %d              %d           %d           %d           %d",
            flag_idh[2], flag_idh[1], flag_idh[0],
            result_idh[2], result_idh[1], result_idh[0], pass);
        $fclose(log_file);
    end
    endtask

endmodule
