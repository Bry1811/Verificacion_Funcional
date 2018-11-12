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
	
	int dfifo[size_fifo]; // data fifo
	int afifo[size_fifo]; // address  fifo
	int bfifo[size_fifo]; // Burst Length fifo
	
	task write_afifo_bfifo(input logic [31:0] Address, logic [7:0]  bl, output integer fifo_size);
		begin
			param_random = $urandom_range(0,1);
			$display("Random Parameter for Scoreboard Writting: %d ",param_random);
			if(param_random == 1)
			begin
				size_fifo = $urandom_range(0,24);
				fifo_size = size_fifo;
				afifo[size_fifo] = Address;
				bfifo[size_fifo] = b1;
			end
			
			else
			begin
				afifo.push_back(Address);
				bfifo.push_back(b1);
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
				size_fifo = $urandom_range(0,24);
				fifo_size = size_fifo;
				Address = afifo[size_fifo];
				b1 = bfifo[size_fifo];
				afifo.delete(size_fifo);
				bfifo.delete(size_fifo);
			end
			
			else
			begin
				Address = afifo.pop_front();
				b1 = bfifo.pop_front();
			end
		end
	endtask
	
	task read_dfifo(input integer fifo_write, output logic [31:0] write_data);
		begin
			size_fifo = fifo_write;
			write_data = dfifo[size_fifo];
		end
	endtask
	
endclass
