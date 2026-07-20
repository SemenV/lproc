module mem #(MEM_LEN = 1,LEDS_ADR = 0) (
input wire clk,
input wire rst,
input wire wr,
input wire [11:0] adr,
output reg [11:0] dout,resInMem,
input wire [11:0] din,
input wire [(MEM_LEN - 1):0][11:0] load_data
);

reg [(MEM_LEN - 1):0][11:0] mem ;


always_ff @(posedge clk or negedge rst)
  if (~rst)
    mem <= load_data;
  else
    if (wr)
      mem[adr] <= din;

assign dout = mem[adr];
assign resInMem = mem[LEDS_ADR];

endmodule
