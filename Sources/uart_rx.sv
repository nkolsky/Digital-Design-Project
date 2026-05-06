import rx_fsm_pkg::*;

module uart_rx (
    input logic clk,
    input logic rst_n,
    input logic rx_in, 
    input logic rx_mode, // TX mode when low, RX mode when high

    output logic [7:0] row_out,
    output logic [7:0] col_out,
    output logic [7:0] pix_out,
    output logic led
);

//internal signals
logic tick;
logic [2:0] bit_cnt;
logic [3:0] byte_cnt;
logic [7:0] rx_byte_captured;
logic [127:0] msg_reg_128;
logic baud_run;

//control signals from the FSM
logic shift_en;
logic bit_cnt_en;
logic byte_cnt_en;
logic clr_bit_cnt;
logic msg_reg_en;
logic parse_en;

//internal logic for the LED
logic led;

assign led = rx_mode ? !byte_cnt[0] : 1'b0;

// Instantiate baud rate generator
baud_gen baud_gen_inst (
    .clk(clk),
    .rst_n(rst_n),
    .rx_mode(rx_mode),
    .baud_start(baud_run),
    .tick(tick)
);

// Instantiate FSM
rx_fsm rx_fsm_inst (
    .clk(clk),
    .rst_n(rst_n),
    .tick(tick),
    .rx_in(rx_in),
    .bit_cnt(bit_cnt),
    .byte_cnt(byte_cnt),
    .rx_mode(rx_mode),
    .clr_bit_cnt(clr_bit_cnt),
    .baud_start(baud_run),
    .shift_en(shift_en),
    .bit_cnt_en(bit_cnt_en),
    .byte_cnt_en(byte_cnt_en),
    .msg_reg_en(msg_reg_en),
    .parse_en(parse_en)
);

// Instantiate bit counter and byte counter
rx_bit_cntr bit_cntr_inst (
    .clk(clk),
    .rst_n(rst_n),
    .bit_cnt_en(bit_cnt_en),
    .byte_cnt_en(byte_cnt_en),
    .clr_bit_cnt(clr_bit_cnt),
    .bit_cnt(bit_cnt),
    .byte_cnt(byte_cnt)
);

// Instantiate shift register for capturing incoming bits into bytes
rx_byte_shift_reg byte_shift_reg_inst (
    .clk(clk),
    .rst_n(rst_n),
    .shift_en(shift_en),
    .rx_in(rx_in),
    .byte_out(rx_byte_captured)
);

// Instantiate message register for storing the full 16-byte message
rx_msg_reg msg_reg_inst (
    .clk(clk),
    .rst_n(rst_n),
    .msg_reg_en(msg_reg_en),
    .byte_in(rx_byte_captured),
    .byte_cnt(byte_cnt),
    .msg_out(msg_reg_128)
);

// Instantiate parser for extracting row, column, and pixel values from the message
rx_parser parser_inst (
    .clk(clk),
    .rst_n(rst_n),
    .msg_in(msg_reg_128),
    .parse_en(parse_en),
    .pixel_val(pix_out),
    .colIdx(col_out),
    .rowIdx(row_out)
);


endmodule