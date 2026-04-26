module thr_bit_cntr(
    input clk,
    output reg [2:0] cnt_out
    );

	initial cnt_out = 3'b000; //set the counter to 0
    
	wire [16:0] divisor = 2000000; // (1e9/5e2) --gives amount to divide clock by--
	
	reg [16:0] count = 0;
	
	always @(posedge clk) begin  //bring clock down to 500hz

		if (count == divisor - 1) begin 
			count <= 0;
			cnt_out <= cnt_out + 1; //should autowrap
		end else begin //count to 2000000
			count <= count + 1;
		end
    

	end    

endmodule
