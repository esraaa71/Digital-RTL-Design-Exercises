module extra_1(A, B);
    parameter USE_GRAY = 1;
    input [2:0] A;
    output reg [6:0] B;

    generate
        if (USE_GRAY)
            always @(A)
                case (A)
                3'b000: B = 3'b000;
                3'b001: B = 3'b001;
                3'b010: B = 3'b011;
                3'b011: B = 3'b010;
                3'b100: B = 3'b110;
                3'b101: B = 3'b111;
                3'b110: B = 3'b101 ;
                3'b111: B = 3'b100 ;
                default: B = 3'b000;
                endcase
        else
            always @(A)
                case (A)
                3'b000: B = 7'b000_0000;
                3'b001: B = 7'b000_0001;
                3'b010: B = 7'b000_0010;
                3'b011: B = 7'b000_0100;
                3'b100: B = 7'b000_1000;
                3'b101: B = 7'b001_0000;
                3'b110: B = 7'b010_0000;
                3'b111: B = 7'b100_0000;
                default: B = 7'b0000_0000;
                endcase
    endgenerate
endmodule
