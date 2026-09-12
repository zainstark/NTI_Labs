`timescale 1ns/1ps

module fall_detector_tb;

    reg clk;
    reg rst_n;
    reg in;
    wire fall_edge;

    // DUT
    fall_detector dut (
        .clk(clk),
        .rst_n(rst_n),
        .in(in),
        .fall_edge(fall_edge)
    );

    // Clock: 10 ns period
    always #5 clk = ~clk;

    initial begin
        // Initial values
        clk  = 0;
        rst_n = 0;
        in   = 1;

        // Reset
        #10;
        rst_n = 1;

        // --------------------------------
        // Test 1: Input stays HIGH
        // --------------------------------
        $display("Test 1: Input stays HIGH");
        in = 1;
        #20;

        // --------------------------------
        // Test 2: HIGH -> LOW
        // Should detect falling edge
        // --------------------------------
        $display("Test 2: HIGH -> LOW");
        in = 0;

        #10;

        if (fall_edge !== 1'b1)
            $display("ERROR: Falling edge was not detected!");
        else
            $display("PASS: Falling edge detected.");

        // --------------------------------
        // Test 3: Input stays LOW
        // Should NOT detect another edge
        // --------------------------------
        $display("Test 3: Input stays LOW");
        #10;

        if (fall_edge !== 1'b0)
            $display("ERROR: False falling edge detected!");
        else
            $display("PASS: No false falling edge.");

        // --------------------------------
        // Test 4: LOW -> HIGH -> LOW
        // --------------------------------
        $display("Test 4: LOW -> HIGH -> LOW");

        in = 1;
        #10;

        in = 0;
        #10;

        if (fall_edge !== 1'b1)
            $display("ERROR: Second falling edge was not detected!");
        else
            $display("PASS: Second falling edge detected.");

        // --------------------------------
        // Test 5: Input remains LOW
        // --------------------------------
        in = 0;
        #10;

        if (fall_edge !== 1'b0)
            $display("ERROR: Falling edge stayed HIGH!");
        else
            $display("PASS: Falling edge returned LOW.");

        // --------------------------------
        // Finish
        // --------------------------------
        $display("Fall detector testbench finished.");
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor(
            "Time=%0t | clk=%b rst_n=%b in=%b fall_edge=%b",
            $time, clk, rst_n, in, fall_edge
        );
    end

endmodule