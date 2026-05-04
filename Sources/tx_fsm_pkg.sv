package tx_fsm_pkg;
    typedef enum logic [3:0] {
        IDLE = 4'd1, 
        SEND_DATA = 4'd2, 
        WAIT_DATA = 4'd3,
        SEND_NEW_LINE = 4'd4, 
        WAIT_NEW_LINE = 4'd5, 
        SEND_LINE_START = 4'd6,
        WAIT_LINE_START = 4'd7, 
        WAIT_NEW_BYTE = 4'd8, 
        SEND_SPACE = 4'd9,
        WAIT_SPACE = 4'd10
        } tx_state_t;

    localparam logic [7:0] CHAR_SPACE = 8'h20;
    localparam logic [7:0] CHAR_CR    = 8'h0D;
    localparam logic [7:0] CHAR_LF    = 8'h0A;
    
endpackage : tx_fsm_pkg

