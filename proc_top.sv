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
wire [11:0] wd;
wire [11:0] rd0,rd1,rd2;
wire FARW;
wire [11:0] memAdrIn;
wire [1:0] memAdrInChoise;
wire [11:0] far_out_0;

assign PC_i = PC_o + 12'b1;
assign memAdrIn = PC_i;

flopr_pc flopr_pc_inst(
.clk(clk),
.rst(rst),
.EN(floprPcUpdate),
.PC_i(memAdrIn),
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

assign wd = ALUResult;

regfile regfile_inst(
.clk(clk),
.rst(rst),
.we(regFileWr),
.a0(fi_dout[5:3]),
.a1(),
.a2(),
.aw(fi_dout[8:6]),
.wd(wd),
.rd0(rd0),
.rd1(rd1),
.rd2(rd2)
);

// flopr_after_reg flopr_after_reg_inst (
// .clk(),
// .rst(),
// .FARW(FARW),
// .far_din_0(rd0),
// .far_dout_0(far_out_0),

// .far_din_1(rd1),
// .far_dout_1(),

// .far_din_2(rd2),
// .far_dout_0()
// );

control_unit control_unit_inst (
.clk(clk),
.rst(rst),
.opcode(fi_dout[11:9]),
.instrWrite(instrWrite),
.regFileWr(regFileWr),
.floprPcUpdate(floprPcUpdate),
.aluOp(aluOp)
// .FARW(FARW)
);

alu alu_inst (
.aluOp(aluOp),
.alu_0_i(fi_dout),
.alu_1_i(),
.alu_2_i(),
.ALUResult(ALUResult)
);
endmodule
