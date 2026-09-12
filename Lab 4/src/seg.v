module seg(
    input rst_n,
    input [3:0] falling,
    input [3:0] rising,
    input [3:0] tick,

    output reg [6:0] R, R_c, F, F_c, t, t_c
);
    localparam r_char = 7'b1001000;
    localparam f_char = 7'b0001110;
    localparam t_char = 7'b0000111;

    localparam [6:0] SEG_0 = 7'b1000000;
    localparam [6:0] SEG_1 = 7'b1111001;
    localparam [6:0] SEG_2 = 7'b0100100;
    localparam [6:0] SEG_3 = 7'b0110000;
    localparam [6:0] SEG_4 = 7'b0011001;
    localparam [6:0] SEG_5 = 7'b0010010;
    localparam [6:0] SEG_6 = 7'b0000010;
    localparam [6:0] SEG_7 = 7'b1111000;
    localparam [6:0] SEG_8 = 7'b0000000;
    localparam [6:0] SEG_9 = 7'b0010000;

    localparam [6:0] SEG_A = 7'b0001000;
    localparam [6:0] SEG_B = 7'b0000011;
    localparam [6:0] SEG_C = 7'b1000110;
    localparam [6:0] SEG_D = 7'b0100001;
    localparam [6:0] SEG_E = 7'b0000110;
    localparam [6:0] SEG_F = 7'b0001110;


    always @(*) begin
        if(!rst_n) begin
            {R, R_c, F, F_c, t, t_c} = {7'b1001000, 7'b1000001, {2{7'b1000111}}};
        end
        else begin
            R = r_char;
            F = f_char;
            t = t_char;

            case (rising)
                4'b0000: R_c = SEG_0;
                4'b0001: R_c = SEG_1;
                4'b0010: R_c = SEG_2;
                4'b0011: R_c = SEG_3;
                4'b0100: R_c = SEG_4;
                4'b0101: R_c = SEG_5;
                4'b0110: R_c = SEG_6;
                4'b0111: R_c = SEG_7;
                4'b1000: R_c = SEG_8;
                4'b1001: R_c = SEG_9;
                4'b1010: R_c = SEG_A;
                4'b1011: R_c = SEG_B;
                4'b1100: R_c = SEG_C;
                4'b1101: R_c = SEG_D;
                4'b1110: R_c = SEG_E;
                4'b1111: R_c = SEG_F;
                default: R_c = 7'b1111111; // Display nothing for invalid input

            endcase


            case (falling)
                4'b0000: F_c = SEG_0;
                4'b0001: F_c = SEG_1;
                4'b0010: F_c = SEG_2;
                4'b0011: F_c = SEG_3;
                4'b0100: F_c = SEG_4;
                4'b0101: F_c = SEG_5;
                4'b0110: F_c = SEG_6;
                4'b0111: F_c = SEG_7;
                4'b1000: F_c = SEG_8;
                4'b1001: F_c = SEG_9;
                4'b1010: F_c = SEG_A;
                4'b1011: F_c = SEG_B;
                4'b1100: F_c = SEG_C;
                4'b1101: F_c = SEG_D;
                4'b1110: F_c = SEG_E;
                4'b1111: F_c = SEG_F;
                default: F_c = 7'b1111111;
            endcase


            
            case (tick)
                4'b0000: t_c = SEG_0;
                4'b0001: t_c = SEG_1;
                4'b0010: t_c = SEG_2;
                4'b0011: t_c = SEG_3;
                4'b0100: t_c = SEG_4;
                4'b0101: t_c = SEG_5;
                4'b0110: t_c = SEG_6;
                4'b0111: t_c = SEG_7;
                4'b1000: t_c = SEG_8;
                4'b1001: t_c = SEG_9;
                4'b1010: t_c = SEG_A;
                4'b1011: t_c = SEG_B;
                4'b1100: t_c = SEG_C;
                4'b1101: t_c = SEG_D;
                4'b1110: t_c = SEG_E;
                4'b1111: t_c = SEG_F;
                default: t_c = 7'b1111111;
            endcase
        end
    end


endmodule
        




