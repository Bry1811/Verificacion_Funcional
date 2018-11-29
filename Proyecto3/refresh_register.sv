//////////////////////////////////////////////////////////////////////////
//College: Tecnologico de Costa Rica									//
//																		//
//Authors:																//
//		Bryan Gomez														//
//		Edgar Solera													//
// 																		//
//Curse: Functional Verification										//
//																		//
//Module Description:  Class to create a register for necessary 	    //
// 					   variables for AutoRefresh						//
//					   													//
//Details: Constrains range limits the random variables					//
//																		//
//Date: November 2018													//
//////////////////////////////////////////////////////////////////////////

class refresh_register;

randc logic [3:0]  trcar_d;
randc logic [11:0] cfg_sdr_rfsh;
randc logic [2:0] cfg_sdr_rfmax;

constraint range {

trcar_d <= 4'hf;
trcar_d >= 4'h2;
cfg_sdr_rfsh >= 12'h100;
cfg_sdr_rfsh <= 12'hC35;
cfg_sdr_rfmax >= 3'h1;
cfg_sdr_rfmax <= 3'h7;

}

endclass 