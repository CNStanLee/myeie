`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.12.2023 13:09:22
// Design Name: 
// Module Name: div8
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


module div8(

    );
    
    reg sysclk;
    reg divn;
    initial begin
    
      sysclk = 1'b0;
      divn = 1'b0;
      div8(3);
    end
    
    always
    begin
        sysclk = ~sysclk;
        #1;
    end
    
    task div8(input [31:0]N);
        reg[31:0] cnt;
        reg[31:0] in_cnt;
        begin
            divn = 0;
            cnt  = 0;
            for(cnt = 0; cnt < N; cnt ++)begin
                for(in_cnt =0; in_cnt < 8;in_cnt ++)begin
                    @(posedge sysclk);  
                    if(in_cnt == 4'd7)begin
                        divn = 1;
                    end else begin
                        divn = 0;
                    end
                end
                
            end
            @(posedge sysclk);
            divn = 0;
        end
    endtask
     
endmodule
