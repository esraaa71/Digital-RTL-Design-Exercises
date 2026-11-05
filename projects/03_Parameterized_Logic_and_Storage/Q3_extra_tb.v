module Q3_extra_tb();
  
    reg D;
    reg [1:0] S;
    wire [3:0] y_dut;     
    reg [3:0] y_expected;  

    Q3_extra DUT(D, S, y_dut);  

    integer i, j;
    initial begin
        for (i = 0; i < 4; i = i+1) begin
            S = i;
            for (j = 0; j < 2; j = j+1) begin
                D = j;
                case (S)
                2'b00: y_expected = {3'b000, D};
                2'b01: y_expected = {2'b00, D, 1'b0};
                2'b10: y_expected = {1'b0, D, 2'b00};
                2'b11: y_expected = {D, 3'b000};
                endcase
                #10;
                if (y_dut != y_expected) begin
                    $display("Error at time %0t: S=%b, D=%b, y_dut=%b, y_expected=%b", $time, S, D, y_dut, y_expected);
                    $stop;
                end
            end
        end
        $display("Test completed successfully!");
        $stop;
    end

    initial
        $monitor("S = %b, D = %b, y_dut = %b, y_expect = %b", S, D, y_dut, y_expected);
endmodule
