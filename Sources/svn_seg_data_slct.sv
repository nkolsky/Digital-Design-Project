module svn_seg_data_slct(
    input [7:0] data_val,
    input [7:0] row_val,
    input [7:0] size_val,
    input [7:0] speed_val,
    input [2:0] bit_cnt,
    output logic decimal,
    output logic [3:0] disp_val
);

always_comb begin
decimal <= 1'b1; //default decimal off
    
    case(bit_cnt)
        3'b000: begin
        disp_val <= data_val[3:0];
        decimal <= 1'b1;
        end
        3'b001: begin
        disp_val <= data_val[7:4];
        decimal <= 1'b1;
        end
        3'b010: begin
        disp_val <= speed_val[3:0];
        decimal <= 1'b1;
        end
        3'b011: begin
        disp_val <= speed_val[7:4];
        decimal <= 1'b0;
        end
        3'b100: begin
        disp_val <= size_val[3:0];
        decimal <= 1'b1;
        end
        3'b101: begin
        disp_val <= size_val[7:4];
        decimal <= 1'b1;
        end
        3'b110: begin
        disp_val <= row_val[3:0];
        decimal <= 1'b1;
        end
        3'b111: begin
        disp_val <= row_val[7:4];
        decimal <= 1'b1;
        end
    endcase
end
endmodule