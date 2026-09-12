`timescale 1ns/1ps

module top_tb;

    // --------------------------------------------------
    // DUT signals
    // --------------------------------------------------
    reg clk;
    reg rst_n;
    reg in;

    wire [6:0] R, R_c;
    wire [6:0] F, F_c;
    wire [6:0] t, t_c;

    // --------------------------------------------------
    // DUT
    // --------------------------------------------------
    top dut (
        .clk(clk),
        .rst_n(rst_n),
        .in(in),
        .R(R),
        .R_c(R_c),
        .F(F),
        .F_c(F_c),
        .t(t),
        .t_c(t_c)
    );

    // --------------------------------------------------
    // 100 Hz clock
    // Period = 10 ms = 10,000,000 ns
    // --------------------------------------------------
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // --------------------------------------------------
    // Waveform dump
    // --------------------------------------------------
    initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars(0, top_tb);
    end

    // --------------------------------------------------
    // Test
    // --------------------------------------------------
    initial begin

        // Initial state
        rst_n = 0;
        in    = 0;

        $display("======================================");
        $display(" Starting TOP testbench");
        $display("======================================");

        // Hold reset for a few input clocks
        #20_000_000;

        rst_n = 1;

        $display("[%0t] Reset released", $time);

        // --------------------------------------------------
        // Test 1: Rising edge
        // 0 -> 1
        // --------------------------------------------------
        $display("[%0t] Generating rising edge", $time);

        in = 1;

        // Wait for several divided clock cycles
        #30_000_000;

        // --------------------------------------------------
        // Test 2: Falling edge
        // 1 -> 0
        // --------------------------------------------------
        $display("[%0t] Generating falling edge", $time);

        in = 0;

        #30_000_000;

        // --------------------------------------------------
        // Test 3: Rising + falling
        // --------------------------------------------------
        $display("[%0t] Generating another rising edge", $time);

        in = 1;

        #30_000_000;

        $display("[%0t] Generating another falling edge", $time);

        in = 0;

        #30_000_000;

        // --------------------------------------------------
        // Test 4: Multiple edges
        // --------------------------------------------------
        $display("[%0t] Generating multiple edges", $time);

        in = 1;
        #20_000_000;

        in = 0;
        #20_000_000;

        in = 1;
        #20_000_000;

        in = 0;
        #20_000_000;

        // --------------------------------------------------
        // Finish
        // --------------------------------------------------
        $display("======================================");
        $display(" Testbench finished");
        $display("======================================");

        $finish;
    end

    // --------------------------------------------------
    // Monitor outputs
    // --------------------------------------------------
    initial begin
        $monitor(
            "[%0t] rst_n=%b in=%b | R=%b R_c=%b | F=%b F_c=%b | t=%b t_c=%b",
            $time,
            rst_n,
            in,
            R,
            R_c,
            F,
            F_c,
            t,
            t_c
        );
    end

endmodule