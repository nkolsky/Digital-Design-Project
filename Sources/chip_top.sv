`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2026 09:06:01 PM
// Design Name: 
// Module Name: chip_top
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


module chip_top(
    input CLK100MHZ,
    input [15:0] SW, // we ignore [12:10] and dont latch them
    input BTNC, //center push for 1 second to set to decimal
    input CPU_RESETN, //reset display to 0
    input UART_TXD_IN,
    output [0:0] LED,
    output UART_RXD_OUT,
    output [7:0] AN, // 8 digit display anodes
    // 7 segment digits (cathodes)
    output CA,
    output CB,
    output CC,
    output CD,
    output CE,
    output CF,
    output CG,
    output DP
    );
//Internal cables from 1 sec timer
logic timer_en_config; //enable latching size config
logic timer_reg_rst; //enable reseting data and configs
logic en_read; //enable latching data

//Internal cables from data register
logic [7:0] data_latched; //data byte
logic [1:0] size_latched; //size of square
logic [1:0] speed_latched; //length of delay bt bytes
logic rx_mode; //mode of the system, either RX or TX

//Internal cables from byte counter
logic [7:0] cur_line; //current line of square of bytes
logic row_fin; //finished the current row. ready for new line
logic total_fin; //finished full byte square

//Internal cables from delay timer
logic timer_fin; //the delay time is complete

//Internal Cables from UART PHY
logic u_tx_ready; //tx ready for next byte

//Internal cables from the byte selector mux
logic [7:0] data_out; //byte to output

//Internal cables from FSM
//logic en_new_data;
logic [1:0] byte_select; //selector for byte output mux
logic u_data_ready; //we have data to send to tx serial line

//Internal cables from size converter
logic [7:0] size_converted;

//Internal cables from speed converter
logic [7:0] speed_converted;

//The following are for the 7 seg controller//
//logic [3:0] disp_data;
//logic dis_dec;

//Internal cables from three bit counter
//logic [2:0] thr_bit_sel;

//Internal cables from uart_rx
logic [7:0] rx_row;
logic [7:0] rx_col;
logic [7:0] rx_pixel;

//One second counter triggered by button push
one_sec_cntr u_one_sec_cntr (
    .clk(CLK100MHZ),
    .btn_center(BTNC),
    .rst_n(CPU_RESETN),
    .data_done(total_fin),
    .en_data(en_read),
    .en_config(timer_en_config),
    .reg_rst(timer_reg_rst)
);
    
//latching data from inputs
data_register u_data_register (
    .clk(CLK100MHZ),
    .reg_rst(timer_reg_rst),
    .en_data(en_read),
    .en_config(timer_en_config),
    .switches(SW),
    .latched_data(data_latched),
    .size_config(size_latched),
    .speed_config(speed_latched),
    .rx_mode(rx_mode)
);

//UART Top for updated UART_RTX controller
uart_rx u_uart_rx (
    .clk(CLK100MHZ),
    .rst_n(timer_reg_rst),
    .rx_in(UART_TXD_IN),
    .rx_mode(rx_mode), //always in TX mode since this is just the TX top
    .row_out(rx_row),
    .col_out(rx_col),
    .pix_out(rx_pixel)
);



//instantiate tx subsystem
tx_subsystem u_tx_subsystem (
    .clk(CLK100MHZ),
    .rst_n(CPU_RESETN),
    .rx_mode(rx_mode),
    .data_latched(data_latched),
    .size_latched(size_latched),
    .speed_latched(speed_latched),
    .line_out(cur_line),
    .led(LED),
    .tx_out(UART_RXD_OUT),
);



//converts size config to relative 8 bits for 7 seg
size_converter u_size_converter (
    .size_config(size_latched),
    .converted_size(size_converted)
);

//converts speed to relative 8 bits for 7 seg
speed_converter u_speed_converter(
    .speed_config(speed_latched),
    .converted_speed(speed_converted)
);

//The following are for the 7 seg controller
svn_seg_controller u_svn_seg_controller(
    .clk(CLK100MHZ),
    .data_in(data_out),
    .rx_mode(rx_mode),
    .tx_rows(cur_line),
    .rx_pixel(rx_pixel), //we can just use the output data as the pixel value since it holds the byte we want to display
    .rx_col(rx_col), //display size config on col digits
    .rx_row(rx_row), //display speed config on row digits
    .speed_converted(speed_converted), //display converted speed on row digits when in TX mode
    .size_converted(size_converted), //display converted size on col digits when in TX
    .anodes(AN),
    .cathodes({CA, CB, CC, CD, CE, CF, CG}),
    .dec_out(DP)
);




endmodule
