`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2026 04:20:51 PM
// Design Name: 
// Module Name: size_converter
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


module size_converter(
    input [1:0] size_config,
    output logic [7:0] converted_size
    );

    always_comb begin : blockName
    case(size_config)
        2'b00: converted_size <= 8'h01; // 1 
        2'b01: converted_size <= 8'h20; // 32 
        2'b10: converted_size <= 8'h80; // 128
        2'b11: converted_size <= 8'hff; // 255 (we can't actually fit 256 so I guess)
        default: converted_size <= 8'h01; //default to 1 bit
    endcase
end
endmodule
