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

class driver;

	virtual bus_interface driver_interface;

	scoreboard new_scoreboard;
	stimulus1 new_stimulus1;
	stimulus2 new_stimulus2;
	stimulus3 new_stimulus3;
	load_mode_register new_load_mode_register;
	refresh_register new_refresh_register;	

	//--------------------------------------------
	// Signals for task Burst Write
	//--------------------------------------------
	int i;
	integer size_fifo;

	//--------------------------------------------
	// New function to create a driver block
	//--------------------------------------------
		function new(virtual bus_interface driver_interface,scoreboard new_scoreboard_ext, stimulus1 ext_stimulus1, stimulus2 ext_stimulus2,stimulus3 ext_stimulus3,
						load_mode_register new_load_mode_register_ext, refresh_register new_refresh_register_ext);
			begin
			this.driver_interface = driver_interface;
			this.new_scoreboard = new_scoreboard_ext;
			this.new_stimulus1 = ext_stimulus1;
			this.new_stimulus2 = ext_stimulus2;
			this.new_stimulus3 = ext_stimulus3;
			this.new_load_mode_register = new_load_mode_register_ext;
			this.new_refresh_register = new_refresh_register_ext;
			end
		endfunction
	
	//--------------------------------------------
	// Definition of reset task to reset SDRAM
	//--------------------------------------------
	task Reset();
	   driver_interface.ErrCnt         =0;
	   driver_interface.wb_addr_i      = 0;
	   driver_interface.wb_dat_i      = 0;
	   driver_interface.wb_sel_i       = 4'h0;
	   driver_interface.wb_we_i        = 0;
	   driver_interface.wb_stb_i       = 0;
	   driver_interface.wb_cyc_i       = 0;
	   driver_interface.RESETN    = 1'h1;
	   new_scoreboard.order_size_read = 0;
	   new_scoreboard.order_size_write = 0;

	   #100
	   // Applying reset
	   driver_interface.RESETN    = 1'h0;
	   #100000;
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
	// Definition of burst_write task to write SDRAM
	//--------------------------------------------
	task burst_write(logic [31:0] Address, logic [7:0]  bl);
	begin
		new_scoreboard.write_afifo_bfifo(Address,bl,size_fifo);
	 
		@ (negedge driver_interface.sys_clk);
		$display("Write Address: %x, Burst Size: %d",Address,bl);

		for(i=0; i < bl; i++) begin
			driver_interface.wb_stb_i        = 1;
			driver_interface.wb_cyc_i        = 1;
			driver_interface.wb_we_i         = 1;
			driver_interface.wb_sel_i        = 4'b1111;
			driver_interface.wb_addr_i       = Address[31:2]+i;
			driver_interface.wb_dat_i        = $random & 32'hFFFFFFFF;
			new_scoreboard.write_dfifo(driver_interface.wb_dat_i,i,size_fifo);

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
	
	//------------------------------------------------------------
	// Write full random address forcing a page crossover in SDRAM
	//------------------------------------------------------------
	task burst_write_page_crossover();
		void'(new_stimulus1.randomize());
		burst_write({8'h00,new_stimulus1.row,new_stimulus1.bank,new_stimulus1.column,2'b00},new_stimulus1.bl);
	endtask
	
	//--------------------------------------------
	// Write full random address in SDRAM
	//--------------------------------------------
	task burst_write_random();
		void'(new_stimulus2.randomize());
		this.burst_write({8'h00,new_stimulus2.row[7:0],new_stimulus2.bank,new_stimulus2.column[7:0],2'b00},new_stimulus2.bl);
	endtask
	
	//---------------------------------------------------------------
	// Write random column address in SDRAM with defined row and bank
	//---------------------------------------------------------------
	task burst_write_random_column(logic [11:0] row, logic [1:0] bank);
		void'(new_stimulus3.randomize());
		this.burst_write({8'h00,row,bank,new_stimulus3.column,2'b00},new_stimulus3.bl);
	endtask
	
	//---------------------------------------------------------------
	// Write in the Load Mode Register
	//---------------------------------------------------------------
	task write_load_mode_reg();
		void'(new_load_mode_register.randomize());
		driver_interface.burst_length=new_load_mode_register.burst_length;
		driver_interface.cas_latency=new_load_mode_register.cas_latency;
	endtask
	
	//---------------------------------------------------------------
	// Write in the Refresh Register
	//---------------------------------------------------------------
	task write_refresh_reg();
		void'(new_refresh_register.randomize());
		driver_interface.trcar_d=new_refresh_register.trcar_d;
		driver_interface.cfg_sdr_rfsh=new_refresh_register.cfg_sdr_rfsh;
		driver_interface.cfg_sdr_rfmax=new_refresh_register.cfg_sdr_rfmax;
	endtask
	
	
endclass
