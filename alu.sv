module alu (
input logic [1:0] aluOp,
input logic [11:0] alu_0_i,
input logic [11:0] alu_1_i,
input logic [11:0] alu_2_i,
output logic [11:0] ALUResult);


always_comb
  case (aluOp)
    default: ALUResult = 'b1;
  endcase


endmodule 