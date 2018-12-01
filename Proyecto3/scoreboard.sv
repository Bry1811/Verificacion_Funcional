//////////////////////////////////////////////////////////////////////////
//College: Tecnologico de Costa Rica									//
//																		//
//Authors:																//
//		Bryan Gomez														//
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
	parameter size_array = 1000;
	integer order_size_write;
	integer order_size_read;
	integer num_bl;
	integer rep;
	integer repeated;
	integer new_loc;
	
	int dfifo[size_array] [255]; // data fifo
	int afifo[size_array]; // address  fifo
	int bfifo[size_array]; // Burst Length fifo
	int unpacked[];
	
	task write_afifo_bfifo(input logic [31:0] Address, input logic [7:0]  bl, output integer fifo_size);
		begin
			for(rep=0; rep <= size_array-1; rep++)
			begin
				if(afifo[rep] == Address)
				begin
					repeated = 1;
					new_loc = rep;
				end
				else
				begin
					repeated = repeated;
				end
			end
			if(repeated == 1)
			begin
				size_fifo = new_loc;
				fifo_size = size_fifo;
				afifo[size_fifo] = Address;
				bfifo[size_fifo] = bl;
				repeated = 0;
			end
			else
			begin			
				param_random = $urandom_range(0,1);
				param_random = 0;
				$display("Random Parameter for Scoreboard Writing: %d ",param_random);
				if(param_random == 1)
				begin
					size_fifo = $urandom_range(0,size_array-1);
					fifo_size = size_fifo;
					afifo[size_fifo] = Address;
					bfifo[size_fifo] = bl;
				end
			
				else
				begin
					afifo[order_size_write] = Address;
					bfifo[order_size_write] = bl;
					fifo_size = order_size_write;
					order_size_write = order_size_write + 1;
				end	
			end
		end
	endtask
	
	task write_dfifo(logic [31:0] write_data, integer cur_ind, integer fifo_write);
		begin
			size_fifo = fifo_write;
			dfifo[size_fifo][cur_ind] = write_data;
			$display("WriteData: %x Size_Fifo %d",dfifo[size_fifo][cur_ind],size_fifo);
		end
	endtask
	
	task read_afifo_bfifo(output logic [31:0] Address, output logic [7:0]  bl, output integer fifo_size);
		begin
			param_random = $urandom_range(0,1);
			//param_random = 1;
			$display("Random Parameter for Scoreboard Reading: %d ",param_random);
			if(param_random == 1)
			begin
				size_fifo = $urandom_range(0,order_size_write-1);
				fifo_size = size_fifo;
				Address = afifo[size_fifo];
				bl = bfifo[size_fifo];
			end
			
			else
			begin
				Address = afifo[order_size_read];
				bl = bfifo[order_size_read];
				fifo_size = order_size_read;
				order_size_read = order_size_read + 1;
			end
		end
	endtask	

	task read_dfifo(input integer fifo_write, integer cur_ind, output logic [31:0] write_data);
		begin
			size_fifo = fifo_write;
			write_data = dfifo[size_fifo][cur_ind];
		end
	endtask
	
endclass
