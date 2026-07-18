module alu (
input logic [2:0] aluOp,
input logic [11:0] alu_0_i,
input logic [11:0] alu_1_i,
output logic [11:0] ALUResult);


always_comb
  case (aluOp)
    0: ALUResult = {6'b0,alu_0_i[5:0]};
    1: ALUResult = alu_1_i;
    default: ALUResult = 'b1;
  endcase


endmodule 