`timescale 1ns/1ps

module ALSU_TB;

    reg        clk, rst;
    reg [2:0]  A, B, opcode;
    reg        cin, serial_in, red_op_A, red_op_B;
    reg        bypass_A, bypass_B, direction;
    wire [5:0]  out;
    wire [15:0] leds;

    ALSU DUT (
        .clk(clk), .rst(rst),
        .A(A), .B(B), .opcode(opcode),
        .cin(cin), .serial_in(serial_in),
        .red_op_A(red_op_A), .red_op_B(red_op_B),
        .bypass_A(bypass_A), .bypass_B(bypass_B),
        .direction(direction),
        .out(out), .leds(leds)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    integer i;
    reg [5:0] expected;

    initial begin
        // init
        rst = 1; A = 0; B = 0; opcode = 0; cin = 0;
        serial_in = 0; red_op_A = 0; red_op_B = 0;
        bypass_A = 0; bypass_B = 0; direction = 0;

        // 2.1 async reset check
        @(negedge clk);
        if (out !== 0 || leds !== 0)
            $display("Error: async reset failed");
        else
            $display("Pass: async reset");

        // 2.2 bypass
        bypass_A = 1; bypass_B = 1; rst = 0;
        repeat(20) begin
            A = $random; B = $random;
            opcode = $urandom_range(0, 5);
            repeat(2) @(negedge clk);
            if (out !== {3'b0, A})
                $display("Error: bypass A&B - out=%0h exp=%0h", out, {3'b0, A});
        end
        $display("Pass: bypass");

        // 2.3 opcode 0 AND
        bypass_A = 0; bypass_B = 0; opcode = 0;
        repeat(20) begin
            A = $random; B = $random;
            red_op_A = $random; red_op_B = $random;
            repeat(2) @(negedge clk);
            case ({red_op_A, red_op_B})
                2'b00: expected = {3'b0, A & B};
                2'b01: expected = {5'b0, &B};
                2'b10: expected = {5'b0, &A};
                2'b11: expected = {5'b0, &A};
            endcase
            if (out !== expected)
                $display("Error: AND - out=%0b exp=%0b", out, expected);
        end
        red_op_A = 0; red_op_B = 0;
        $display("Pass: opcode 0 AND");

        // 2.4 opcode 1 XOR
        opcode = 1;
        repeat(20) begin
            A = $random; B = $random;
            red_op_A = $random; red_op_B = $random;
            repeat(2) @(negedge clk);
            case ({red_op_A, red_op_B})
                2'b00: expected = {3'b0, A ^ B};
                2'b01: expected = {5'b0, ^B};
                2'b10: expected = {5'b0, ^A};
                2'b11: expected = {5'b0, ^A};
            endcase
            if (out !== expected)
                $display("Error: XOR - out=%0b exp=%0b", out, expected);
        end
        red_op_A = 0; red_op_B = 0;
        $display("Pass: opcode 1 XOR");

        // 2.5 opcode 2 Addition
        opcode = 2; red_op_A = 0; red_op_B = 0;
        repeat(20) begin
            A = $random; B = $random; cin = $random;
            repeat(2) @(negedge clk);
            if (out !== (A + B + cin))
                $display("Error: ADD - out=%0d exp=%0d", out, A+B+cin);
        end
        $display("Pass: opcode 2 Addition");

        // 2.6 opcode 3 Multiplication
        opcode = 3;
        repeat(20) begin
            A = $random; B = $random;
            repeat(2) @(negedge clk);
            if (out !== (A * B))
                $display("Error: MUL - out=%0d exp=%0d", out, A*B);
        end
        $display("Pass: opcode 3 Multiplication");

        // 2.7 opcode 4 Shift - check waveform
        opcode = 4;
        repeat(20) begin
            A = $random; B = $random;
            serial_in = $random; direction = $random;
            repeat(2) @(negedge clk);
        end
        $display("Check waveform for opcode 4 shift");

        // 2.8 opcode 5 Rotate - check waveform
        opcode = 5;
        repeat(20) begin
            A = $random; B = $random;
            serial_in = $random; direction = $random;
            repeat(2) @(negedge clk);
        end
        $display("Check waveform for opcode 5 rotate");

        $stop;
    end

endmodule
