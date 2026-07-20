module tb_proc_top ();

reg tb_clk = 0;
reg tb_rst = 1;
initial forever tb_clk = #5 ~tb_clk;

parameter MEM_LEN = 54;
reg [(MEM_LEN - 1):0][11:0] load_data;

proc_top #(.MEM_LEN(MEM_LEN)) proc_top_inst (
.clk(tb_clk),
.rst(tb_rst),
.load_data(load_data),
.resInMem()
);

always_comb begin 
  `include "machine_code.txt"
end

initial begin
  tb_rst <= 0;

  repeat (2) @(posedge tb_clk);
  tb_rst <= 1;

  repeat (1000) @(posedge tb_clk);
  $finish();
end

endmodule
