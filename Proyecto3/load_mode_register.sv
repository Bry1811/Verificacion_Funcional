//////////////////////////////////////////////////////////////////////////
//College: Tecnologico de Costa Rica									//
//																		//
//Authors:																//
//		Bryan Gomez														//
//		Edgar Solera													//
// 																		//
//Curse: Functional Verification										//
//																		//
//Module Description:  Class to create a register for necessary		    //
// 					   variables for Programmable CAS latency 			//
//					   													//
//Details: Constrains range limits the random variables					//
//																		//
//Date: November 2018													//
//////////////////////////////////////////////////////////////////////////

class load_mode_register;

randc logic [2:0] burst_length;
randc logic [2:0] cas_latency ;

constraint range {
burst_length <= 3'h3;
burst_length >= 3'h2;
cas_latency <= 3'h3;
cas_latency >= 3'h2;
}

endclass 