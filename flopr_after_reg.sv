module flopr_after_reg (
input logic clk,rst,
input logic FARW,
input logic [11:0] far_din_0,far_din_1,far_din_2,
output logic [11:0] far_dout_0,far_dout_1,far_dout_2);

always_ff @(posedge clk, posedge rst)
    if (rst) begin
        far_dout_0 <= 0;
        far_dout_1 <= 0;
        far_dout_2 <= 0;
    end
    else
    if (FARW) begin
        far_dout_0 <= far_din_0;
        far_dout_1 <= far_din_1;
        far_dout_2 <= far_din_2;
    end

endmodule
