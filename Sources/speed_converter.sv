`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Design Name: TX Controller
// Module Name: speed_converter
// Project Name: Lab4
//////////////////////////////////////////////////////////////////////////////////


module speed_converter(
    input logic [1:0] speed_config,
    output logic [7:0] converted_speed
);

always_comb begin : blockName
    case(speed_config)
        2'b00: converted_speed <= 8'h00; //no delay
        2'b01: converted_speed <= 8'b00000101; // 0.5 
        2'b10: converted_speed <= 8'b00010000; // 1.0
        2'b11: converted_speed <= 8'b00100000; //2.0
        default: converted_speed <= 8'h00; //default to no delay
    endcase
end


endmodule