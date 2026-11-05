module ALU (A,B,opcode, rst,clk,out);
input[3:0]A,B;
input[1:0]opcode;
input rst, clk;
output reg [7:0] out;
reg [3:0] A_reg, B_reg;
reg [1:0]opcode_reg;
always @(posedge clk, negedge rst)
     if(!rst)begin
        A_reg<=4'b0000;
        B_reg<=4'b0000;             
        opcode_reg<=2'b00;
      end
      else begin
        A_reg<=A;
        B_reg<=B;             
        opcode_reg<=opcode;
      end 
always @(posedge clk, negedge rst)
     if(!rst)begin
        out<=0;
      end
     else 
       case(opcode)
         2'b00: out<= A_reg + B_reg;
         2'b01: out<= A_reg * B_reg;
         2'b10: out<= A_reg | B_reg;
         2'b11: out<= A_reg & B_reg;
      endcase 
endmodule 