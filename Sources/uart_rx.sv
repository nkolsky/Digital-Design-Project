import rx_fsm_pkg::*;

module uart_rx (
    input logic clk,
    input logic rst_n,
    input logic rx_in,
    input logic rx_mode, // TX mode when low, RX mode when high

    output logic [7:0] row_out,
    output logic [7:0] col_out,
    output logic [7:0] pix_out
);

//internal signals
logic tick;
logic [2:0] b_cnt;
logic [3:0] by_cnt;
logic [7:0] rx_byte_captured;
logic [127:0] msg_reg_128;

//control signals from the FSM
logic shift_en;
logic bit_cnt_en;
logic byte_cnt_en;
logic clr_bit_cnt;
logic msg_reg_en;
logic parse_en;

// Instantiate baud rate generator
baud_gen baud_gen_inst (
    .clk(clk),
    .rst_n(rst_n),
    .rx_mode(rx_mode),
    .tick(tick),
    
);


endmodule