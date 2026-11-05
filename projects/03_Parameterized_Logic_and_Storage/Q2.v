module Q2(in0, in1, clk, rst, out);
    parameter N = 4;
    parameter OPCODE = 0;
    input [N-1:0] in0, in1;
    input clk, rst;
    output reg [N-1:0] out;

always @(posedge clk) begin
    if (rst)
        out <= 0;
    else
        case (OPCODE)
        2'b00: out <= in0 + in1;
        2'b01: out <= in0 | in1;
        2'b10: out <= in0 - in1;
        2'b11: out <= in0 ^ in1;
        endcase
end

endmodule
