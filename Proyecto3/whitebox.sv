//////////////////////////////////////////////////////////////////////////
//College: Tecnologico de Costa Rica									//
//																		//
//Authors:																//
//		Bryan Gomez														//
//		Edgar Solera													//
// 																		//
//Curse: Functional Verification										//
//																		//
//Module Description:  Interface definition for SDRC_CORE		 		//
//					   													//
//Details: This contains inter signals from DUV							//
//																		//
//Date: November 2018													//
//////////////////////////////////////////////////////////////////////////

`define DUT tb_top.u_dut.u_sdrc_core

interface whitebox();
	logic cke;
	logic cs;
	logic ras;
	logic cas;
	logic we;
	logic clk; 
	logic [12:0] addr;
	logic reset_n;
	logic rd_valid;
	logic [2:0] cfg_sdr_cas;
	logic [11:0] cfg_sdr_rfsh;
	logic x2b_refresh;
	logic [7:0] dq;
	logic page_ovflw;
	logic [2:0]  rfsh_row_cnt;
	logic [11:0]  rfsh_timer;
 	logic [11:0] rfsh_time;
	logic [12:0] max_r2b_len;
	logic [8:0] req_len_int;
	logic reset;
	logic resetRAM;
	logic sys_clk;
	logic cyc_o;
	logic stb_o;
	logic ack_o;
	logic sdr_init_done;
	logic dataout_en;

	assign dataout_en= tb_top.u_sdram16.Data_out_enable;
	assign cke = `DUT.sdr_cke;
	assign cs = `DUT.sdr_cs_n;
	assign ras = `DUT.sdr_ras_n;
	assign cas = `DUT.sdr_cas_n;
	assign we = `DUT.sdr_we_n;
	assign clk = tb_top.sdram_clk_d;
  	assign addr = `DUT.sdr_addr;
  	assign reset_n = `DUT.reset_n;
	assign rd_valid = `DUT.app_rd_valid;
	assign cfg_sdr_cas = `DUT.cfg_sdr_cas;
	assign cfg_sdr_rfsh = `DUT.cfg_sdr_rfsh;
	assign x2b_refresh = `DUT.u_xfr_ctl.x2b_refresh; // We did a refresh
	assign page_ovflw =`DUT.u_req_gen.page_ovflw;
	assign dq = tb_top.u_sdram16.dq;
  	assign rfsh_row_cnt = `DUT.u_xfr_ctl.rfsh_row_cnt;
  	assign rfsh_timer = `DUT.u_xfr_ctl.rfsh_timer;
  	assign rfsh_time = `DUT.u_req_gen.max_r2b_len;
	assign req_len_int = `DUT.u_req_gen.req_len_int;
	assign reset= tb_top.u_dut.wb_rst_i; 
	assign resetRAM= tb_top.u_dut.sdram_resetn;
	assign sys_clk = tb_top.u_dut.wb_clk_i; 
	assign cyc_o = tb_top.u_dut.wb_cyc_i;
	assign stb_o = tb_top.u_dut.wb_stb_i;
	assign ack_o = tb_top.u_dut.wb_ack_o;	
	assign sdr_init_done = 	tb_top.u_dut.sdr_init_done;
endinterface
