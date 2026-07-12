module proc_top (
    input clk,
    input rst
);
reg [11:0] PC;
reg PC_en;
wire [11:0] mem_adr;
wire [11:0] mem_din;
wire [11:0] mem_dout;
wire [11:0] instr_dout;
reg mem_write = 0;
reg instr_write = 0;
reg reg_file_write = 0;

flopr_pc flopr_pc_inst(
.clk(clk),
.rst(rst),
.EN(PC_en),
.PC_i(1'b1),
.PC_o(PC)
);

assign mem_adr = PC;

mem mem_inst (
.clk(clk),
.rst(rst),
.wr(mem_write),
.adr(mem_adr),
.din(mem_din),
.dout(mem_dout)
);

flopr_i flopr_i_inst (
.clk(clk),
.rst(rst),
.instr_write(instr_write),
.fi_din(mem_dout),
.fi_dout(instr_dout)
);

regfile regfile_inst(
.clk(clk),
.rst(rst),
.we(reg_file_write),
.a1(),
.a2(),
.aw(instr_dout[8:6]),
.wd({6'b0,instr_dout[5:0]}),
.rd1(),
.rd2()
);

typedef enum {st_fetch,st_regfile_w,st_pc} states_t;
states_t state,nexst_state;

always_ff @(posedge clk)
  if (rst) state <= st_fetch;
  else state <= nexst_state;

always_comb begin
  nexst_state = st_fetch;
  reg_file_write = 0;
  instr_write = 0;
  PC_en = 0;
  unique case(state)
    st_pc: begin
      nexst_state = st_fetch;
      instr_write = 0;
      reg_file_write = 0;
      PC_en = 1;
    end
    st_fetch: begin
      nexst_state = st_regfile_w;
      instr_write = 1;
      reg_file_write = 0;
      PC_en = 0;
    end
    st_regfile_w: begin
      nexst_state = st_pc;
      instr_write = 0;
      reg_file_write = 1;
      PC_en = 0;
    end
  endcase
end


endmodule
