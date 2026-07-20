module regfile(
input logic clk,
input wire rst,
input logic we,
input logic [2:0] a0,a1,a2,aw,
input logic [11:0] wd,
output logic [11:0] rd0,rd1,rd2
);

logic [7:0][11:0] rf;

always_ff @(posedge clk or negedge rst)
    if (~rst)
        rf <= '0;
    else
        if (we)
            rf[aw] <= wd;

assign rd0 = (a0 != 0 ) ? rf[a0] : 12'b0;
assign rd1 = (a1 != 0 ) ? rf[a1] : 12'b0;
assign rd2 = (a2 != 0) ? rf[a2] : 12'b0;

endmodule
