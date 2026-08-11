`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Design Name: TX Controller
// Module Name: data_output_mux
// Project Name: Lab4
//////////////////////////////////////////////////////////////////////////////////

module data_output_mux_tst;
    reg [7:0] data_in;
    reg [1:0] select;
    reg [7:0] mux_out;

    data_output_mux data_output_mux_t(
        .data_in(data_in),
        .select(select),
        .mux_out(mux_out)
    );

    initial begin
        data_in = 8'd7; select = 2'b00; #10;
        select = 2'b00; #100;
        select = 2'b01; #100;
        select = 2'b10; #100;
        select = 2'b11; #100;
        select = 2'b00; #100;
        select = 2'b01; #100;
        select = 2'b10; #100;
        select = 2'b11; #100;
    end

endmodule