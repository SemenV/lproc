module alu (
input logic [2:0] aluOp,
input logic [11:0] alu_0_i,
input logic [11:0] alu_1_i,
output logic [11:0] ALUResult);

reg signed [11:0] signedShift;

always_comb
  begin
  signedShift = 0;
  case (aluOp)
    3'b000: ALUResult = {6'b0,alu_0_i[5:0]};
    3'b001: ALUResult = alu_0_i;
    3'b010: ALUResult = alu_1_i;
    3'b011: begin
        signedShift = $signed(alu_1_i);
        if (signedShift >= 0)
          ALUResult = alu_0_i << signedShift;
        else
          ALUResult = alu_0_i << -signedShift;
      end
    3'b100: ALUResult = alu_0_i | alu_1_i;
    3'b101: ALUResult = alu_0_i & alu_1_i;
    3'b110: ALUResult = alu_1_i;
    3'b111: ALUResult = $signed(alu_0_i) + $signed(alu_1_i);
    default: ALUResult = 'bx;
  endcase
  end

endmodule 