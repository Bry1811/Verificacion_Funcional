//////////////////////////////////////////////////////////////////////////
//College: Tecnologico de Costa Rica									//
//																		//
//Authors:																//
//		Bryan Gomez														//
//		Edgar Solera													//
// 																		//
//Curse: Functional Verification										//
//																		//
//Module Description:  Driver class for DRAM verification  				//
//					   													//
//Details: Connects the SDRAM controller with the environment checkers,	//
//		   give the correct initialization to SDRAM (reset signal)		//
//		   Help with the writing ad reading in memory. Give the correct.//
//																		//
//Date: November 2018													//
//////////////////////////////////////////////////////////////////////////

//************************************************************************
// The "ifndef" function is needed in compilation to avoid two  
// times definition for the same module.
// These "include"  is needed to define a previous module compilation.
//************************************************************************
module covarage(whitebox whitebox);
//	virtual bus_interface driver_interface;
//	virtual whitebox internal_signals;
//	function new(virtual bus_interface driver_interface,virtual whitebox internal_signals);
//			begin
//			this.driver_interface = driver_interface;
//			this.internal_signals= internal_signals;
//			end
//		endfunction
	logic lectura = (~whitebox.cs && whitebox.ras && ~whitebox.cas && whitebox.we) ;
	covergroup programable_latency @(posedge lectura);
		cas_latency : coverpoint whitebox.Mode_register_cas {
			bins two ={2};
			bins three ={3};
		}
	   	
	endgroup : programable_latency
endmodule : covarage