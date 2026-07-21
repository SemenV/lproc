module mem #(
  MEM_LEN = 1,
  LEDS_ADR = 0,
  INSTR_ADR = 0,
  DATA1_ADR = 0,
  DATA2_ADR = 0
  ) (
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
      case (adr)
        INSTR_ADR,DATA1_ADR,DATA2_ADR: mem[adr] <= load_data[adr];
        default: mem[adr] <= din;
      endcase

always_comb begin
    case (adr)
      INSTR_ADR,DATA1_ADR,DATA2_ADR: dout = load_data[adr];
      default: dout = mem[adr];
    endcase
  end

assign resInMem = mem[LEDS_ADR];
endmodule
