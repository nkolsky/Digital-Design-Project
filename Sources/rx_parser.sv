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

always_comb begin : 
    is_valid = (msg_in[127:120] == CHAR_OPEN_BRACE)   &&
                (msg_in[119:112] == CHAR_R)           &&
                (msg_in[87:80]   == CHAR_C)           &&
                (msg_in[55:48]   == CHAR_V)           &&
                (msg_in[7:0]     == CHAR_CLOSE_BRACE);
end

endmodule : rs_parser