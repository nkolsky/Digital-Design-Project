`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2026 04:32:24 PM
// Design Name: 
// Module Name: anode_decoder
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


module anode_decoder(
    input [2:0] bit_cnt,
    output reg [7:0] an_out
    );
  
always @(*) begin
    
    case(bit_cnt) // select which 7-segment display
        3'b000: an_out <= 8'b11111110; // 1
        3'b001: an_out <= 8'b11111101; // 2
        3'b010: an_out <= 8'b11111011; // 3
        3'b011: an_out <= 8'b11110111; // 4
        3'b100: an_out <= 8'b11101111; // 5
        3'b101: an_out <= 8'b11011111; // 6
        3'b110: an_out <= 8'b10111111; // 7
        3'b111: an_out <= 8'b01111111; // 8
        
        default: an_out <= 8'b11111111; //default to off
    endcase
end
endmodule
