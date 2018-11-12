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

class monitor;
	
	virtual bus_interface monitor_interface;
	scoreboard new_scoreboard;
	
	//--------------------------------------------
	// Signals for task Burst Read
	//--------------------------------------------
	reg [31:0] Address;
	reg [7:0]  bl;
	reg sdram_clk;


	int i,j;
	integer size_fifo;
	
	reg [31:0]   exp_data;

	//--------------------------------------------
	// New function to create a monitor block
	//--------------------------------------------

		function new(virtual bus_interface tb_monitor_interface, scoreboard tb_scoreboard);
			begin
			this.monitor_interface = tb_monitor_interface;
			this.new_scoreboard = tb_scoreboard;
			end
		endfunction

	//--------------------------------------------
	// Definition of burst_read task to read SDRAM
	//--------------------------------------------
	task burst_read;

	begin
		new_scoreboard.read_afifo_bfifo(Address,bl,size_fifo);
		read_dfifo
		@ (negedge monitor_interface.sys_clk);
			for(j=0; j < bl; j++) begin
				monitor_interface.wb_stb_i        = 1;
				monitor_interface.wb_cyc_i        = 1;
				monitor_interface.wb_we_i         = 0;
				monitor_interface.wb_addr_i       = Address[31:2]+j;

				exp_data        = new_scoreboard.dfifo.pop_front(); // Exptected Read Data
				do begin
					@ (posedge monitor_interface.sys_clk);
				end while(monitor_interface.wb_ack_o == 1'b0);
				if(monitor_interface.wb_dat_o !== exp_data) begin
					$display("READ ERROR: Burst-No: %d Addr: %x Rxp: %x Exd: %x",j,monitor_interface.wb_addr_i,monitor_interface.wb_dat_o,exp_data);
					monitor_interface.ErrCnt = monitor_interface.ErrCnt+1;
				end else begin
					$display("READ STATUS: Burst-No: %d Addr: %x Rxd: %x",j,monitor_interface.wb_addr_i,monitor_interface.wb_dat_o);
				end 
				@ (negedge monitor_interface.sdram_clk);
			end
		monitor_interface.wb_stb_i        = 0;
		monitor_interface.wb_cyc_i        = 0;
		monitor_interface.wb_we_i         = 'hx;
		monitor_interface.wb_addr_i       = 'hx;
	end
	endtask

endclass
