`timescale 1ns/1ps

module debounce_tb;

    // DUT signals
    reg clk;
    reg rst_n;
    reg sw;
    wire db;

    // Instantiate DUT
    debounce dut (
        .clk   (clk),
        .rst_n (rst_n),
        .sw    (sw),
        .db    (db)
    );

    // ------------------------------------------------------------
    // 50 MHz clock
    // Period = 20 ns
    // ------------------------------------------------------------
    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk;
    end

    // ------------------------------------------------------------
    // Helper: wait for N rising edges of clk
    // ------------------------------------------------------------
    task wait_clks(input integer n);
        integer i;
        begin
            for (i = 0; i < n; i = i + 1)
                @(posedge clk);
        end
    endtask

    // ------------------------------------------------------------
    // Test sequence
    // ------------------------------------------------------------
    initial begin

        // VCD waveform
        $dumpfile("debounce_tb.vcd");
        $dumpvars(0, debounce_tb);

        // Initial values
        rst_n = 1'b0;
        sw    = 1'b0;

        $display("==========================================");
        $display("DEBOUNCE TESTBENCH");
        $display("==========================================");

        // --------------------------------------------------------
        // TEST 1: RESET
        // --------------------------------------------------------
        $display("\nTEST 1: RESET");

        #25;

        if (db !== 1'b0)
            $display("FAIL: db should be 0 after reset");
        else
            $display("PASS: reset");

        rst_n = 1'b1;

        // --------------------------------------------------------
        // TEST 2: Switch remains LOW
        // --------------------------------------------------------
        $display("\nTEST 2: SWITCH LOW");

        wait_clks(10);

        if (db !== 1'b0)
            $display("FAIL: db changed while sw=0");
        else
            $display("PASS: db remains 0");

        // --------------------------------------------------------
        // TEST 3: Clean press
        // sw: 0 -> 1 and remains high
        //
        // FSM:
        // zero -> wait1_1 -> wait1_2 -> wait1_3 -> one
        // --------------------------------------------------------
        $display("\nTEST 3: CLEAN PRESS");

        sw = 1'b1;

        // Wait enough cycles for the FSM to reach ONE
        wait_clks(8);

        if (db !== 1'b1)
            $display("FAIL: clean press did not produce db=1");
        else
            $display("PASS: clean press");

        // --------------------------------------------------------
        // TEST 4: Switch remains HIGH
        // --------------------------------------------------------
        $display("\nTEST 4: SWITCH HIGH");

        wait_clks(10);

        if (db !== 1'b1)
            $display("FAIL: db should remain 1 while sw=1");
        else
            $display("PASS: db remains 1");

        // --------------------------------------------------------
        // TEST 5: Release switch
        // sw: 1 -> 0 and remains low
        //
        // FSM:
        // one -> wait0_1 -> wait0_2 -> wait0_3 -> zero
        // --------------------------------------------------------
        $display("\nTEST 5: CLEAN RELEASE");

        sw = 1'b0;

        wait_clks(8);

        if (db !== 1'b0)
            $display("FAIL: clean release did not produce db=0");
        else
            $display("PASS: clean release");

        // --------------------------------------------------------
        // TEST 6: Press bounce
        //
        // Rapidly toggle sw before allowing it to settle.
        // The FSM should NOT immediately assert db.
        // --------------------------------------------------------
        $display("\nTEST 6: PRESS BOUNCE");

        sw = 1'b1;
        #9;

        sw = 1'b0;
        #6;

        sw = 1'b1;
        #8;

        sw = 1'b0;
        #4;

        sw = 1'b1;

        // Give FSM time to settle
        wait_clks(8);

        if (db !== 1'b1)
            $display("FAIL: press bounce was not filtered");
        else
            $display("PASS: press bounce filtered");

        // --------------------------------------------------------
        // TEST 7: Release bounce
        // --------------------------------------------------------
        $display("\nTEST 7: RELEASE BOUNCE");

        sw = 1'b0;
        #12;

        sw = 1'b1;
        #8;

        sw = 1'b0;
        #15;

        sw = 1'b1;
        #7;

        sw = 1'b0;

        wait_clks(8);

        if (db !== 1'b0)
            $display("FAIL: release bounce was not filtered");
        else
            $display("PASS: release bounce filtered");

        // --------------------------------------------------------
        // TEST 8: Another clean press
        // --------------------------------------------------------
        $display("\nTEST 8: SECOND CLEAN PRESS");

        sw = 1'b1;

        wait_clks(8);

        if (db !== 1'b1)
            $display("FAIL: second press failed");
        else
            $display("PASS: second press");

        // --------------------------------------------------------
        // TEST 9: Another clean release
        // --------------------------------------------------------
        $display("\nTEST 9: SECOND CLEAN RELEASE");

        sw = 1'b0;

        wait_clks(8);

        if (db !== 1'b0)
            $display("FAIL: second release failed");
        else
            $display("PASS: second release");

        // --------------------------------------------------------
        // Finish
        // --------------------------------------------------------
        $display("\n==========================================");
        $display("ALL TESTS COMPLETED");
        $display("==========================================");

        $finish;
    end

endmodule