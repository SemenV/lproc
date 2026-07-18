module tb_proc_top ();

reg tb_clk = 0;
reg tb_rst = 1;
initial forever tb_clk = #5 ~tb_clk;

parameter MEM_LEN = 100;
reg [(MEM_LEN - 1):0][11:0] tb_load_data;

proc_top #(.MEM_LEN(MEM_LEN)) proc_top_inst (
.clk(tb_clk),
.rst(tb_rst),
.load_data(tb_load_data)
);

initial begin
  tb_rst <= 1;
  tb_load_data[0] <= 12'b000_001_000001;
  tb_load_data[1] <= 12'b000_010_000011;

  tb_load_data[2] <= 12'b011_100_001_010;

  tb_load_data[3] <= 12'b110_000_000_100;
  tb_load_data[4] <= 12'bx;
  tb_load_data[5] <= 12'bx;
  tb_load_data[6] <= 12'bx;
  tb_load_data[7] <= 12'bx;
  tb_load_data[8] <= 12'b101_111_001_010;
  tb_load_data[9] <= 12'b000_101_010100;
  tb_load_data[10] <= 12'b010_111_101_xxx;

  repeat (2) @(posedge tb_clk);
  tb_rst <= 0;

  repeat (100) @(posedge tb_clk);
  $finish();
end

endmodule
