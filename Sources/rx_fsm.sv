import rx_fsm_pkg::*;

module rx_fsm (
    input logic clk,
    input logic rst_n,
    input logic [3:0] tick, //16x baud rate tick
    input logic rx_in, //serial data input
    input logic [2:0] bit_cnt, //bit count for current byte being received
    input logic [3:0] byte_cnt, //how many bytes read out of the 16 bytes in the message
    input logic sw15, //default to IDLE when low (in TX mode on low, RX mode on high)

    //moore outputs
    output logic clr_tick_cntr,
    output logic run_tick_cntr,
    output logic shift_en, 
    output logic bit_cnt_en,
    output logic byte_cnt_en,
    output logic msg_reg_en,
    output logic parse_en
);    

//Define internal signals
rx_state_t cur_state, next_state;

// State Transitions Logic (Sequential)
always_ff @(posedge clk or negedge rst_n) begin
    if(rst_n) begin
        cur_state <= IDLE;
    else
        cur_state <= next_state;
    end
end


endmodule : rx_fsm