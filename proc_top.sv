module proc_top #(parameter MEM_LEN = 1) (
    input clk,
    input rst,
    input [(MEM_LEN - 1):0][11:0] load_data
);
wire [11:0] PC;
wire PCEn;
wire [11:0] mem_adr;
wire [11:0] mem_din;
wire [11:0] mem_dout;
wire [11:0] instr_dout;
wire [11:0] rd0,rd1,rd2;
wire [1:0] aluOp;
wire [11:0] ALUResult;
wire mem_write;
wire instrWrite;
wire regFileWrite;
wire memWrite;
wire muxAdr;
wire [11:0] PC_i;
wire pcNewVal;
wire beq;



flopr_pc flopr_pc_inst(
.clk(clk),
.rst(rst),
.EN(),
.PC_i(),
.PC_o()
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
.regFileWrite(),
.instrWrite(),
.PCEn(),
.memWrite(),
.muxAdr(),
.aluOp(),
.pcNewVal(),
.beq()
);

alu alu_inst (
.aluOp(),
.alu_0_i(),
.alu_1_i(),
.alu_2_i(),
.ALUResult()
);
endmodule
