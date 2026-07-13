module proc_top #(parameter MEM_LEN = 1) (
    input clk,
    input rst,
    input [MEM_LEN:0][11:0] load_data
);
reg [11:0] PC;
reg PCEn;
wire [11:0] mem_adr;
wire [11:0] mem_din;
wire [11:0] mem_dout;
wire [11:0] instr_dout;
reg mem_write = 0;
reg instrWrite = 0;
reg regFileWrite = 0;

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
.a1(),
.a2(),
.aw(instr_dout[8:6]),
.wd({6'b0,instr_dout[5:0]}),
.rd1(),
.rd2()
);

control_unit control_unit_inst (
.clk(clk),
.rst(rst),
.opcode(instr_dout[11:9]),
.regFileWrite(regFileWrite),
.instrWrite(instrWrite),
.PCEn(PCEn)
);


endmodule
