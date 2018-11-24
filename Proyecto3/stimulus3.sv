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
//Module Description:  Class to create random writing in SDRAM creating //
//					   row, column and burst 							//
//					   													//
//Details: Constrains range limits the burst variable					//
//																		//
//Date: November 2018													//
//////////////////////////////////////////////////////////////////////////

//----------------------------------------
  // Address Decoding:
  //  with cfg_col bit configured as: 00
  //    <12 Bit Row> <2 Bit Bank> <8 Bit Column> <2'b00>
  //

class stimulus3;

rand logic [7:0] column;
rand logic [7:0]  bl;

constraint range {
bl <= 8'h07;
bl > 8'h00; 
}

endclass