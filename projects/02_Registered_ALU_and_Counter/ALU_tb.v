module ALU_tb();
reg[3:0]A,B;
reg[1:0]opcode;
reg rst,clk;
wire[7:0] out;
reg [7:0] out_expected;
ALU dut (.A(A),.B(B),.opcode(opcode),.out(out),.clk(clk),.rst(rst));
initial begin 
        clk=0;
        forever 
          begin 
            #5 clk=~ clk ;
          end
end
initial begin 
       rst=1'b0;
       A=4'b0000;
       B=4'b0000;
       opcode=2'b00;
       out_expected<= 8'b00000000;
   	   
repeat(2)@(negedge clk);
   rst=1'b1;
repeat (30)begin
   A=$random ;
   B=$random;
   opcode=$random;
          case(opcode)
         2'b00: out_expected<= A + B;
         2'b01: out_expected<= A* B;
         2'b10: out_expected<= A | B;
         2'b11: out_expected<= A& B;
  
      endcase 
	repeat(2)@(negedge clk);
    if (out!=out_expected) begin
      $display("somthing is wrong");
    $stop;
    end
    
    
end 
$stop ;
end 
endmodule