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
//Module Description:  Driver class for DRAM verification  				//
//					   													//
//Details: Connects the SDRAM controller with the environment checkers,	//
//		   give the correct initialization to SDRAM (reset signal)		//
//		   Help with the writing ad reading in memory. Give the correct.//
//																		//
//Date: October 2018													//
//////////////////////////////////////////////////////////////////////////

//************************************************************************
// The "ifndef" function is needed in compilation to avoid two  
// times definition for the same module.
// These "include"  is needed to define a previous module compilation.
//************************************************************************

class driver;

	virtual bus_interface driver_interface;

	scoreboard new_scoreboard;

	//--------------------------------------------
	// Signals for task Burst Write
	//--------------------------------------------
	int i;

	//--------------------------------------------
	// New function to create a driver block
	//--------------------------------------------
		function new(virtual bus_interface driver_interface,scoreboard new_scoreboard_ext);
			begin
			this.driver_interface = driver_interface;
			this.new_scoreboard = new_scoreboard_ext;
			end
		endfunction
	
	//--------------------------------------------
	// Definition of reset task to reset SDRAM
	//--------------------------------------------
	task Reset;
	   driver_interface.ErrCnt         =0;
	   driver_interface.wb_addr_i      = 0;
	   driver_interface.wb_dat_i      = 0;
	   driver_interface.wb_sel_i       = 4'h0;
	   driver_interface.wb_we_i        = 0;
	   driver_interface.wb_stb_i       = 0;
	   driver_interface.wb_cyc_i       = 0;
	   driver_interface.RESETN    = 1'h1;

	   #100
	   // Applying reset
	   driver_interface.RESETN    = 1'h0;
	   #10000;
	   // Releasing reset
	   driver_interface.RESETN    = 1'h1;

	   // driver_interface.RESETN    = 1'h0;
	   // #10000;
	   //Releasing reset
	   // driver_interface.RESETN    = 1'h1;
	   #1000;
	   wait(driver_interface.sdr_init_done == 1);
	   #1000;
	endtask
	//--------------------------------------------
	// Definition of burst_read task to read SDRAM
	//--------------------------------------------
	task burst_write(logic [31:0] Address, logic [7:0]  bl);
	begin
	  new_scoreboard.afifo.push_back(Address);
	  new_scoreboard.bfifo.push_back(bl);

	   @ (negedge driver_interface.sys_clk);
	   $display("Write Address: %x, Burst Size: %d",Address,bl);

	   for(i=0; i < bl; i++) begin
		  driver_interface.wb_stb_i        = 1;
		  driver_interface.wb_cyc_i        = 1;
		  driver_interface.wb_we_i         = 1;
		  driver_interface.wb_sel_i        = 4'b1111;
		  driver_interface.wb_addr_i       = Address[31:2]+i;
		  driver_interface.wb_dat_i        = $random & 32'hFFFFFFFF;
		  new_scoreboard.dfifo.push_back(driver_interface.wb_dat_i);

		  do begin
			  @ (posedge driver_interface.sys_clk);
		  end while(driver_interface.wb_ack_o == 1'b0);
			  @ (negedge driver_interface.sys_clk);
	   
		   $display("Status: Burst-No: %d  Write Address: %x  WriteData: %x ",i,driver_interface.wb_addr_i,driver_interface.wb_dat_i);
	   end
	   driver_interface.wb_stb_i        = 0;
	   driver_interface.wb_cyc_i        = 0;
	   driver_interface.wb_we_i         = 'hx;
	   driver_interface.wb_sel_i        = 'hx;
	   driver_interface.wb_addr_i       = 'hx;
	   driver_interface.wb_dat_i        = 'hx;
	end
	endtask

endclass
