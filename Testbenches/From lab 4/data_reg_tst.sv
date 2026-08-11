`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2026 02:55:54 PM
// Design Name: 
// Module Name: UART_PHY
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

module data_reg_tst;
    reg clk;
    reg [14:0] switches;
    reg reg_rst;
    reg en_data;
    reg en_config;
    reg [7:0] latched_data;
    reg [1:0] size_config;
    reg [1:0] speed_config;


    data_register data_register_t(
        .clk(clk),
        .switches(switches),
        .reg_rst(reg_rst),
        .en_data(en_data),
        .en_config(en_config),
        .latched_data(latched_data),
        .size_config(size_config),
        .speed_config(speed_config)
    );

    initial clk = 0;
    initial reg_rst = 0;

	always #5 clk = ~clk; //5ns on high, 5ns low total 10ns = 100MHz - equivilent to FPGA
	
    initial begin
        reg_rst = 1; en_data = 0; en_config = 0; #0;
        reg_rst = 0; en_data = 0; en_config = 0; #10;
        reg_rst = 0; en_data = 1; en_config = 1; switches = 15'h200f; #10;
        reg_rst = 0; en_data = 1; en_config = 1; switches = 15'h200f; #100;
        reg_rst = 0; en_data = 1; en_config = 0; switches = 15'h125c; #10;
        
    end


endmodule