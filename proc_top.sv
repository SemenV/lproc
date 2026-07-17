module proc_top #(parameter MEM_LEN = 1) (
    input clk,
    input rst,
    input [(MEM_LEN - 1):0][11:0] load_data
);
wire [11:0] PC;
wire PCEn;
wire [11:0] mem_adr;
wire [11:0] PC_o;
wire [11:0] mem_dout;
wire [11:0] ALUResult;
wire instrWrite;
wire [2:0] aluOp;
wire floprPcUpdate;
wire regFileWr;
wire [11:0] fi_dout;
wire [11:0] PC_i;

assign PC_i = PC_o + 12'b1;


flopr_pc flopr_pc_inst(
.clk(clk),
.rst(rst),
.EN(floprPcUpdate),
.PC_i(PC_i),
.PC_o(PC_o)
);

mem #(.MEM_LEN(MEM_LEN)) mem_inst (
.clk(clk),
.rst(rst),
.wr(),
.adr(PC_o),
.din(),
.dout(mem_dout),
.load_data(load_data)
);

flopr_i flopr_i_inst (
.clk(clk),
.rst(rst),
.instrWrite(instrWrite),
.fi_din(mem_dout),
.fi_dout(fi_dout)
);

regfile regfile_inst(
.clk(clk),
.rst(rst),
.we(regFileWr),
.a0(),
.a1(),
.a2(),
.aw(fi_dout[8:6]),
.wd(ALUResult),
.rd0(),
.rd1(),
.rd2()
);

flopr_after_reg flopr_after_reg_inst (
.clk(),
.rst(),
.FARW(),
.far_din(),
.far_dout()
);

control_unit control_unit_inst (
.clk(clk),
.rst(rst),
.opcode(fi_dout[11:9]),
.instrWrite(instrWrite),
.regFileWr(regFileWr),
.floprPcUpdate(floprPcUpdate),
.aluOp(aluOp)
);

alu alu_inst (
.aluOp(aluOp),
.alu_0_i(fi_dout),
.alu_1_i(),
.alu_2_i(),
.ALUResult(ALUResult)
);
endmodule
