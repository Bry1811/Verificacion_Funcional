//////////////////////////////////////////////////////////////////////////
//College: Tecnologico de Costa Rica									//
//																		//
//Authors:																//
//		Bryan Gomez														//
//		Oscar Segura                                                    //
//		Edgard Solera													//
// 																		//
//Curse: Functional Verification										//
//																		//
//Module Description:  Scoreboard class for DRAM verification  			//
//																		//
//Details: Data, address and burst length fifo are initialized here		//
//																		//
//Date: October 2018													//
//////////////////////////////////////////////////////////////////////////

class scoreboard;

//-------------------------------------
// data/address/burst length FIFO
//-------------------------------------
	int dfifo[$]; // data fifo
	int afifo[$]; // address  fifo
	int bfifo[$]; // Burst Length fifo

endclass
