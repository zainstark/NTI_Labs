module edge_detector (
     input  clk,
     input  rst_n,
     input  in,
     output rising_tick,
     output falling_tick,
     output edge_tick
 );


    rise_detector rise_detector_inst (
        .clk(clk),
        .rst_n(rst_n),
        .in(in),
        .rise_edge(rising_tick)
    );

    fall_detector fall_detector_inst (
        .clk(clk),
        .rst_n(rst_n),
        .in(in),
        .fall_edge(falling_tick)
    );


    assign edge_tick = rising_tick | falling_tick;


endmodule