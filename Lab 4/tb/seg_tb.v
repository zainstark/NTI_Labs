module seg_tb;



    reg rst_n;
    reg [3:0] falling;
    reg [3:0] rising;
    reg [3:0] tick;

    wire [6:0] R, R_c, F, F_c, t, t_c;

    seg uut(rst_n, falling, rising, tick, R, R_c, F, F_c, t, t_c);



    initial begin
        $dumpfile("seg.vcd");
        $dumpvars(0, seg_tb);
    end

    
    
    initial begin
        rst_n = 1;
        rising = 0;
        falling = 0;
        tick = 0;


        #10
        rst_n = 0;


        #10
        rst_n = 1;

        rising = 4;


        #10

        falling = 3;



        #10 
        tick = 7;



        #10

        rising = 10;



        #10
        rst_n = 0;

        $finish;
    end



endmodule