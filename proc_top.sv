module proc_top #(
    MEM_LEN = 1,
    LEDS_ADR = 0,
    INSTR_ADR = 0,
    DATA1_ADR = 0,
    DATA2_ADR = 0
    ) (
    input clk,
    input rst,
    input [(MEM_LEN - 1):0][11:0] load_data,
    output [11:0] resInMem
);
wire [11:0] PC_o, PC_i;
wire [11:0] mem_dout;
wire [11:0] Instr;
wire [11:0] ALUResult;
wire [11:0] mux1_data,mux2_data;
wire [11:0] mux0_adr;
wire [11:0] rd0,rd1,rd2;
wire [11:0] fd_dout;
wire [2:0] aluOp;

wire floprPcUpdate,floprPcMUX,regFileWr,instrWrite,memWrite,dataTMPWr,mux0,mux1,mux2;

assign PC_i = floprPcMUX ? ALUResult : PC_o + 12'b1;

flopr_pc flopr_pc_inst(
.clk(clk),
.rst(rst),
.EN(floprPcUpdate),
.PC_i(PC_i),
.PC_o(PC_o)
);

assign mux0_adr = (mux0 == 0) ? PC_o : ALUResult;

mem #(
.MEM_LEN(MEM_LEN),
.LEDS_ADR(LEDS_ADR),
.INSTR_ADR(INSTR_ADR),
.DATA1_ADR(DATA1_ADR),
.DATA2_ADR(DATA2_ADR)
) mem_inst (
.clk(clk),
.rst(rst),
.wr(memWrite),
.adr(mux0_adr),
.din(rd1),
.dout(mem_dout),
.load_data(load_data),
.resInMem(resInMem)
);

flopr_i_d flopr_i_inst (
.clk(clk),
.rst(rst),
.write_i_d(instrWrite),
.fid_din(mem_dout),
.fid_dout(Instr)
);

flopr_i_d flopr_d_inst (
.clk(clk),
.rst(rst),
.write_i_d(dataTMPWr),
.fid_din(mem_dout),
.fid_dout(fd_dout)
);

regfile regfile_inst(
.clk(clk),
.rst(rst),
.we(regFileWr),
.a0(Instr[5:3]),
.a1(Instr[8:6]),
.a2(Instr[2:0]),
.aw(Instr[8:6]),
.wd(ALUResult),
.rd0(rd0),
.rd1(rd1),
.rd2(rd2)
);

control_unit control_unit_inst (
.clk(clk),
.rst(rst),
.opcode(Instr[11:9]),
.beq(rd0 == rd1),
.aluOp(aluOp),
.regFileWr(regFileWr),
.instrWrite(instrWrite),
.mux1(mux1),
.mux2(mux2),
.mux0(mux0),
.floprPcUpdate(floprPcUpdate),
.memWrite(memWrite),
.dataTMPWr(dataTMPWr),
.floprPcMUX(floprPcMUX)
);

assign mux1_data = (mux1 == 0) ? Instr[5:0] : rd0;
assign mux2_data = (mux2 == 0) ? rd2 : fd_dout;

alu alu_inst (
.aluOp(aluOp),
.alu_0_i(mux1_data),
.alu_1_i(mux2_data),
.ALUResult(ALUResult)
);
endmodule
