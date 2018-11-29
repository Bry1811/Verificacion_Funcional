//////////////////////////////////////////////////////////////////////////
//College: Tecnologico de Costa Rica									//
//																		//
//Authors:																//
//		Bryan Gomez														//
//		Edgar Solera													//
// 																		//
//Curse: Functional Verification										//
//																		//
//Module Description:  Environment2 class for DRAM verification  		//
//																		//
//Details: Joint the driver, stimulus, scoreboard, assertions and		//
// 		   monitor classes												//
//																		//
//Date: November 2018													//
//////////////////////////////////////////////////////////////////////////

//************************************************************************
// The "ifndef" function is needed in compilation to avoid two  
// times definition for the same module.
// These "include"  is needed to define a previous module compilation.
//************************************************************************

`include "scoreboard.sv"
`include "monitor.sv"
`include "stimulus1.sv"
`include "stimulus2.sv"
`include "stimulus3.sv"
`include "load_mode_register.sv"
`include "refresh_register.sv"
`include "driver.sv"
`include "environment.sv"

class environment2 extends environment;

	virtual bus_interface environment2_interface;
	virtual whitebox whitebox_interface;

	//function new(virtual bus_interface environment2_interface,virtual whitebox whitebox_interface);
	function new(virtual bus_interface environment2_interface);
	begin
		this.environment2_interface = environment2_interface;
		//this.whitebox_interface = whitebox_interface;
		super.new(environment2_interface);

	end
	endfunction

endclass
	