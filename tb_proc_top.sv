module tb_proc_top ();

reg tb_clk = 0;
reg tb_rst = 1;
initial forever tb_clk = #5 ~tb_clk;


proc_top proc_top_inst (
.clk(tb_clk),
.rst(tb_rst)
);

initial begin
    tb_rst <= 1;
    repeat (2) @(posedge tb_clk);
    tb_rst <= 0;
    repeat (100) @(posedge tb_clk);
    $finish();
end


endmodule
