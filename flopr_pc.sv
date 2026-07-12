module flopr_pc(
input logic clk,rst,
input logic EN,
input logic [11:0] PC_i,
output logic [11:0] PC_o
);

always_ff @(posedge clk, posedge rst)
    if (rst) PC_o <= 0;
    else
    if (EN)
        PC_o <= PC_o + PC_i;

endmodule
