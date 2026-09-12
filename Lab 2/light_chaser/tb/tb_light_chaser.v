`timescale 1ns/1ps

module tb_light_chaser;

    parameter WIDTH = 10;

    reg clk;
    reg reset_n;
    reg hold_n;

    wire [WIDTH-1:0] out;

    light_chaser #(
        .WIDTH(WIDTH)
    ) dut (
        .clk(clk),
        .reset_n(reset_n),
        .hold_n(hold_n),
        .out(out)
    );

    // 100 Hz clock
    // Period = 10 ms
    always #5 clk = ~clk;

    initial begin

        $dumpfile("light_chaser.vcd");
        $dumpvars(0, tb_light_chaser);

        clk = 0;
        reset_n = 0;
        hold_n = 0;

        $monitor(
            "time=%0t | clk=%b | reset_n=%b | hold_n=%b | out=%b",
            $time,
            clk,
            reset_n,
            hold_n,
            out
        );

        // Reset
        #20;

        // Release reset
        reset_n = 1;

        // Start chaser
        hold_n = 1;


        #60

        reset_n = 0;

        #100
        reset_n = 1;


        #40

        hold_n = 0;


        #50

        hold_n = 1;

        // Run long enough to see it move
        #200000;

        $finish;
    end

endmodule
