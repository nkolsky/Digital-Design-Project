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
    input [14:0] SW, // we ignore [12:10] and dont latch them
    input BTNC, //center push for 1 second to set to decimal
    input CPU_RESETN, //reset display to 0
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
wire timer_en_config; //enable latching size config
wire timer_reg_rst; //enable reseting data and configs
wire en_read; //enable latching data

//Internal cables from data register
wire [7:0] data_latched; //data byte
wire [1:0] size_latched; //size of square
wire [1:0] speed_latched; //length of delay bt bytes

//Internal cables from byte counter
wire [7:0] cur_line; //current line of square of bytes
wire row_fin; //finished the current row. ready for new line
wire total_fin; //finished full byte square

//Internal cables from delay timer
wire timer_fin; //the delay time is complete

//Internal Cables from UART PHY
wire u_tx_ready; //tx ready for next byte

//Internal cables from the byte selector mux
wire [7:0] data_out; //byte to output

//Internal cables from FSM
//wire en_new_data;
wire [1:0] byte_select; //selector for byte output mux
wire u_data_ready; //we have data to send to tx serial line

//Internal cables from size converter
wire [7:0] size_converted;

//Internal cables from speed converter
wire [7:0] speed_converted;

//The following are for the 7 seg controller//
wire [3:0] disp_data;
wire dis_dec;

//Internal cables from three bit counter
wire [2:0] thr_bit_sel;

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
    .speed_config(speed_latched)
);

//counts how many bytes/rows of bytes in the square transmitted so far
//alerts when done with rows and square
byte_ctr u_byte_ctr (
    .clk(CLK100MHZ),
    .byte_done(u_tx_ready),
    .rst(timer_reg_rst),
    .size(size_latched),
    .line_out(cur_line),
    .row_done(row_fin),
    .total_done(total_fin)
);

//delay for set number of ms between bytes
delay_timer u_delay_timer (
    .clk(CLK100MHZ),
    .speed_config(speed_latched),
    .en_timer(start_timer),
    .timer_done(timer_fin)
);


//sends data to tx serial line
UART_PHY u_UART_PHY (
    .data(data_out),
    .clk(CLK100MHZ),
    .data_ready(u_data_ready),
    .en_data(en_read),
    .rst(timer_reg_rst),
    .tx_ready(u_tx_ready),
    .led(LED),
    .tx_out(UART_RXD_OUT)
);

//selects what byte to output
data_output_mux u_data_output_mux(
    .data_in(data_latched),
    .select(byte_select),
    .mux_out(data_out)
);

tx_fsm u_tx_fsm (
    .clk(CLK100MHZ),
    .rst(timer_reg_rst),
    .tx_ready(u_tx_ready),
    .en_data(en_read),
    .timer_done(timer_fin),
    .row_end(row_fin),
    .total_end(total_fin),
    .select_data(byte_select),
    .en_timer(start_timer),
    .data_en(u_data_ready)
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
    .rst_n(CPU_RESETN),
    .data_in(data_out),
    .rx_mode(1'b1), //always in RX mode because we want to display the data being sent
    .tx_rows(cur_line),
    .rx_pixel(data_out), //we can just use the output data as the pixel value since it holds the byte we want to display
    .rx_col(size_converted), //display size config on col digits
    .rx_row(speed_converted), //display speed config on row digits
    .AN(AN),
    .CA(CA),
    .CB(CB),
    .CC(CC),
    .CD(CD),
    .CE(CE),
    .CF(CF),
    .CG(CG),
    .DP(DP)
);




endmodule
