`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2026 09:53:15 PM
// Design Name: 
// Module Name: svn_seg_decoder
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


module svn_seg_decoder( //break this out into a data selection mux (new module)
    input logic [4:0] disp_val, //holds a value to display
    input logic dec_in,
    //input logic [2:0] bit_cnt,
    output logic [6:0] seg_out,
    output logic dec_out
    );

   

always @(*) begin
    dec_out <= dec_in;
    
    case(disp_val)
        5'b00000: seg_out <= 7'b0000001; // 0
        5'b00001: seg_out <= 7'b1001111; // 1
        5'b00010: seg_out <= 7'b0010010; // 2
        5'b00011: seg_out <= 7'b0000110; // 3
        5'b00100: seg_out <= 7'b1001100; // 4
        5'b00101: seg_out <= 7'b0100100; // 5
        5'b00110: seg_out <= 7'b0100000; // 6
        5'b00111: seg_out <= 7'b0001111; // 7
        5'b01000: seg_out <= 7'b0000000; // 8
        5'b01001: seg_out <= 7'b0000100; // 9
        5'b01010: seg_out <= 7'b0001000; // A
        5'b01011: seg_out <= 7'b1100000; // B
        5'b01100: seg_out <= 7'b0110001; // C
        5'b01101: seg_out <= 7'b0100001;  // D
        5'b01110: seg_out <= 7'b0110000; // E
        5'b01111: seg_out <= 7'b0111000; // F
        5'b10000: seg_out <= 7'b1111110; //  '-' for rx mode t1
        default: seg_out <= 7'b1111111; // default to off

    endcase
        
end
endmodule
