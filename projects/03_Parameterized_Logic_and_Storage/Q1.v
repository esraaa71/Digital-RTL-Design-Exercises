module Q1 (in0, in1, out);
    parameter N = 4;
    parameter OPCODE = 0;
    input [N-1:0] in0, in1;
    output reg [N-1:0] out;

    always @(*) begin
    case (OPCODE)
    2'b00: out = in0 + in1;
    2'b01: out = in0 | in1;
    2'b10: out = in0 - in1;
    2'b11: out = in0 ^ in1;
    endcase
    end
endmodule
