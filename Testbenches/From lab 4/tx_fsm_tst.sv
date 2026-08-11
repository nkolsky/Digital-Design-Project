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

//Figure out the what an actual startup would look like, see what steps would be to build the test proper.

module tx_fsm_tst;
    reg clk;
    reg rst;
    reg tx_ready;
    reg en_data;
    reg timer_done;
    reg row_end;
    reg total_end;
    reg [1:0] select_data;
    reg en_timer;
    reg data_en;

    initial clk = 0;
    initial rst = 1;

	always #5 clk = ~clk; //5ns on high, 5ns low total 10ns = 100MHz - equivilent to FPGA
	
    tx_fsm t_tx_fsm(
        .clk(clk),
        .rst(rst),
        .tx_ready(tx_ready),
        .en_data(en_data),
        .timer_done(timer_done),
        .row_end(row_end),
        .total_end(total_end),
        .select_data(select_data),
        .en_timer(en_timer),
        .data_en(data_en)   
    );

    initial begin
        rst = 0; tx_ready = 0; en_data = 0; timer_done = 0; row_end = 0; total_end = 0; #10;
        rst = 0; tx_ready = 0; en_data = 1; timer_done = 1; row_end = 0; total_end = 0; #50;
        rst = 0; tx_ready = 0; en_data = 1; timer_done = 1; row_end = 0; total_end = 0; #50;
        rst = 0; tx_ready = 1; en_data = 1; timer_done = 1; row_end = 1; total_end = 0; #50;
        rst = 0; tx_ready = 0; en_data = 1; timer_done = 1; row_end = 0; total_end = 0; #50;
        rst = 0; tx_ready = 0; en_data = 1; timer_done = 1; row_end = 1; total_end = 0; #50;
        rst = 0; tx_ready = 0; en_data = 1; timer_done = 1; row_end = 0; total_end = 0; #50;
        rst = 0; tx_ready = 0; en_data = 1; timer_done = 1; row_end = 1; total_end = 1; #50;
        rst = 0; tx_ready = 0; en_data = 1; timer_done = 1; row_end = 1; total_end = 1; #50;
        rst = 0; tx_ready = 0; en_data = 1; timer_done = 1; row_end = 0; total_end = 0; #50;
        rst = 0; tx_ready = 0; en_data = 1; timer_done = 1; row_end = 0; total_end = 0; #50;
        rst = 0; tx_ready = 0; en_data = 0; timer_done = 0; row_end = 0; total_end = 0; #10;
    end

    initial begin
        $monitor("Time: %d | Data Select: %d | Timer En: %d | Data En: %d", $time, select_data, en_timer, data_en);
    end

endmodule