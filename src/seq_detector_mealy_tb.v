`timescale 1ns / 1ps

module seq_detector_mealy_tb;
    reg clk, reset, din;
    wire dout;
    
    // Instantiate the sequence detector
    seq_detector_mealy dut (
        .clk(clk),
        .reset(reset),
        .din(din),
        .dout(dout)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period (100MHz)
    end
    
    // Stimulus
    initial begin
        // Dump waveform for debugging
        $dumpfile("seq_detector_mealy_tb.vcd");
        $dumpvars(0, seq_detector_mealy_tb);

        $monitor($time, " reset=%b, din=%b, state=%b, dout=%b", reset, din, dut.state, dout);
        reset = 1; din = 0;
        #10 reset = 0;
        // Test sequence: 11010101011
        // Expected detections: at 11010, 1101010, 110101010
        #10 din = 1;  // 1
        #10 din = 1;  // 11
        #10 din = 0;  // 110
        #10 din = 1;  // 1101
        #10 din = 0;  // 11010 (dout = 1)
        #10 din = 1;  // 110101
        #10 din = 0;  // 1101010 (dout = 1)
        #10 din = 1;  // 11010101
        #10 din = 0;  // 110101010 (dout = 1)
        #10 din = 1;  // 1101010101
        #10 din = 1;  // 11010101011
        #20 $finish;
    end
endmodule
