`timescale 1ns / 1ps
import tx_fsm_pkg::*;

module tx_fsm(
    input clk, 
    input rst_n,
    input tx_ready,
    input en_data,
    input timer_done,
    input row_end,
    input total_end,
    input rx_mode,
    output reg [1:0] select_data,
    output logic en_timer,
    output logic data_en
    );


    initial begin
        select_data = 2'b00;
        en_timer    = 1'b0;
        data_en     = 1'b0;
    end
      
tx_state_t cur_state, next_state;
    
    //state reg sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || rx_mode) cur_state <= IDLE;
        else cur_state <= next_state;
    end

    //next state combinational logic
    always_comb begin
        //default to prevent latching
        next_state = cur_state;

        case(cur_state)
            IDLE: if(en_data)begin
                next_state = SEND_DATA;
            end 
            SEND_DATA: begin
                next_state = WAIT_DATA; 
            end
            WAIT_DATA: 
                if(tx_ready && row_end)begin
                    next_state = SEND_NEW_LINE;
                end else if(tx_ready && !row_end)begin
                    next_state = SEND_SPACE;
            end 
            SEND_NEW_LINE: begin
                next_state = WAIT_NEW_LINE;
            end
            WAIT_NEW_LINE: if(tx_ready)begin
                next_state = SEND_LINE_START;
            end
            SEND_LINE_START: begin
                next_state = WAIT_LINE_START;
            end
            WAIT_LINE_START: if(tx_ready && !total_end)begin
                next_state = WAIT_NEW_BYTE;
            end else if(tx_ready && total_end)begin
                next_state = IDLE;
            end
            WAIT_NEW_BYTE: if(timer_done)begin
                next_state = SEND_DATA;
            end
            SEND_SPACE: begin
                next_state = WAIT_SPACE;
            end 
            WAIT_SPACE: if(tx_ready)begin
                next_state = WAIT_NEW_BYTE;
            end  
            default: next_state = IDLE;   
        endcase
    end

    //output logic
    always_comb begin
        // Set default values for all outputs to avoid latches
        select_data = 2'b00;
        data_en = 1'b0;
        //en_timer = 1'b0; 
               
       unique case(cur_state)
            IDLE: if(en_data)begin
                select_data = 2'b00;
                data_en = 1'b1;
            end else begin
                data_en = 1'b0;
            end 
            SEND_DATA: begin 
                en_timer = 1'b0; //turn off the delay timer being able to run
                data_en = 1'b0;
            end
            WAIT_DATA: if(tx_ready && row_end)begin
                select_data = 2'b11;
                data_en = 1'b1;
            end else if(tx_ready && !row_end)begin
                select_data = 2'b01;
                data_en = 1'b1;
            end 
            SEND_NEW_LINE: begin
                data_en = 1'b0;
            end
            WAIT_NEW_LINE: if(tx_ready)begin
                select_data = 2'b10;
                data_en = 1'b1;
            end
            SEND_LINE_START: begin
                data_en = 1'b0;
            end
            WAIT_LINE_START: if(tx_ready && !total_end)begin
                en_timer = 1'b1; //turn on the delay timer
                data_en = 1'b1;
            end
            WAIT_NEW_BYTE: if(timer_done)begin
                data_en = 1'b0; //safety, so that we can turn data_en high b/c we are looking for posedge elsewhere
            end
            SEND_SPACE: begin
                data_en = 1'b0;
            end 
            WAIT_SPACE: if(tx_ready)begin
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
