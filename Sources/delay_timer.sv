`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Design Name: TX Controller
// Module Name: delay_timer
// Project Name: Lab4
//////////////////////////////////////////////////////////////////////////////////


module delay_timer(
    input clk,
    input [1:0] speed_config,
    input en_timer,
    output logic timer_done
    );

    //  1ms "Tick" Generator
    // 100MHz = 100,000 cycles per 1ms. 
    // This needs 17 bits (2^17 = 131,072).
    logic [16:0] ms_count;
    logic        tick_ms;

    // Millisecond Counter
    // We only count the ms ticks. Max possible is 200 (needs 8 bits).
    logic [7:0] count;
    logic [7:0] max_ms;

    always_ff @(posedge clk) begin
       if (!en_timer) begin //timer is not enabled, so reset count and tick
            ms_count <= 0;
            tick_ms  <= 0;
        end else if (ms_count >= 17'd99999) begin //ms_count has reached 100,000 cycles, which is 1ms at 100MHz
            ms_count <= 0;
            tick_ms  <= 1; // Pulses high for exactly 1 clock cycle
        end else begin //counting to 1ms
            ms_count <= ms_count + 1;
            tick_ms  <= 0;
        end
    end

    always_comb begin
        case(speed_config)
            2'b00:   max_ms = 8'd0;   // No delay
            2'b01:   max_ms = 8'd50;  // 50ms
            2'b10:   max_ms = 8'd100; // 100ms
            2'b11:   max_ms = 8'd200; // 200ms
            default: max_ms = 8'd0;
        endcase
    end

    always_ff @(posedge clk) begin
        if (!en_timer) begin
            count <= 0;
            timer_done <= 0;
        end else if (tick_ms) begin // Only increment when a full ms has passed
            if (count + 1 >= max_ms) begin
                timer_done <= 1;
            end else begin
                count <= count + 1;
                //timer_done <= 0;
            end
        end
    end

endmodule