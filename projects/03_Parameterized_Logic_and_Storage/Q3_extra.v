module Q3_extra(D, S, y);
    input D;
    input [1:0] S;
    output reg [3:0] y;

    always @(*) begin
        case (S)
        2'b00: y= {3'b000, D};
        2'b01: y= {2'b00, D, 1'b0};
        2'b10: y= {1'b0, D, 2'b00};
        2'b11: y= {D, 3'b000};
        endcase
    end
endmodule
