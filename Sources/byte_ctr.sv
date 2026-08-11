`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2026 05:35:37 PM
// Design Name: 
// Module Name: byte_ctr
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

//total_done is broken I think, probably rework trigger for count as well.

module byte_ctr(
    input logic clk,
    input logic byte_done, //signal from FSM that we have sent a byte and can move to the next one,
    input logic rst_n, //reset signal from 1 sec timer to reset the byte counter and line counter
    input logic [1:0] size,
    output logic [7:0] line_out,
    output logic row_done,
    output logic total_done
    );
    
    logic [7:0] row_cnt; // counts how many 8 bit lines we have gotten, need max 5 bit for 32 (32*8 = 256)
    logic [7:0] clmn_cnt; //counts columns, need to count up to 256
    logic trigger = 1;
    initial total_done <= 0;


always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        line_out <= 8'd0;
        row_cnt <= 8'd0; //init reset counters
        clmn_cnt <= 8'd0; //init reset counters  
        row_done <= 1'b0;
        total_done <= 1'b0;
        trigger <= 1;
    end
    else if (byte_done && !total_done && !trigger) begin 
        trigger <= 1;
        case(size)
            2'b00: //1 line
            begin //imediately send that we are done
                row_done <= 1'b1; //tell fsm to send special row char
                total_done <= 1'b1; //tell fsm to send special end char
                line_out <= line_out + 1; //increment the line count
            end
            2'b01: //32 x 32
                if (clmn_cnt == 8'd31) begin //8 * 4 is 32, so on the fourth go through the row is done (do (4*2)-1 to account for spaces)
                    clmn_cnt <= 8'b0; //reset the depth into the row
                    row_done <= 1'b1; //tell fsm to send special row char
                    line_out <= line_out + 1; //increment the line count
                    
                    //the if nests inside the line being done to check if we have sent enough columns
                    if (row_cnt == 8'd31) begin //after 32 rows we are done
                        row_cnt <= 8'b0; //reset the count
                        total_done <= 1'b1; //send that we are done
                    end else begin 
                        row_cnt <= row_cnt + 1; //otherwise we have finished another row
                    end 
                end else begin //if we didn't finish the row
                    clmn_cnt <= clmn_cnt + 1; //we are one byte deeper into the row
                    row_done <= 1'b0; //make sure that we aren't sending row done
                end
            2'b10: //128 x 128
                if (clmn_cnt == 8'd127) begin //8 * 16 is 128, see above (do (16*2)-1 to account for spaces)
                    clmn_cnt <= 8'b0; //reset
                    row_done <= 1'b1; //tell fsm to send special row char
                    line_out <= line_out + 1; //increment line count

                    //the if nests inside the line being done to check if we have sent enough columns
                    if (row_cnt == 8'd127) begin //after 128 rows we are done
                        row_cnt <= 8'b0; //reset the count
                        total_done <= 1'b1; //send that we are done
                    end else begin //otherwise we have finished another row, same logic as above
                        row_cnt <= row_cnt + 1;
                    end 
                end else begin
                    clmn_cnt <= clmn_cnt + 1;
                    row_done <= 1'b0;
                end
            2'b11: //256 * 256
                if (clmn_cnt == 8'd255) begin //8 * 32 is 256, see above (do (32*2)-1 to account for spaces)
                    clmn_cnt <= 8'd0; //reset
                    row_done <= 1'b1; //tell fsm to send special row char
                    line_out <= line_out + 1; //increment line count

                    //the if nests inside the line being done to check if we have sent enough columns
                    if (row_cnt == 8'd255) begin //after 256 rows we are done
                        row_cnt <= 8'd0; //reset the count
                        total_done <= 1'b1; //send that we are done
                    end else begin //otherwise we have finished another row, same logic as above
                        row_cnt <= row_cnt + 1;
                    end 
                end else begin
                    clmn_cnt <= clmn_cnt + 1;
                    row_done <= 1'b0;
                end
            default: begin
                line_out <= 0;
                row_cnt <= 8'd0; //init/reset counters
                clmn_cnt <= 8'd0; //init/reset counters 
                row_done <= 1'b0;
                total_done <= 1'b0;     
            end  
        endcase                                       
    end 
    else if (!byte_done) begin
        trigger <= 0;
    end
end  

endmodule
