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
	integer param_random;
	integer size_fifo;
	parameter size_array = 100;
	integer order_size_write;
	integer order_size_read;
	
	int dfifo[size_array]; // data fifo
	int afifo[size_array]; // address  fifo
	int bfifo[size_array]; // Burst Length fifo
	
	// task write_order_size(input integer ext_order_size_write);
		// begin
			// order_size_write = ext_order_size_write;
		// end
	// endtask
	
	// task read_order_size(input integer ext_order_size_read);
		// begin
			// order_size_read = ext_order_size_read;
		// end
	// endtask
	
	task write_afifo_bfifo(input logic [31:0] Address, input logic [7:0]  b1, output integer fifo_size);
		begin
			param_random = $urandom_range(0,1);
			$display("Random Parameter for Scoreboard Writing: %d ",param_random);
			if(param_random == 1)
			begin
				size_fifo = $urandom_range(0,100);
				fifo_size = size_fifo;
				afifo[size_fifo] = Address;
				bfifo[size_fifo] = b1;
			end
			
			else
			begin
				afifo[order_size_write] = Address;
				bfifo[order_size_write] = b1;
				fifo_size = order_size_write;
				order_size_write = order_size_write + 1;
			end
		end
	endtask
	
	task write_dfifo(logic [31:0] write_data, integer fifo_write);
		begin
			size_fifo = fifo_write;
			dfifo[size_fifo] = write_data;
		end
	endtask
	
	task read_afifo_bfifo(output logic [31:0] Address, output logic [7:0]  bl, output integer fifo_size);
		begin
			param_random = $urandom_range(0,1);
			$display("Random Parameter for Scoreboard Reading: %d ",param_random);
			if(param_random == 1)
			begin
				size_fifo = $urandom_range(0,100);
				fifo_size = size_fifo;
				Address = afifo[size_fifo];
				b1 = bfifo[size_fifo];
				afifo.delete(size_fifo);
				bfifo.delete(size_fifo);
			end
			
			else
			begin
				Address = afifo[order_size_read];
				b1 = bfifo[order_size_read];
				afifo.delete(order_size_read);
				bfifo.delete(order_size_read);
				fifo_size = order_size_read;
				order_size_read = order_size_read + 1;
			end
		end
	endtask
	
	task read_dfifo(input integer fifo_write, output logic [31:0] write_data);
		begin
			size_fifo = fifo_write;
			write_data = dfifo[size_fifo];
			dfifo.delete(size_fifo);
		end
	endtask
	
endclass
