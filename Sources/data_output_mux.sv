`timescale 1ns / 1ps
import tx_fsm_pkg::*;

module data_output_mux(
    input logic [7:0] data_in,
    input logic [1:0] select,
    output logic [7:0] mux_out
);

always_comb begin //: byte_selector
    case (select)
        2'b00: mux_out = data_in; // default to data input
        2'b01: mux_out = CHAR_SPACE; // Space (' ')
        2'b10: mux_out = CHAR_LF; // Line Feed (\n)
        2'b11: mux_out = CHAR_CR; // Carriage return (\r)
        //default: mux_out = data_in; //default to data input
    endcase
end //: byte_selector

endmodule