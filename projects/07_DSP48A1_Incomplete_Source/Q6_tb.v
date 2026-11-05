module DSP_tb;

    reg [17:0] A, B, D;
    reg [47:0] C;
    reg clk, rst_n;
    wire [47:0] P;

    parameter OPERATION = "ADD";

    DSP #(.OPERATION(OPERATION)) dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .clk(clk),
        .rst_n(rst_n),
        .P(P)
    );

    reg [47:0] expected;
    integer i;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_n = 0;
        A = 0; B = 0; C = 0; D = 0;
        repeat(5) @(posedge clk);
        rst_n = 1;

        for (i = 0; i < 10; i = i + 1) begin
            @(posedge clk);

            A = $random;
            B = $random;
            D = $random;
            C = $random;

            if (OPERATION == "ADD")
                expected = (A * (D + B)) + C;
            else
                expected = (A * (D - B)) - C;

            repeat(4) @(posedge clk);

            if (P !== expected) begin
                $display("ERROR at time %t", $time);
                $display("A=%0d B=%0d D=%0d C=%0d", A, B, D, C);
                $display("Expected=%0d, Got=%0d", expected, P);
                $stop;
            end else begin
                $display("PASS at time %t | Result=%0d", $time, P);
            end
        end

        $display("All tests PASSED.");
        $stop;
    end

endmodule