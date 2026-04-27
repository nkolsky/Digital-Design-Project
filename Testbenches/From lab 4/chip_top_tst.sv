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


module chip_top_tst;
    reg clk;
    reg rst;
    reg [14:0] switches;
    reg BTNC;
    reg [0:0] LED;
    reg UART_RXD_OUT;
    reg [7:0] AN; // 8 digit display anode;
    // 7 segment digits (cathodes)
    reg CA;
    reg CB;
    reg CC;
    reg CD;
    reg CE;
    reg CF;
    reg CG;
    reg DP;

    initial clk = 0;
    initial rst = 0; 

	always #5 clk = ~clk; //5ns on high, 5ns low total 10ns = 100MHz - equivilent to FPGA
	

chip_top chip_top_t(
    .CLK100MHZ(clk),
    .SW(switches), // we ignore [12:10] and dont latch them
    .BTNC(BTNC), //center push for 1 second to set to decimal
    .CPU_RESETN(rst), //reset display to 0
    .LED(LED),
    .UART_RXD_OUT(UART_RXD_OUT),
    .AN(AN), // 8 digit display anodes
    // 7 segment digits (cathodes)
    .CA(CA),
    .CB(CB),
    .CC(CC),
    .CD(CD),
    .CE(CE),
    .CF(CF),
    .CG(CG),
    .DP(DP)
    );

    initial begin
        rst = 0; #10;
        rst = 1; #10;
        switches = 15'h200f; BTNC = 1; #110000000;
        switches = 15'h200f; BTNC = 0; #1100000000;
    end

    initial begin
        $monitor("Time: %d", $time);
    end

endmodule
