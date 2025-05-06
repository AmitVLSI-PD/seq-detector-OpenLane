module seq_detector_mealy (
    input wire clk,
    input wire reset,
    input wire din,
    output reg dout
);
    // State encoding using parameters (Verilog-2001)
    parameter S0 = 2'b00;
    parameter S1 = 2'b01;
    parameter S2 = 2'b10;
    parameter S3 = 2'b11;
    
    reg [1:0] state, next_state;
    
    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end
    
    // Next state and output logic
    always @(*) begin
        dout = 1'b0; // Default output
        case (state)
            S0: begin
                next_state = din ? S1 : S0;
            end
            S1: begin
                next_state = din ? S1 : S2;
            end
            S2: begin
                next_state = din ? S3 : S0;
            end
            S3: begin
                next_state = din ? S1 : S2;
                dout = (din == 1'b0) ? 1'b1 : 1'b0;
            end
            default: next_state = S0;
        endcase
    end
endmodule
