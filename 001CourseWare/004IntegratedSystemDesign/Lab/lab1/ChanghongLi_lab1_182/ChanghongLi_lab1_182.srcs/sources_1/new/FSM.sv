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
   localparam [2:0] s_waiting  = 3'b000,
                    s_entering = 3'b001,
                    s_entered  = 3'b010,
                    s_exiting  = 3'b011,
                    s_exited   = 3'b100;

    // signal declaration
    reg [2:0] state_reg, state_next;
    reg [1:0] state_AB;
    reg pulse_flag;
    
    assign state_AB = {a, b};

    /*Status transfer*/
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            state_reg <= s_waiting;
            //state_next <= s_waiting;
            //pulse_flag <= 1'b0; 
            enter <= 1'b0;
            exit <= 1'b0;
        end
        else begin
            case(state_reg)
            s_waiting    :
                case(state_AB)
                    s0:state_next = s_waiting;
                    s1:state_next = s_exiting;
                    s2:state_next = s_entering;
                    s3:state_next = s_waiting;
                    default:state_next = s_waiting;
                endcase
            s_entering  :
                case(state_AB)
                    s0:state_next = s_waiting;
                    s1:state_next = s_entered;
                    s2:state_next = s_entering;
                    s3:state_next = s_entering;
                    default:state_next = s_entering;
                endcase
            s_entered   :
                case(state_AB)
                    s0:state_next = s_waiting;
                    s1:state_next = s_entered;
                    s2:state_next = s_entering;
                    s3:state_next = s_entering;
                    default:state_next = s_entered;
               endcase
            s_exiting   :
                case(state_AB)
                    s0:state_next = s_waiting;
                    s1:state_next = s_exiting;
                    s2:state_next = s_exited;
                    s3:state_next = s_exiting;
                    default:state_next = s_exiting;
                endcase
            s_exited    :
                case(state_AB)
                    s0:state_next = s_waiting;
                    s1:state_next = s_exiting;
                    s2:state_next = s_exited;
                    s3:state_next = s_exiting;
                    default:state_next = s_exited;
                endcase
            default     :
                state_next = s_waiting;
            endcase
            
            
           // /*Pulse Generator*/
                        
            
            if((state_reg == s_entered) && (state_next == s_waiting))begin
                enter = 1'b1;
            end else begin
                enter = 1'b0;
            end
            
            if((state_reg == s_exited) && (state_next == s_waiting))begin
                exit = 1'b1;
            end else begin
                exit = 1'b0;
            end
            
            /*Status update*/
            
            state_reg = state_next;
        end
    end
    

endmodule

