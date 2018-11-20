//////////////////////////////////////////////////////////////////////////
//College: Tecnologico de Costa Rica									//
//																		//
//Authors:																//
//		Bryan Gomez														//
//		Oscar Segura                                                    //
//		Edgar Solera													//
// 																		//
//Curse: Functional Verification										//
//																		//
//Module Description:  Assertion module for DRAM verification  			//
//																		//
//Details: Initialization for SDRAM and some rules for WISHBONE protocol//
//		   are testing using assertions									//
//																		//
//Date: November 2018													//
//////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
module assertions(whitebox whitebox);

// SDRAM must be powered up and initialized in a predefined manner. Operational
// procedures other than those specified may result in undefined operation. Once power is
// applied to VDD and the clock is stable, the SDRAM requires a 100 us delay prior to
// issuing any command other than a COMMAND INHIBIT or NOP. Starting at some point
// during this 100 us period and continuing at least through the end of this period,
// COMMAND INHIBIT or NOP commands should be applied.

// Once the 100 us delay has been satisfied with at least one COMMAND INHIBIT or NOP
// command having been applied, a PRECHARGE command should be applied. All device
// banks must then be precharged, thereby placing the device in the all banks idle state.
// Once in the idle state, two AUTO REFRESH cycles must be performed. After two
// refresh cycles are complete, SDRAM ready for mode register programming. Because the
// mode registers will power up in unknown state, it should be loaded prior to applying any
// operational command.

//--------------------------------------------
//					||  CS | RAS | CAS |  WE |
//-------------------------------------------	
//COMMAND INHIBIT  	||  H  |  X  |  X  |  X  |
//NOP              	||  L  |  H  |  H  |  H  |
//ACTIVE		||  L  |  L  |  H  |  H  |
//AUTO_REFRESH     	||  L  |  L  |  L  |  H  |
//PRECHARGE        	||  L  |  L  |  H  |  L  |
//LOAD_MOD_REG     	||  L  |  L  |  L  |  L  |
//--------------------------------------------

sequence inhibit_or_nop;
//CLK Period = 20 ns por tanto 100us / 20ns = 5000 ciclos
	## [1:5000]  ((whitebox.cs) || (whitebox.ras && whitebox.cas && whitebox.we));// [*1:$];
endsequence

sequence precharge_init;
	## [5000:5008] (~whitebox.cs & ~whitebox.ras & whitebox.cas & ~whitebox.we);
endsequence

sequence auto_refresh;
	(~whitebox.cs && ~whitebox.ras && ~whitebox.cas && whitebox.we )[=2];
endsequence

sequence load_mode_reg;
	(~whitebox.cs && ~whitebox.ras && ~whitebox.cas && ~whitebox.we ) [=1];
endsequence

sequence rule335_seq;
	(whitebox.cyc_o && whitebox.stb_o);
endsequence

property rule300_prop;
  @ (posedge whitebox.sys_clk) 
      whitebox.reset  |=> (!$isunknown(whitebox.cs) and !$isunknown(whitebox.we) and !$isunknown(whitebox.ras) and !$isunknown(whitebox.cas));
endproperty

property rule305_prop;
  @ (whitebox.sys_clk) 
      $rose(whitebox.reset)   |=> (($past(whitebox.sys_clk,1) && whitebox.reset && !whitebox.sys_clk) or ($past(!whitebox.sys_clk,1) && whitebox.reset && whitebox.sys_clk));
endproperty

property rule325_prop;
	@ (posedge whitebox.sys_clk) 
		($rose(whitebox.cyc_o)   |=> whitebox.stb_o == 1) or ($fell(whitebox.cyc_o)   |=> whitebox.stb_o ==0);	
endproperty

property rule335_prop;
	@ (posedge whitebox.sys_clk) 
		$rose(whitebox.ack_o)   |=> rule335_seq;	
endproperty
	
property initialization;
	@(posedge whitebox.clk)
		$fell(whitebox.reset_n) |=> (inhibit_or_nop and precharge_init) |=> auto_refresh |=> load_mode_reg; 
endproperty

assertion_initialization: assert property (initialization) $display( "%t: SDRAM initialization has done successfully!!", $time);
else $error("Initialization has failed!");

rule300_assert : assert property (rule300_prop)$display;//( "%t: Rule 3.00 has check successfully!!", $time);
else $error("Rule 3.00 has check unsuccessfully!");

rule305_assert : assert property (rule305_prop)$display( "%t: Rule 3.05 has check successfully!!", $time);
else $error("Rule 3.05 has check unsuccessfully!");

always @(whitebox.reset) begin 
rule310_assert : assert ((whitebox.reset && !whitebox.resetRAM) || (!whitebox.reset && whitebox.resetRAM) )$display( "%t: Rule 3.10 has check successfully!!", $time);
else $error("Rule 3.10 has check unsuccessfully!");
end

rule325_assert : assert property (rule325_prop)$display;//( "%t: Rule 3.25 has check successfully!!", $time);
else $error("Rule 3.25 has check unsuccessfully!");

rule335_assert : assert property (rule335_prop)$display;//( "%t: Rule 3.35 has check successfully!!", $time);
else $error("Rule 3.35 has check unsuccessfully!");

endmodule