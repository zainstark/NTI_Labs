module controller (
    input  [2:0] opcode,
    input  [2:0] phase,
    input        zero,

    output reg   sel,
    output reg   rd,
    output reg   ld_ir,
    output reg   inc_pc,
    output reg   halt,
    output reg   ld_pc,
    output reg   data_e,
    output reg   ld_ac,
    output reg   wr
);

    // Opcode definitions
    localparam HLT = 3'b000;
    localparam SKZ = 3'b001;
    localparam ADD = 3'b010;
    localparam AND = 3'b011;
    localparam XOR = 3'b100;
    localparam LDA = 3'b101;
    localparam STO = 3'b110;
    localparam JMP = 3'b111;

    // Intermediate terms
    reg ALU_OP;
    reg HALT;

    always @(*) begin

        // Intermediate terms
        ALU_OP = (opcode == ADD) ||
                 (opcode == AND) ||
                 (opcode == XOR) ||
                 (opcode == LDA);

        HALT = (opcode == HLT);

        // Default outputs
        sel    = 1'b0;
        rd     = 1'b0;
        ld_ir  = 1'b0;
        inc_pc = 1'b0;
        halt   = 1'b0;
        ld_pc  = 1'b0;
        data_e = 1'b0;
        ld_ac  = 1'b0;
        wr     = 1'b0;

        case (phase)

            // 0: INST_ADDR
            3'd0: begin
                sel = 1'b1;
            end

            // 1: INST_FETCH
            3'd1: begin
                sel = 1'b1;
                rd  = 1'b1;
            end

            // 2: INST_LOAD
            3'd2: begin
                sel   = 1'b1;
                rd    = 1'b1;
                ld_ir = 1'b1;
            end

            // 3: IDLE
            3'd3: begin
                sel   = 1'b1;
                rd    = 1'b1;
                ld_ir = 1'b1;
            end

            // 4: OP_ADDR
            3'd4: begin
                inc_pc = 1'b1;

                if (HALT)
                    halt = 1'b1;
            end

            // 5: OP_FETCH
            3'd5: begin
                if (ALU_OP)
                    rd = 1'b1;
            end

            // 6: ALU_OP
            3'd6: begin

                if (ALU_OP)
                    rd = 1'b1;

                if ((opcode == SKZ) && zero)
                    inc_pc = 1'b1;

                if (opcode == JMP)
                    ld_pc = 1'b1;

                if (opcode == STO)
                    data_e = 1'b1;
            end

            // 7: STORE
            3'd7: begin

                if (ALU_OP) begin
                    rd    = 1'b1;
                    ld_ac = 1'b1;
                end

                if (opcode == JMP)
                    ld_pc = 1'b1;

                if (opcode == STO) begin
                    data_e = 1'b1;
                    wr     = 1'b1;
                end
            end

            default: begin
                // Keep all outputs at zero
            end

        endcase
    end

endmodule