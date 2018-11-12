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
//Module Description:  Environment class for DRAM verification  		//
//																		//
//Details: Joint the driver, scoreboard and monitor classes				//
//																		//
//Date: October 2018													//
//////////////////////////////////////////////////////////////////////////

//************************************************************************
// The "ifndef" function is needed in compilation to avoid two  
// times definition for the same module.
// These "include"  is needed to define a previous module compilation.
//************************************************************************

class environment;

	driver tb_driver;
	monitor tb_monitor;
	scoreboard tb_scoreboard;
	stimulus1 tb_stimulus1;
	stimulus2 tb_stimulus2;
	stimulus3 tb_stimulus3;

	virtual bus_interface environment_interface;

	function new(virtual bus_interface environment_interface);
	begin
		this.tb_scoreboard=new();
		this.environment_interface = environment_interface;
		this.tb_stimulus1=new();
		this.tb_stimulus2=new();
		this.tb_stimulus3=new();
		this.tb_monitor=new(this.environment_interface,this.tb_scoreboard);
		this.tb_driver=new(this.environment_interface,this.tb_scoreboard,this.tb_stimulus1,this.tb_stimulus2,this.tb_stimulus3);
	end
	endfunction

endclass
