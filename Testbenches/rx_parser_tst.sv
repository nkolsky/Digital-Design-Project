`timescale 1ns / 1ps

module rs_parser_tst;
reg clk;
reg rst_n;
reg [127:0] msg_in;
reg parse_en;
reg [7:0] pixel_val;
reg [7:0] col_Idx;
reg [7:0] row_Idx;

initial rst_n = 1;
initial clk = 0;
always #5 clk = ~clk;

rx_parser rx_parser_t(
    .clk(clk),
    .rst_n(rst_n),
    .msg_in(msg_in),
    .parse_en(parse_en),
    .pixel_val(pixel_val),
    .colIdx(col_Idx),
    .rowIdx(row_Idx)
);

initial begin
    rst_n = 1; #5;
    msg_in = 128'h7B_52_303030_2C_43_313131_2C_56_323232_7D; #10;
    parse_en = 1; #1000;
    msg_in = 128'h7C_52_303030_2C_43_313131_2C_56_323232_7D; #10;
end

endmodule