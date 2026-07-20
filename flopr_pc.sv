module flopr_pc(
input logic clk,rst,
input logic EN,
input logic [11:0] PC_i,
output reg [11:0] PC_o
);

always_ff @(posedge clk or negedge rst)
begin
    if (~rst) PC_o <= 12'b0;
	 else
    if (EN)
        PC_o <= PC_i;
end
endmodule
