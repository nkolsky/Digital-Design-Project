`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Design Name: TX Controller
// Module Name: data_output_mux
// Project Name: Lab4
//////////////////////////////////////////////////////////////////////////////////


module data_output_mux(
    input logic [7:0] data_in,
    input logic [1:0] select,
    output logic [7:0] mux_out
);

always_comb begin //: byte_selector
    case (select)
        2'b00: mux_out = data_in; // default to data input
        2'b01: mux_out = 8'h20; // Space (' ')
        2'b10: mux_out = 8'h0A; // Line Feed (\n)
        2'b11: mux_out = 8'h0D; // Carriage return (\r)
        //default: mux_out = data_in; //default to data input
    endcase
end //: byte_selector

endmodule