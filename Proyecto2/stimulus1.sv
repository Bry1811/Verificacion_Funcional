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
//Module Description:  Class to create the row, column and burst 		//
//					 to cause a page crossover simulation				//
//					   													//
//Details: Page crossover simulation is controlled via constraints range//
//																		//
//Date: November 2018													//
//////////////////////////////////////////////////////////////////////////

//----------------------------------------
  // Address Decoding:
  //  with cfg_col bit configured as: 00
  //    <12 Bit Row> <2 Bit Bank> <8 Bit Column> <2'b00>
  //

class stimulus1;

rand logic [11:0] row;
rand logic [1:0]  bank;
rand logic [7:0] column;
rand logic [8:0]  bl;


constraint range {
column <= 8'hFF;
column >= 8'hE8;
bl >= 8'h08;
bl <= 8'h0F;
column + bl > 8'hFF;
}

endclass 