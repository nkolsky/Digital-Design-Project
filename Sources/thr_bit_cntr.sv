`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2026 04:32:24 PM
// Design Name: 
// Module Name: 3_bit_cntr
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


module thr_bit_cntr(
    input clk,
    output logic [2:0] cnt_out
    );

	initial cnt_out = 3'b000; //set the counter to 0
    
	logic [16:0] divisor = 2000000; // (1e9/5e2) --gives amount to divide clock by--
	
	logic [16:0] count = 0;
	
	always @(posedge clk) begin  //bring clock down to 500hz

		if (count == divisor - 1) begin 
			count <= 0;
			cnt_out <= cnt_out + 1; //should autowrap
		end else begin //count to 2000000
			count <= count + 1;
		end
    

	end    

endmodule
