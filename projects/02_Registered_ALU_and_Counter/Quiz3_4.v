module Quiz3_4(clk,rst,Q);
input clk;
input rst;
output reg [1:0]Q;
always @(posedge clk or posedge rst) begin
    if (rst)
        Q <= 2'b00;
    else begin
        case (Q)
            2'b00: Q <= 2'b01;
            2'b01: Q <= 2'b10;
            2'b10: Q <= 2'b11;
            2'b11: Q <= 2'b00;
            default: Q <= 2'b00;
        endcase
    end
end

endmodule
