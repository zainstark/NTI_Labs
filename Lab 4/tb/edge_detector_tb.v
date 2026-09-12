`timescale 1ns/1ps

module edge_detector_tb;

    reg clk;
    reg rst_n;
    reg in;

    wire rising_tick;
    wire falling_tick;
    wire edge_tick;

    // DUT
    edge_detector dut (
        .clk(clk),
        .rst_n(rst_n),
        .in(in),
        .rising_tick(rising_tick),
        .falling_tick(falling_tick),
        .edge_tick(edge_tick)
    );

    // Clock: 10 ns period
    always #5 clk = ~clk;

    initial begin
        // Initial values
        clk  = 0;
        rst_n = 0;
        in   = 0;

        $display("Starting edge detector test...");

        // Hold reset for two clock cycles
        #12;
        rst_n = 1;

        // --------------------------------
        // Test 1: No edge
        // --------------------------------
        $display("Test 1: No edge");
        in = 0;
        #20;

        // --------------------------------
        // Test 2: Rising edge
        // --------------------------------
        $display("Test 2: Rising edge");
        in = 1;
        #20;

        // --------------------------------
        // Test 3: No edge while HIGH
        // --------------------------------
        $display("Test 3: Staying HIGH");
        in = 1;
        #20;

        // --------------------------------
        // Test 4: Falling edge
        // --------------------------------
        $display("Test 4: Falling edge");
        in = 0;
        #20;

        // --------------------------------
        // Test 5: Multiple edges
        // --------------------------------
        $display("Test 5: Multiple edges");

        in = 1;
        #20;

        in = 0;
        #20;

        in = 1;
        #20;

        in = 0;
        #20;

        $display("Test complete.");

        $finish;
    end

    // Monitor signals
    initial begin
        $monitor(
            "Time=%0t | clk=%b rst_n=%b in=%b | rising=%b falling=%b edge=%b",
            $time,
            clk,
            rst_n,
            in,
            rising_tick,
            falling_tick,
            edge_tick
        );
    end

endmodule