`timescale 1ns/1ps

module rise_detector_tb;

    reg clk;
    reg rst_n;
    reg in;
    wire rise_edge;

    // DUT
    rise_detector dut (
        .clk(clk),
        .rst_n(rst_n),
        .in(in),
        .rise_edge(rise_edge)
    );

    // Clock: 10 ns period
    always #5 clk = ~clk;

    initial begin
        // Initial values
        clk  = 0;
        rst_n = 0;
        in   = 0;

        // Reset
        #10;
        rst_n = 1;

        // --------------------------------
        // Test 1: Input stays LOW
        // --------------------------------
        $display("Test 1: Input stays LOW");
        in = 0;
        #20;

        // --------------------------------
        // Test 2: LOW -> HIGH
        // Should detect rising edge
        // --------------------------------
        $display("Test 2: LOW -> HIGH");
        in = 1;

        #10;  // Wait one clock cycle

        if (rise_edge !== 1'b1)
            $display("ERROR: Rising edge was not detected!");
        else
            $display("PASS: Rising edge detected.");

        // --------------------------------
        // Test 3: Input stays HIGH
        // Should NOT detect another edge
        // --------------------------------
        $display("Test 3: Input stays HIGH");
        #10;

        if (rise_edge !== 1'b0)
            $display("ERROR: False rising edge detected!");
        else
            $display("PASS: No false rising edge.");

        // --------------------------------
        // Test 4: HIGH -> LOW
        // Then LOW -> HIGH again
        // --------------------------------
        $display("Test 4: HIGH -> LOW -> HIGH");

        in = 0;
        #10;

        in = 1;
        #10;

        if (rise_edge !== 1'b1)
            $display("ERROR: Second rising edge was not detected!");
        else
            $display("PASS: Second rising edge detected.");

        // --------------------------------
        // Test 5: Input remains HIGH
        // --------------------------------
        in = 1;
        #10;

        if (rise_edge !== 1'b0)
            $display("ERROR: Rising edge stayed HIGH!");
        else
            $display("PASS: Rising edge returned LOW.");

        // --------------------------------
        // Finish
        // --------------------------------
        $display("Rise detector testbench finished.");
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor(
            "Time=%0t | clk=%b rst_n=%b in=%b rise_edge=%b",
            $time, clk, rst_n, in, rise_edge
        );
    end

endmodule