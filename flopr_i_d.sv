module flopr_i_d (
input logic clk,rst,
input logic write_i_d,
input logic [11:0] fid_din,
output logic [11:0] fid_dout);

always_ff @(posedge clk, posedge rst)
    if (rst) fid_dout <= 0;
    else
    if (write_i_d)
        fid_dout <= fid_din;

endmodule
