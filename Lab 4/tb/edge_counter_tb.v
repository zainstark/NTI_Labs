`timescale 1ns/1ps

module edge_counter_tb;

reg clk;
reg rst_n;

reg falling_tick;
reg rising_tick;
reg edge_tick;

wire [3:0] falling_count;
wire [3:0] rising_count;
wire [3:0] edge_count;


// DUT
edge_counter dut (
    .clk(clk),
    .rst_n(rst_n),
    .falling_tick(falling_tick),
    .rising_tick(rising_tick),
    .edge_tick(edge_tick),
    .falling_count(falling_count),
    .rising_count(rising_count),
    .edge_count(edge_count)
);


// Clock
always #5 clk = ~clk;


// Waveform
initial begin
    $dumpfile("edge_counter.vcd");
    $dumpvars(0, edge_counter_tb);
end


initial begin

    // Initial state
    clk = 0;
    rst_n = 0;

    falling_tick = 0;
    rising_tick = 0;
    edge_tick = 0;


    // ==========================================
    // RESET
    // ==========================================

    #10;
    rst_n = 1;


    // ==========================================
    // RISING EDGE #1
    // ==========================================

    #2;
    rising_tick = 1;
    edge_tick = 1;

    #8;
    rising_tick = 0;
    edge_tick = 0;


    // ==========================================
    // RISING EDGE #2
    // ==========================================

    #10;
    rising_tick = 1;
    edge_tick = 1;

    #8;
    rising_tick = 0;
    edge_tick = 0;


    // ==========================================
    // FALLING EDGE #1
    // ==========================================

    #10;
    falling_tick = 1;
    edge_tick = 1;

    #8;
    falling_tick = 0;
    edge_tick = 0;


    // ==========================================
    // FALLING EDGE #2
    // ==========================================

    #10;
    falling_tick = 1;
    edge_tick = 1;

    #8;
    falling_tick = 0;
    edge_tick = 0;


    // ==========================================
    // MIXED
    // ==========================================

    // Rising
    #10;
    rising_tick = 1;
    edge_tick = 1;

    #8;
    rising_tick = 0;
    edge_tick = 0;

    // Falling
    #10;
    falling_tick = 1;
    edge_tick = 1;

    #8;
    falling_tick = 0;
    edge_tick = 0;


    // ==========================================
    // NO EDGES
    // ==========================================

    #30;


    // ==========================================
    // FINISH
    // ==========================================

    $display("");
    $display("================================");
    $display("FINAL COUNTS");
    $display("================================");
    $display("Falling count = %d", falling_count);
    $display("Rising count  = %d", rising_count);
    $display("Edge count    = %d", edge_count);
    $display("================================");

    $finish;

end


// Print every change
initial begin

    $monitor(
        "time=%0t clk=%b rst_n=%b fall_tick=%b rise_tick=%b edge_tick=%b | fall=%d rise=%d edge=%d",
        $time,
        clk,
        rst_n,
        falling_tick,
        rising_tick,
        edge_tick,
        falling_count,
        rising_count,
        edge_count
    );

end

endmodule
