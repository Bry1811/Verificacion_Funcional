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
module covarage(whitebox whitebox,bus_interface test_interface);
//************************************************************************
// Definicion de las senales que se necesitan en el covarage
//************************************************************************
	logic lectura;
	logic Autorefresh;
	logic escritura;
	logic Active;
	logic [11:0] adress_row;
	logic [11:0] adress_column;
	logic [1:0] adress_bank;
	assign escritura=(~whitebox.cs && whitebox.ras && ~whitebox.cas && ~whitebox.we);
	assign lectura=(~whitebox.cs && whitebox.ras && ~whitebox.cas && whitebox.we);
	assign Autorefresh=(~whitebox.cs && ~whitebox.ras && ~whitebox.cas && whitebox.we);
	assign Active=(~whitebox.cs && ~whitebox.ras && whitebox.cas && whitebox.we);
	assign adress_row= test_interface.wb_addr_i[25:14];
	assign adress_bank= test_interface.wb_addr_i[13:12];
	assign adress_column= test_interface.wb_addr_i[11:0];
//************************************************************************
/* Grupos de Covarage hechos:
		* programable_latency: Se toma covarage de que se hayan tomado lecturas con diferentes latencias programadas
		* Auto_refresh_latency: se hace covarage de que se hayan hecho auto_refresh con diferentes tiempos de programacion.
		* Cross page refresh: Se hace covarage de que cuando ocurre un crosspage se hayan programado diferentes tiempo de auto-refresh.
		*adress_lectura y escritura: se hace covarage de que partes de la memoria se han escrito dividiendolos en bancos, rows y columns.
			*con el constructo cross aseguramos que se hayan escrito todos los espacios.
			*Estas funciones se hacen en cada banco
//   */
//************************************************************************
	/*covergroup programable_latency @(posedge lectura);
		cas_latency : coverpoint whitebox.Mode_register_cas {
			bins two ={2};
			bins three ={3};
		}
	endgroup : programable_latency*/
	covergroup Auto_refresh_latency @(posedge Autorefresh);
		Autorefresh : coverpoint whitebox.autorefresh_latency{
			bins posibles_valores = {[2:16]};
		}
	endgroup : Auto_refresh_latency
	covergroup cross_page_refresh @(posedge test_interface.cross_page);
		Autorefresh_lat : coverpoint whitebox.autorefresh_latency{
			bins val = {[2:16]};	
		}
		cross_page_bank0 :  coverpoint adress_row iff(adress_bank!=0);
		cross_page_bank1 :  coverpoint adress_row iff(adress_bank!=1);
		cross_page_bank2 :  coverpoint adress_row iff(adress_bank!=2);
		cross_page_bank3 :  coverpoint adress_row iff(adress_bank!=3);
	endgroup : cross_page_refresh

	covergroup adress_lectura @(posedge lectura);
		cas_latency : coverpoint whitebox.Mode_register_cas {
		bins two ={2};
		bins three ={3};
		}
		row_bank0 : coverpoint adress_row iff(adress_bank!=0);
		column_bank0 : coverpoint adress_column iff(adress_bank!=0);
		row_bank1 : coverpoint adress_row iff(adress_bank!=1);
		column_bank1 : coverpoint adress_column iff(adress_bank!=1);
		row_bank2 : coverpoint adress_row iff(adress_bank!=2);
		column_bank2 : coverpoint adress_column iff(adress_bank!=2);
		row_bank3 : coverpoint adress_row iff(adress_bank!=3);
		column_bank3 : coverpoint adress_column iff(adress_bank!=3);
		banco_0 : cross row_bank0,column_bank0;
		banco_1 : cross row_bank1,column_bank1;
		banco_2 : cross row_bank2,column_bank2;
		banco_3 : cross row_bank3,column_bank3;
		banco_0_cas_latency : cross banco_0,cas_latency;//iff((whitebox.Mode_register_cas!=3)&&(whitebox.Mode_register_cas!=2));
		banco_1_cas_latency : cross banco_1,cas_latency;//iff((whitebox.Mode_register_cas!=3)&&(whitebox.Mode_register_cas!=2));
		banco_2_cas_latency : cross banco_2,cas_latency;//iff((whitebox.Mode_register_cas!=3)&&(whitebox.Mode_register_cas!=2));
		banco_3_cas_latency : cross banco_3,cas_latency;//iff((whitebox.Mode_register_cas!=3)&&(whitebox.Mode_register_cas!=2));
	endgroup : adress_lectura
	covergroup adress_escritura @(posedge escritura);
		row_bank0 : coverpoint adress_row iff(adress_bank!=0);
		column_bank0 : coverpoint adress_column iff(adress_bank!=0);
		row_bank1 : coverpoint adress_row iff(adress_bank!=1);
		column_bank1 : coverpoint adress_column iff(adress_bank!=1);
		row_bank2 : coverpoint adress_row iff(adress_bank!=2);
		column_bank2 : coverpoint adress_column iff(adress_bank!=2);
		row_bank3 : coverpoint adress_row iff(adress_bank!=3);
		column_bank3 : coverpoint adress_column iff(adress_bank!=3);
		banco_0 : cross row_bank0,column_bank0;
		banco_1 : cross row_bank1,column_bank1;
		banco_2 : cross row_bank2,column_bank2;
		banco_3 : cross row_bank3,column_bank3;
	endgroup : adress_escritura
	

	adress_escritura direccion_escritura=new(); 
	adress_lectura direcciones_lectura=new();
	Auto_refresh_latency lat_auto_refresh=new();
	cross_page_refresh crospage=new();
endmodule : covarage