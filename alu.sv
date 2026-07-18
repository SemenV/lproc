module alu (
input logic [2:0] aluOp,
input logic [11:0] alu_0_i,
input logic [11:0] alu_1_i,
output logic [11:0] ALUResult);


always_comb
  case (aluOp)
    3'b000: ALUResult = {6'b0,alu_0_i[5:0]};
    3'b001: ALUResult = alu_0_i;
    3'b010: ALUResult = alu_1_i;
    3'b011: ALUResult = alu_0_i << alu_1_i;
    3'b100: ALUResult = alu_0_i | alu_1_i;
    3'b101: ALUResult = alu_0_i & alu_1_i;
    3'b110: ALUResult = alu_1_i;
    3'b111: ALUResult = alu_0_i;
    default: ALUResult = 'bx;
  endcase


endmodule 