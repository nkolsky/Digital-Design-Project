import rx_fsm_pkg::*;

module uart_rx (
    input logic clk,
    input logic rst_n,
    input logic tick_16x,
    input logic rx_in, //physical pin for receiving data
    input logic rx_mode, //default to IDLE when low (in TX mode on low, RX mode on high)
    output logic [127:0] rx_data, //received data byte
    output logic parse_en_out //pulse when a byte is received and processed
);

// Signals driven by FSM
    logic clr_tick, run_tick, shift_en, bit_cnt_en, byte_cnt_en, msg_reg_en;
    
    // Counters requested by FSM
    logic [3:0] tick_q;
    logic [2:0] bit_cnt_q;
    logic [3:0] byte_cnt_q;
    logic [7:0] shift_reg_q;

// Instantiate FSM
rx_fsm rx_fsm_inst (
    .clk(clk),
    .rst_n(rst_n),
    .tick(tick_q),
    .rx_in(rx_in),
    .bit_cnt(bit_cnt_q),
    .byte_cnt(byte_cnt_q),
    .rx_mode(rx_mode),
    .timer_done(timer_done),
    .clr_tick_cntr(clr_tick),
    .run_tick_cntr(run_tick),
    .shift_en(shift_en), 
    .bit_cnt_en(bit_cnt_en),
    .byte_cnt_en(byte_cnt_en),
    .msg_reg_en(msg_reg_en),
    .parse_en(parse_en_out)
);

endmodule