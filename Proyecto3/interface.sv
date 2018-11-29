//////////////////////////////////////////////////////////////////////////
//College: Tecnologico de Costa Rica									//
//																		//
//Authors:																//
//		Bryan Gomez														//
//		Edgar Solera													//
// 																		//
//Curse: Functional Verification										//
//																		//
//Module Description:  Interface definition for DRAM verification  		//
//					   													//
//Details: This contains SDRAM and wishbone interface to make easier 	//
//		   the communication with the verification environment			//
//																		//
//Date: October 2018													//
//////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps
interface bus_interface #(dw=32)(input sys_clk, input sdram_clk); 

	//-------------------------------------------
	// WISH BONE Interface
	//-------------------------------------------
	reg             wb_stb_i           ;
	wire            wb_ack_o           ;
	reg  [25:0]     wb_addr_i          ;
	reg             wb_we_i            ; // 1 - Write, 0 - Read
	reg  [dw-1:0]   wb_dat_i           ;
	reg  [dw/8-1:0] wb_sel_i           ; // Byte enable
	wire  [dw-1:0]  wb_dat_o           ;
	reg             wb_cyc_i           ;
	reg   [2:0]     wb_cti_i           ; 

	//--------------------------------------------
	// SDRAM I/F 
	//--------------------------------------------

	`ifdef SDR_32BIT
	   wire [31:0]           Dq                 ; // SDRAM Read/Write Data Bus
	   wire [3:0]            sdr_dqm            ; // SDRAM DATA Mask
	`elsif SDR_16BIT 
	   wire [15:0]           Dq                 ; // SDRAM Read/Write Data Bus
	   wire [1:0]            sdr_dqm            ; // SDRAM DATA Mask
	`else 
	   wire [7:0]           Dq                 ; // SDRAM Read/Write Data Bus
	   wire [0:0]           sdr_dqm            ; // SDRAM DATA Mask
	`endif

	wire [1:0]            sdr_ba             ; // SDRAM Bank Select
	wire [12:0]           sdr_addr           ; // SDRAM ADRESS
	wire                  sdr_init_done      ; // SDRAM Init Done 

	// to fix the sdram interface timing issue
	wire #(2.0) sdram_clk_d   = sdram_clk;

	//Additional signals used for different verification blocks
	reg 			RESETN;
	reg   [31:0]    ErrCnt;
	reg page_overflow;
	
	//--------------------------------------------
	// Load Mode Register Signals
	//--------------------------------------------
	
	reg [2:0] burst_length;
	reg [2:0] cas_latency ;
	
	//--------------------------------------------
	// Refresh Register Signals
	//--------------------------------------------
	reg [3:0]  trcar_d;
	reg [11:0] cfg_sdr_rfsh;
	reg [2:0] cfg_sdr_rfmax;
	
	
endinterface
