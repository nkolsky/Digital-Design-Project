package tx_fsm_pkg;
    typedef enum logic [3:0] {
        IDLE =          4'b0000, 
        WAIT_DATA =     4'b0001, 
        SEND_NEW_LINE = 4'b0010, 
        WAIT_NEW_LINE = 4'b0011, 
        SEND_LINE_START = 4'b0100, 
        WAIT_LINE_START = 4'b0101, 
        WAIT_NEW_BYTE = 4'b0110, 
        SEND_SPACE =    4'b0111, 
        WAIT_SPACE =    4'b1000
        } tx_state_t;

    localparam logic [7:0] CHAR_SPACE = 8'h20;
    localparam logic [7:0] CHAR_CR    = 8'h0D;
    localparam logic [7:0] CHAR_LF    = 8'h0A;
    
endpackage : tx_fsm_pkg

