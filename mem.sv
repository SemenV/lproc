module mem #(MEM_LEN = 1) (
input wire clk,
input wire rst,
input wire wr,
input wire [11:0] adr,
output reg [11:0] dout,
input wire [11:0] din,
input wire [(MEM_LEN - 1):0][11:0] load_data
);

reg [(MEM_LEN - 1):0][11:0] mem ;


always_ff @(posedge clk)
  if (rst)
    mem[adr] <= load_data;
  else
    if (wr)
      mem[adr] <= din;

assign dout = mem[adr];

endmodule
