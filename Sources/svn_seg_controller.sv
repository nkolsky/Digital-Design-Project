module svn_seg_controller(
    input logic clk,
    input logic rst_n,
    input logic [7:0] data_in,
    input logic rx_mode, // RX mode when high, TX mode when low
    input logic [7:0] tx_rows, // From byte_ctr.sv
    input logic [7:0] rx_pixel,
    input logic [7:0] rx_col,
    input logic [7:0] rx_row,
    output logic [7:0] anodes,     // Anodes (Active Low)
    output logic [6:0] cathodes, // CA, CB, CC, CD, CE, CF, CG, DP
    output logic dec_out // Decimal point output
);

// Internal signals
    logic [2:0] count_3bit;
    logic clk_4khz_en;         // 500Hz * 8 digits = 4kHz enable pulse
    logic [3:0] hex_to_decode;
    logic [7:0] active_t_group;
    logic dp_ctrl;             // Decimal point control

//instantiate the three bit counter
thr_bit_cntr thr_bit_cntr_inst (
    .clk(clk),
    .count_out(count_3bit)
);

//instantiate the data selection mux
svn_seg_data_slct svn_seg_data_slct_inst (
    .data_val(tx_rows),
    .row_val(rx_row),
    .size_val(rx_col),
    .speed_val(rx_pixel),
    .bit_cnt(count_3bit),
    .pixel_val(rx_pixel),
    .col_val(rx_col),
    .row_val(rx_row),
    .rx_mode(rx_mode),
    .decimal(dp_ctrl),
    .disp_val(hex_to_decode)
);

//instantiate the cathode decoder
svn_seg_decoder svn_seg_decoder_inst (
    .disp_val(hex_to_decode),
    .dec_in(dp_ctrl),
    .seg_out(decoded_cathodes),
    .dec_out(decoded_dp)
);

//instantiate anode decoder
anode_decoder anode_decoder_inst (
    .count(count_3bit),
    .anodes(anodes)
);

//control logic to override the values in t1 and put dashes in rx mode
always_comb begin
    // If in RX mode and on the middle digits (T1 group: digits 2 and 3)
    if (rx_mode && (count_3bit == 3'b010 || count_3bit == 3'b011)) begin
        cathodes = 7'b0111111; // Hardcoded Dash (Only G segment is 0/ON)
    end else begin
        cathodes = decoded_cathodes; // Use normal hex-to-segment decoding
    end
    
    // Connect the decimal point
    dec_out = decoded_dp; 
end

endmodule

