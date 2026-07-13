module flopr_i (
input logic clk,rst,
input logic instrWrite,
input logic [11:0] fi_din,
output logic [11:0] fi_dout);

always_ff @(posedge clk, posedge rst)
    if (rst) fi_dout <= 0;
    else
    if (instrWrite)
        fi_dout <= fi_din;

endmodule
