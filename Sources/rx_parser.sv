import rx_parser_pkg::*;

module rx_parser (
    input logic clk,
    input logic rst_n,
    input logic [127:0] msg_in, //the full 16 byte message that we want to parse, output from the message register
    input logic parse_en, //enable signal for parsing the message, should only be high during the PARSE_DATA state of the FSM
    output logic [7:0] pixel_val, //Hex for T0
    output logic [7:0] colIdx, //T2
    output logic [7:0] rowIdx, //T3
);

//internal wire for checking if the message has the correct format before we parse out the data
logic is_valid_msg;

//internal wires for converting pixel value, row index, and column index from ASCII to binary
logic [23:0] pix_hundreds, pix_tens, pix_ones; //for converting pixel value from ASCII to binary

always_comb begin : 
    is_valid = (msg_in[127:120]  == CHAR_OPEN_BRACE)  &&
                (msg_in[119:112] == CHAR_R)           &&
                (msg_in[87:80]   == CHAR_COMMA)       &&
                (msg_in[79:72]   == CHAR_C)           &&
                (msg_in[47:40]   == CHAR_COMMA)       &&
                (msg_in[39:32]   == CHAR_V)           &&
                (msg_in[7:0]     == CHAR_CLOSE_BRACE);
    //if the message format is correct, convert the pixel value, column index, and row index from ASCII to binary by subtracting the ASCII value for '0'
    if (is_valid) begin
        pix_hundreds = msg_in[31:24] - ASCII_ZERO;
        pix_tens = msg_in[23:16] - ASCII_ZERO;
        pix_ones = msg_in[15:8] - ASCII_ZERO;
    end
end

always_ff @(posedge clk or negedge rst_n) begin : parseMessage
    if (!rst_n) begin
        pixel_val <= 8'b0;
        colIdx <= 8'b0;
        rowIdx <= 8'b0;
    end else if (parse_en && is_valid) begin
        pixel_val <= pix_hundreds * 100 + pix_tens * 10 + pix_ones; //combine the hundreds, tens, and ones place to get the full pixel value in binary
        colIdx <= msg_in[79:72] - ASCII_ZERO; //convert column index from ASCII to binary
        rowIdx <= msg_in[119:112] - ASCII_ZERO; //convert row index
    end
    
end

endmodule : rs_parser