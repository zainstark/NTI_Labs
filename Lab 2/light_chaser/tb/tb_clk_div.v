`timescale 1ns/1ps

module tb_clk_div;

    // Small values make simulation fast
    parameter integer HZ_IN  = 100;
    parameter integer HZ_OUT = 10;

    reg clk_in;
    reg reset_n;
    wire clk_out;

    // Instantiate the DUT
    clk_div #(
        .hz_in(HZ_IN),
        .hz_out(HZ_OUT)
    ) dut (
        .clk_in(clk_in),
        .reset_n(reset_n),
        .clk_out(clk_out)
    );

    // Generate input clock
    // 100 Hz => period = 10 ms
    always #5 clk_in = ~clk_in;

    // Test
    initial begin
		$dumpfile("clk_div.vcd");
		$dumpvars(0, tb_clk_div);
        clk_in = 0;
        reset_n = 0;

        $display("Starting clk_div test...");
        $monitor("time=%0t  reset_n=%b  clk_in=%b  counter=%0d  clk_out=%b",
                 $time, reset_n, clk_in, dut.counter, clk_out);

        // Hold reset for a few clock cycles
        #20;
        reset_n = 1;

        // Run long enough to observe several output cycles
        #300;

        $display("clk_div test finished.");
        $finish;


    end

endmodule
