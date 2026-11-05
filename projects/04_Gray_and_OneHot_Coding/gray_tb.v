module gray_tb();
    reg [2:0] A;
    wire [6:0] B_dut;
    reg [6:0] B_expected;  
    extra_1 DUT(A, B_dut);  

    integer i;
    initial begin
        for (i = 0; i < 8; i = i+1) begin
            A = i;
            case (A)
            3'b000: B_expected = 3'b000;
            3'b001: B_expected = 3'b001;
            3'b010: B_expected = 3'b011;
            3'b011: B_expected = 3'b010;
            3'b100: B_expected = 3'b110;
            3'b101: B_expected = 3'b111;
            3'b110: B_expected = 3'b101;
            3'b111: B_expected = 3'b100;
            default: B_expected = 3'b000;
            endcase
            #10;
            if (B_expected != B_dut) begin
                $display("Error at time %0t: A=%b, B_dut=%b, B_expected=%b", $time, A, B_dut, B_expected);
                $stop;
            end
        end
        $display("Test completed successfully!");
        $stop;
    end
    
    initial
        $monitor("A = %b, B_dut = %b, B_expected = %b", A, B_dut, B_expected);
endmodule
