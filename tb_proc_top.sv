module tb_proc_top ();

reg tb_clk = 0;
reg tb_rst = 1;
initial forever tb_clk = #5 ~tb_clk;

parameter MEM_LEN = 54;
parameter LEDS_ADR = 53;
parameter INSTR_ADR = 50;
parameter DATA1_ADR = 51;
parameter DATA2_ADR = 52;
reg [(MEM_LEN - 1):0][11:0] load_data;

proc_top #(
.MEM_LEN(MEM_LEN),
.LEDS_ADR(LEDS_ADR),
.INSTR_ADR(INSTR_ADR),
.DATA1_ADR(DATA1_ADR),
.DATA2_ADR(DATA2_ADR)
) proc_top_inst (
.clk(tb_clk),
.rst(tb_rst),
.load_data(load_data),
.resInMem()
);



initial begin
  tb_rst <= 0;
  `include "machine_code.txt"
load_data[52] <= 12'b000_000_000_100;
  repeat (2) @(posedge tb_clk);
  tb_rst <= 1;

  repeat (500) @(posedge tb_clk);

load_data[52] <= 12'bx;
 repeat (500) @(posedge tb_clk);
  $finish();
end

endmodule
