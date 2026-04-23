module rx_msg_reg (
    input logic clk,
    input logic rst_n,
    input logic msg_reg_en, //enable signal for latching the received byte into the message register, should only be high during the UPDATE_BYTE_CNT state of the FSM
    input logic [3:0] byte_cnt, //how many bytes read out of the 16 bytes in the message, used to determine where to latch the received byte in the message register
    input logic [7:0] byte_in, //the byte that we want to latch into the message register, output from the rx_byte_shift_reg
    output logic [127:0] msg_out //the parallel output of the message register representing the full received message (16 bytes)
);

// Message register logic for storing the full received message as we receive it byte by byte
always_ff @(posedge clk or negedge rst_n) begin: msgRegLogic
    if(!rst_n) begin
        msg_out <= 128'b0;
    end else if (msg_reg_en) begin
        case(byte_cnt)
            4'd0: msg_out[127:120] <= byte_in; //latch the first received byte into the most significant byte of the message register
            4'd1: msg_out[119:112] <= byte_in;
            4'd2: msg_out[111:104] <= byte_in;
            4'd3: msg_out[103:96] <= byte_in;
            4'd4: msg_out[95:88] <= byte_in;
            4'd5: msg_out[87:80] <= byte_in;
            4'd6: msg_out[79:72] <= byte_in;
            4'd7: msg_out[71:64] <= byte_in;
            4'd8: msg_out[63:56] <= byte_in;
            4'd9: msg_out[55:48] <= byte_in;
            4'd10: msg_out[47:40] <= byte_in;
            4'd11: msg_out[39:32] <= byte_in;
            4'd12: msg_out[31:24] <= byte_in;
            4'd13: msg_out[23:16] <= byte_in;
            4'd14: msg_out[15:8] <= byte_in;
            4'd15: msg_out[7:0] <= byte_in; //latch the last received byte into the least significant byte of the message register
            default: msg_out <= msg_out; //should never happen, but if byte_cnt is out of range we just keep the message register unchanged
        endcase      
    end
end : msgRegLogic
endmodule : rx_msg_reg