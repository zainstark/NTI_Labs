`timescale 1ns/1ps

module tb_sequence_detector;

    reg clk;
    reg rst_n;
    reg din;

    wire detected_moore;
    wire detected_mealy;

    // ------------------------------------------------
    // Moore detector
    // ------------------------------------------------

    sequence_detector_moore #(
        .OVERLAP(1'b0)
    ) moore_inst (
        .clk(clk),
        .rst_n(rst_n),
        .din(din),
        .detected(detected_moore)
    );

    // ------------------------------------------------
    // Mealy detector
    // ------------------------------------------------

    sequence_detector_mealy #(
        .OVERLAP(1'b0)
    ) mealy_inst (
        .clk(clk),
        .rst_n(rst_n),
        .din(din),
        .detected(detected_mealy)
    );

    // ------------------------------------------------
    // Clock
    // ------------------------------------------------

    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end

    // ------------------------------------------------
    // Send one bit
    // ------------------------------------------------

    task send_bit;
        input bit_value;

        begin

            din = bit_value;

            @(posedge clk);
            #1;

            $display(
                "Time=%0t | din=%b | Moore=%b | Mealy=%b",
                $time,
                din,
                detected_moore,
                detected_mealy
            );

        end
    endtask

    // ------------------------------------------------
    // Test
    // ------------------------------------------------

    initial begin

        // Initial values
        rst_n = 1'b0;
        din   = 1'b0;

        // Reset
        repeat (2)
            @(posedge clk);

        rst_n = 1'b1;

        $display("-----------------------------------------");
        $display("TEST 1: 110101");
        $display("-----------------------------------------");

        send_bit(1);
        send_bit(1);
        send_bit(0);
        send_bit(1);
        send_bit(0);
        send_bit(1);

        // Extra cycle so Moore can assert detection
        send_bit(0);


        $display("-----------------------------------------");
        $display("TEST 2: 00110101100");
        $display("-----------------------------------------");

        send_bit(0);
        send_bit(0);
        send_bit(1);
        send_bit(1);
        send_bit(0);
        send_bit(1);
        send_bit(0);
        send_bit(1);
        send_bit(1);
        send_bit(0);
        send_bit(0);


        $display("-----------------------------------------");
        $display("TEST 3: 110100");
        $display("-----------------------------------------");

        send_bit(1);
        send_bit(1);
        send_bit(0);
        send_bit(1);
        send_bit(0);
        send_bit(0);


        #20;

        $display("-----------------------------------------");
        $display("Simulation finished");
        $display("-----------------------------------------");

        $finish;

    end

endmodule