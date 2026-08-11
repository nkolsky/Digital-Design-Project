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
    input logic [3:0] disp_val, //holds a value to display
    input logic dec_in,
    //input logic [2:0] bit_cnt,
    output logic [6:0] seg_out,
    output logic dec_out
    );

   

always_comb begin 
    
    dec_out = dec_in;
    
    unique case(disp_val)
        4'b0000: seg_out = 7'b0000001; // 0
        4'b0001: seg_out = 7'b1001111; // 1
        4'b0010: seg_out = 7'b0010010; // 2
        4'b0011: seg_out = 7'b0000110; // 3
        4'b0100: seg_out = 7'b1001100; // 4
        4'b0101: seg_out = 7'b0100100; // 5
        4'b0110: seg_out = 7'b0100000; // 6
        4'b0111: seg_out = 7'b0001111; // 7
        4'b1000: seg_out = 7'b0000000; // 8
        4'b1001: seg_out = 7'b0000100; // 9
        4'b1010: seg_out = 7'b0001000; // A
        4'b1011: seg_out = 7'b1100000; // b
        4'b1100: seg_out = 7'b0110001; // C
        4'b1101: seg_out = 7'b1000010; // d
        4'b1110: seg_out = 7'b0110000; // E
        4'b1111: seg_out = 7'b0111000; // F
        
        default: seg_out = 7'b1111111; //display off.  
    endcase
        
end
endmodule
