import rx_fsm_pkg::*;

module rx_fsm (
    input logic clk,
    input logic rst_n,
    input logic [3:0] tick, //16x baud rate tick
    input logic rx_in, //serial data input
    input logic [2:0] bit_cnt, //bit count for current byte being received
    input logic [3:0] byte_cnt, //how many bytes read out of the 16 bytes in the message
    input logic sw15, //default to IDLE when low (in TX mode on low, RX mode on high)

)endmodule : rx_fsm