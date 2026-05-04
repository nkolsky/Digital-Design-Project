module rx_bit_cntr (
    input logic clk,
    input logic rst_n,
    input logic bit_cnt_en,
    input logic byte_cnt_en,
    
    output logic [2:0] bit_cnt,
    output logic [3:0]byte_cnt
);

//bit counter logic
always_ff @(posedge clk or negedge rst_n) begin : bitCounter
    if (!rst_n) begin
        bit_cnt <= 3'b0;
    end else if (bit_cnt_en) begin
        bit_cnt <= bit_cnt + 1;
    end else begin
        bit_cnt <= bit_cnt; //hold value when bit_cnt_en is low
    end

end : bitCounter

//byte counter logic
always_ff @(posedge clk or negedge rst_n) begin : byteCounter
    if (!rst_n) begin
        byte_cnt <= 4'b0;
    end else if (byte_cnt_en) begin
        byte_cnt <= byte_cnt + 1;
    end else begin
        byte_cnt <= byte_cnt; //hold value when byte_cnt_en is low
    end

end : byteCounter


endmodule