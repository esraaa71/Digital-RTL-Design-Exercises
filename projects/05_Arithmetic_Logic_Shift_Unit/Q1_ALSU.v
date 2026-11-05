`timescale 1ns/1ps

module ALSU #(
    parameter INPUT_PRIORITY = "A",
    parameter FULL_ADDER     = "ON"
)(
    input  wire        clk, rst,
    input  wire [2:0]  A, B, opcode,
    input  wire        cin, serial_in,
    input  wire        red_op_A, red_op_B,
    input  wire        bypass_A, bypass_B,
    input  wire        direction,
    output reg  [5:0]  out,
    output reg  [15:0] leds
);

    // input registers (DFF for every input except clk and rst)
    reg [2:0] A_r, B_r, opcode_r;
    reg       cin_r, serial_r, red_A_r, red_B_r;
    reg       byp_A_r, byp_B_r, dir_r;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A_r <= 0; B_r <= 0; opcode_r <= 0;
            cin_r <= 0; serial_r <= 0;
            red_A_r <= 0; red_B_r <= 0;
            byp_A_r <= 0; byp_B_r <= 0; dir_r <= 0;
        end else begin
            A_r <= A; B_r <= B; opcode_r <= opcode;
            cin_r <= cin; serial_r <= serial_in;
            red_A_r <= red_op_A; red_B_r <= red_op_B;
            byp_A_r <= bypass_A; byp_B_r <= bypass_B;
            dir_r <= direction;
        end
    end

    // invalid when opcode = 110 or 111, or reduction used with non AND/XOR opcode
    wire inv_opcode = opcode_r[2] & opcode_r[1];
    wire inv_red    = (red_A_r | red_B_r) & (opcode_r[2] | opcode_r[1]);
    wire invalid    = inv_opcode | inv_red;

    always @(posedge clk or posedge rst) begin
        if (rst)          leds <= 0;
        else if (invalid) leds <= ~leds;
        else              leds <= 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 0;
        end else begin
            if (byp_A_r && byp_B_r)
                out <= (INPUT_PRIORITY == "A") ? {3'b0, A_r} : {3'b0, B_r};
            else if (byp_A_r)
                out <= {3'b0, A_r};
            else if (byp_B_r)
                out <= {3'b0, B_r};
            else if (invalid)
                out <= 0;
            else begin
                case (opcode_r)
                    3'b000: begin
                        if (red_A_r && red_B_r)
                            out <= (INPUT_PRIORITY == "A") ? {5'b0, &A_r} : {5'b0, &B_r};
                        else if (red_A_r) out <= {5'b0, &A_r};
                        else if (red_B_r) out <= {5'b0, &B_r};
                        else              out <= {3'b0, A_r & B_r};
                    end
                    3'b001: begin
                        if (red_A_r && red_B_r)
                            out <= (INPUT_PRIORITY == "A") ? {5'b0, ^A_r} : {5'b0, ^B_r};
                        else if (red_A_r) out <= {5'b0, ^A_r};
                        else if (red_B_r) out <= {5'b0, ^B_r};
                        else              out <= {3'b0, A_r ^ B_r};
                    end
                    3'b010: begin
                        if (FULL_ADDER == "ON") out <= A_r + B_r + cin_r;
                        else                    out <= A_r + B_r;
                    end
                    3'b011: out <= A_r * B_r;
                    3'b100: begin
                        if (dir_r) out <= {out[4:0], serial_r};
                        else       out <= {serial_r, out[5:1]};
                    end
                    3'b101: begin
                        if (dir_r) out <= {out[4:0], out[5]};
                        else       out <= {out[0], out[5:1]};
                    end
                    default: out <= 0;
                endcase
            end
        end
    end

endmodule
