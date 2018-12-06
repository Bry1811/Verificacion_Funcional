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
	logic lectura;
	logic Autorefresh;
	assign lectura=(~whitebox.cs && whitebox.ras && ~whitebox.cas && whitebox.we);
	assign Autorefresh=(~whitebox.cs && ~whitebox.ras && ~whitebox.cas && whitebox.we);
	covergroup programable_latency @(posedge lectura);
		cas_latency : coverpoint whitebox.Mode_register_cas {
			bins two ={2};
			bins three ={3};
		}
	endgroup : programable_latency
	covergroup Auto_refresh_latency @(posedge Autorefresh);
		Autorefresh : coverpoint whitebox.autorefresh_latency{
			bins posibles_valores = {[2:16]};
		}
	endgroup : Auto_refresh_latency
	programable_latency lat=new();
	Auto_refresh_latency lat_auto_refresh=new();
endmodule : covarage