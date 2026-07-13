module tb_proc_top ();

reg tb_clk = 0;
reg tb_rst = 1;
initial forever tb_clk = #5 ~tb_clk;

parameter MEM_LEN = 100;
reg [MEM_LEN:0][11:0] tb_load_data;

proc_top #(.MEM_LEN(MEM_LEN)) proc_top_inst (
.clk(tb_clk),
.rst(tb_rst),
.load_data(tb_load_data)
);

initial begin
  tb_rst <= 1;
  tb_load_data[0] <= 12'bxxx_011_110011;
  repeat (2) @(posedge tb_clk);
  tb_rst <= 0;

  repeat (100) @(posedge tb_clk);
  $finish();
end

endmodule

//do nor work random becouse of license

// class random_gen #(WIDTH = 0);
//   logic [11:0] r;
//   static integer m1;
//   static integer m2;
//   logic [21:0][11:0] all_rand_vals = {
//     1,54,6,5,23,35423,523,5,423,524,24,52,34523,54,23,52,35,
//     9567,4,55,0,5,875,8654,76,37,9,5,5234,5423,25,31,7,1,
//     523,8756,87,542523425,52325235,74578568,764343564,
//     2534859,52136537,152367475,2525365,62325657,5423523
//     };
//   function new(integer m1, integer m2);
//     this.m1 = m1;
//     this.m2 = m2;
//   endfunction

//   function logic [11:0] my_random();
//     m2 = m1 * m2[18:0];
//     m1 = m2[31:9] * m1;
//     return all_rand_vals[m1];
//   endfunction

//   function logic [11:0] rand_4_reg();
//   endfunction

// endclass

// class cmd_ll;
//   virtual mem_data_if mem_data_con;
//   static random_gen #(6) rand_ll_data = new();
//   static random_gen #(3) rand_ll_reg_adr = new();

//   function new(integer seed1 = 1,integer seed2 = 1,virtual mem_data_if mem_data_con);
//     rand_ll_data.srandom(seed1);
//     rand_ll_reg_adr.srandom(seed2);
//     this.mem_data_con = mem_data_con;
//   endfunction

//   task gen();
//     static reg [MEM_LEN:0] line_num = 0;
//     reg [11:0] cmd = {
//       3'b000,
//       rand_ll_reg_adr.randomize() with {r > 0;},
//         rand_ll_data.randomize()
//     };
//     $display("Comand = act = %3b reg = %3b lower = %6b", cmd[11:0],cmd[8:6],cmd[5:0]);
//     mem_data_con.tb_load_data[line_num] = cmd;
//     line_num = line_num + 1;
//   endtask

// endclass


// cmd_ll cmd_ll_test = new(1,1,mem_data_con);
