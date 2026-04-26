module svn_seg_decoder(
    input [7:0] data_val,
    input [7:0] row_val,
    input [7:0] size_val,
    input [7:0] speed_val,
    input [2:0] bit_cnt,
    output reg [6:0] seg_out,
    output reg decimal
    );

    reg [3:0] disp_val; //holds a value to display

always @(*) begin
    decimal <= 1'b1; //default decimal off
    //default: all cathodes are off
    seg_out <= 7'b1111111;

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

    case(disp_val)
        4'b0000: seg_out <= 7'b0000001; // 0
        4'b0001: seg_out <= 7'b1001111; // 1
        4'b0010: seg_out <= 7'b0010010; // 2
        4'b0011: seg_out <= 7'b0000110; // 3
        4'b0100: seg_out <= 7'b1001100; // 4
        4'b0101: seg_out <= 7'b0100100; // 5
        4'b0110: seg_out <= 7'b0100000; // 6
        4'b0111: seg_out <= 7'b0001111; // 7
        4'b1000: seg_out <= 7'b0000000; // 8
        4'b1001: seg_out <= 7'b0000100; // 9
        4'b1010: seg_out <= 7'b0001000; // A
        4'b1011: seg_out <= 7'b1100000; // b
        4'b1100: seg_out <= 7'b0110001; // C
        4'b1101: seg_out <= 7'b1000010; // d
        4'b1110: seg_out <= 7'b0110000; // E
        4'b1111: seg_out <= 7'b0111000; // F
        
        default: seg_out <= 7'b1111111; //display off.  
    endcase
        
end
endmodule
