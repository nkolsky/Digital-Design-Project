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


module byte_ctr_tst;
    reg clk;
    reg byte_done; //signal from FSM that we have sent a byte and can move to the next one,
    reg rst; //reset signal from 1 sec timer to reset the byte counter and line counter
    reg [1:0] size;
    reg [7:0] line_out;
    reg row_done;
    reg total_done;
    
    byte_ctr byte_ctr_t(
        .clk(clk),
        .byte_done(byte_done),
        .rst(rst),
        .size(size),
        .line_out(line_out),
        .row_done(row_done),
        .total_done(total_done)
    );

    initial clk = 0;
    initial rst = 0;

	always #5 clk = ~clk; //5ns on high, 5ns low total 10ns = 100MHz - equivilent to FPGA
	
    initial begin
        rst = 1; byte_done = 0; #10;
        rst = 0; #15;
        size = 2'b10; #10;
        byte_done = 1; #100;
        byte_done = 0; #10;
        byte_done = 1; #100;
        byte_done = 0; #10;
        byte_done = 1; #100;
        byte_done = 0; #10;
        byte_done = 1; #100;
        byte_done = 0; #10;
        
    end

endmodule