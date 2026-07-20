module db_proc_top (
(* altera_attribute = "-name IO_STANDARD \"3.3-V LVCMOS\"", chip_pin = "E1"  *) 
input db_clk,

(* altera_attribute = "-name IO_STANDARD \"3.3-V LVCMOS\"", chip_pin = "J16"  *) 
input db_rst,

(* altera_attribute = "-name IO_STANDARD \"3.3-V LVCMOS\"", chip_pin = "J14"  *) 
input db_cmd_load,

(* altera_attribute = "-name IO_STANDARD \"3.3-V LVCMOS\"", chip_pin = "N16,N15,P16"  *) 
input [2:0] db_data_1,

(* altera_attribute = "-name IO_STANDARD \"3.3-V LVCMOS\"", chip_pin = "P15,R16"  *) 
input [1:0] db_data_0,

(* altera_attribute = "-name IO_STANDARD \"3.3-V LVCMOS\"", chip_pin = "N13,N14,M12"  *) 
input [2:0] db_instr,

(* altera_attribute = "-name IO_STANDARD \"3.3-V LVCMOS\"", chip_pin = "C3,A2,B3,A3,B4,A4,B5,A5" *)
output reg [7:0] leds
);

assign load_cmd = ~db_cmd_load;

parameter MEM_LEN = 54;
parameter LEDS_ADR = 53;
reg [(MEM_LEN - 1):0][11:0] load_data;

always_comb
begin
    `include "machine_code.txt"
    // load_data[31] = {11'b000_000_000_00,load_cmd};
    load_data[52] = {9'b000_000_000,db_data_1};
    load_data[51] = {10'b000_000_000_0,db_data_0};
    load_data[50] = {9'b000_000_000_0,db_instr};
  end

proc_top #(.MEM_LEN(MEM_LEN),.LEDS_ADR(LEDS_ADR)) proc_top_inst (
.clk(db_clk),
.rst(db_rst),
.load_data(load_data),
.resInMem(leds)
);

endmodule
