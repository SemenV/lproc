module mem #(parameter adr_len = 10, mem_len = 20) (
input wire clk,
input wire rst,
input wire wr,
input wire [adr_len:0] adr,
output reg [11:0] dout,
input wire [11:0] din
);



reg [(mem_len - 1):0][11:0] mem ;


always_ff @(posedge clk)
    if (rst) begin
    mem[adr] <= 12'bxxx_011_110011;
    end
    else
        if (wr)
            mem[adr] <= din;

assign dout = mem[adr];

endmodule
