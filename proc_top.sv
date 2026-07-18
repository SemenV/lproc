module proc_top #(parameter MEM_LEN = 1) (
    input clk,
    input rst,
    input [(MEM_LEN - 1):0][11:0] load_data
);
wire [11:0] PC_o, PC_i;
assign PC_i = PC_o + 12'b1;

flopr_pc flopr_pc_inst(
.clk(clk),
.rst(rst),
.EN(),
.PC_i(PC_i),
.PC_o(PC_o)
);

mem #(.MEM_LEN(MEM_LEN)) mem_inst (
.clk(clk),
.rst(rst),
.wr(),
.adr(),
.din(),
.dout(),
.load_data()
);

flopr_i flopr_i_inst (
.clk(clk),
.rst(rst),
.instrWrite(),
.fi_din(),
.fi_dout()
);


regfile regfile_inst(
.clk(clk),
.rst(rst),
.we(),
.a0(),
.a1(),
.a2(),
.aw(),
.wd(),
.rd0(),
.rd1(),
.rd2()
);

control_unit control_unit_inst (
.clk(clk),
.rst(rst),
.opcode(),
.beq(),
.instrWrite(),
.regFileWr(),
.floprPcUpdate(),
.aluOp(),
.memAdr(),
.wdControl()
);

alu alu_inst (
.aluOp(),
.alu_0_i(),
.alu_1_i(),
.ALUResult()
);
endmodule
