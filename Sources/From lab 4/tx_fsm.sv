`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2026 07:09:29 PM
// Design Name: 
// Module Name: tx_fsm
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


module tx_fsm(
    input clk, rst,
    input tx_ready,
    input en_data,
    input timer_done,
    input row_end,
    input total_end,
    output reg [1:0] select_data,
    output logic en_timer,
    output logic data_en
    );
    
typedef enum logic [3:0] {
    idle = 4'd1, 
    send_data = 4'd2, 
    wait_data = 4'd3,
    send_new_line = 4'd4, 
    wait_new_line = 4'd5, 
    send_line_start = 4'd6,
    wait_line_start = 4'd7, 
    wait_new_byte = 4'd8, 
    send_space = 4'd9,
    wait_space = 4'd10
} state_t;

    initial begin
        select_data = 2'b00;
        en_timer    = 1'b0;
        data_en     = 1'b0;
    end
      
    state_t cur_state, next_state;
    
    //state reg sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) cur_state <= idle;
        else cur_state <= next_state;
    end

    //next state combinational logic
    always_comb begin
        //default to prevent latching
        next_state = cur_state;

        case(cur_state)
            idle: if(en_data)begin
                next_state = send_data;
            end 
            send_data: begin
                next_state = wait_data; 
            end
            wait_data: 
                if(tx_ready && row_end)begin
                    next_state = send_new_line;
                end else if(tx_ready && !row_end)begin
                    next_state = send_space;
            end 
            send_new_line: begin
                next_state = wait_new_line;
            end
            wait_new_line: if(tx_ready)begin
                next_state = send_line_start;
            end
            send_line_start: begin
                next_state = wait_line_start;
            end
            wait_line_start: if(tx_ready && !total_end)begin
                next_state = wait_new_byte;
            end else if(tx_ready && total_end)begin
                next_state = idle;
            end
            wait_new_byte: if(timer_done)begin
                next_state = send_data;
            end
            send_space: begin
                next_state = wait_space;
            end 
            wait_space: if(tx_ready)begin
                next_state = wait_new_byte;
            end  
            default: next_state = idle;   
        endcase
    end

    //output logic
    always_comb begin
        // Set default values for all outputs to avoid latches
        select_data = 2'b00;
        data_en = 1'b0;
        //en_timer = 1'b0; 
               
       case(cur_state)
            idle: if(en_data)begin
                select_data = 2'b00;
                data_en = 1'b1;
            end else begin
                data_en = 1'b0;
            end 
            send_data: begin 
                en_timer = 1'b0; //turn off the delay timer being able to run
                data_en = 1'b0;
            end
            wait_data: if(tx_ready && row_end)begin
                select_data = 2'b11;
                data_en = 1'b1;
            end else if(tx_ready && !row_end)begin
                select_data = 2'b01;
                data_en = 1'b1;
            end 
            send_new_line: begin
                data_en = 1'b0;
            end
            wait_new_line: if(tx_ready)begin
                select_data = 2'b10;
                data_en = 1'b1;
            end
            send_line_start: begin
                data_en = 1'b0;
            end
            wait_line_start: if(tx_ready && !total_end)begin
                en_timer = 1'b1; //turn on the delay timer
                data_en = 1'b1;
            end
            wait_new_byte: if(timer_done)begin
                data_en = 1'b0; //safety, so that we can turn data_en high b/c we are looking for posedge elsewhere
            end
            send_space: begin
                data_en = 1'b0;
            end 
            wait_space: if(tx_ready)begin
                en_timer = 1'b1; //turn on the delay timer
                data_en = 1'b1;
            end
            default: begin
               select_data = 2'b00;
               data_en = 1'b0;
               en_timer = 1'b0; 
            end
       endcase    
    end
    
endmodule
