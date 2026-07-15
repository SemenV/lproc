module proc_top #(parameter MEM_LEN = 1) (
    input clk,
    input rst,
    input [(MEM_LEN - 1):0][11:0] load_data
);
reg [11:0] PC;
reg PCEn;
wire [11:0] mem_adr;
wire [11:0] mem_din;
wire [11:0] mem_dout;
wire [11:0] instr_dout;
wire [11:0] rd0;
wire mem_write;
wire instrWrite;
reg regFileWrite;
reg memWrite;
reg muxAdr;

flopr_pc flopr_pc_inst(
.clk(clk),
.rst(rst),
.EN(PCEn),
.PC_i(1'b1),
.PC_o(PC)
);

assign mem_adr = PC;

mem #(.MEM_LEN(MEM_LEN)) mem_inst (
.clk(clk),
.rst(rst),
.wr(mem_write),
.adr(mem_adr),
.din(mem_din),
.dout(mem_dout),
.load_data(load_data)
);

flopr_i flopr_i_inst (
.clk(clk),
.rst(rst),
.instrWrite(instrWrite),
.fi_din(mem_dout),
.fi_dout(instr_dout)
);

regfile regfile_inst(
.clk(clk),
.rst(rst),
.we(regFileWrite),
.a0(instr_dout[5:3]),
.a1(),
.aw(instr_dout[8:6]),
.wd({6'b0,instr_dout[5:0]}),
.rd0(rd0),
.rd1()
);

assign mem_adr = muxAdr ? rd0 : PC;

control_unit control_unit_inst (
.clk(clk),
.rst(rst),
.opcode(instr_dout[11:9]),
.regFileWrite(regFileWrite),
.instrWrite(instrWrite),
.PCEn(PCEn),
.memWrite(memWrite),
.muxAdr(muxAdr)
);


endmodule
