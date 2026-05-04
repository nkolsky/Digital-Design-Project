import rx_parser_pkg::*;

module rx_parser (
    input logic clk,
    input logic rst_n,
    input logic [127:0] msg_in, //the full 16 byte message that we want to parse, output from the message register
    input logic parse_en, //enable signal for parsing the message, should only be high during the PARSE_DATA state of the FSM
    output logic [7:0] pixel_val, //Hex for T0
    output logic [7:0] colIdx, //T2
    output logic [7:0] rowIdx //T3
);

//internal wire for checking if the message has the correct format before we parse out the data
logic is_valid_msg;

//interbediate binary values
logic [7:0] row_calc, col_calc, pix_calc;

assign row_calc = (msg_in[111:104] - ASCII_ZERO) * 100 + 
                  (msg_in[103:96] - ASCII_ZERO) * 10   + 
                  (msg_in[95:88] - ASCII_ZERO);
assign col_calc = (msg_in[71:64] - ASCII_ZERO) * 100 + 
                  (msg_in[63:56] - ASCII_ZERO) * 10  +
                  (msg_in[55:48] - ASCII_ZERO);
assign pix_calc = (msg_in[31:24] - ASCII_ZERO) * 100 + 
                  (msg_in[23:16] - ASCII_ZERO) * 10  + 
                  (msg_in[15:8] - ASCII_ZERO);

always_comb begin : validateParse
    is_valid_msg = (msg_in[127:120]  == CHAR_OPEN_BRACE)  &&
                (msg_in[119:112] == CHAR_R)           &&
                (msg_in[87:80]   == CHAR_COMMA)       &&
                (msg_in[79:72]   == CHAR_C)           &&
                (msg_in[47:40]   == CHAR_COMMA)       &&
                (msg_in[39:32]   == CHAR_V)           &&
                (msg_in[7:0]     == CHAR_CLOSE_BRACE);

end : validateParse

always_ff @(posedge clk or negedge rst_n) begin : parseMessage
    if (!rst_n) begin
        pixel_val <= 8'b0;
        colIdx <= 8'b0;
        rowIdx <= 8'b0;
    end else if (parse_en && is_valid_msg) begin
        pixel_val <= pix_calc; //convert pixel value
        colIdx <= col_calc; //convert column index
        rowIdx <= row_calc; //convert row index
    end
    
end : parseMessage

endmodule : rx_parser