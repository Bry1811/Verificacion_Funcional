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
//Module Description: Test that joins environment, driver, scoreboard 	//
//					  and monitor										//
//Details: This module make test in writing and reseting the SDRAM,		//
//		   read data from memory and check the data with the queues. 	//
//																		//
//																		//
//Date: October 2018													//
//////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

//************************************************************************
// The "ifndef" function is needed in compilation to avoid two  
// times definition for the same module.
// These "include"  is needed to define a previous module compilation.
//************************************************************************

`include "environment2.sv"

program test(bus_interface test_interface, whitebox test_whitebox);

//--------------------
// data/address/burst length FIFO
//--------------------
int dfifo[$]; // data fifo
int afifo[$]; // address  fifo
int bfifo[$]; // Burst Length fifo

reg [31:0] read_data;
int k;
reg [31:0] StartAddr;

environment2 tb_environment;
/////////////////////////////////////////////////////////////////////////
// Test Case
/////////////////////////////////////////////////////////////////////////

initial begin //{
  //Create a new environment for Validation and to call functions to initialize and write the SDRAM.
  tb_environment=new(test_interface,test_whitebox);
  //Callback of the Reset task in Driver Class
  tb_environment.tb_driver.Reset();

  #1000;
  $display("-------------------------------------- ");
  $display(" Case-1: Single Write/Read Case        ");
  $display("-------------------------------------- ");

  tb_environment.tb_driver.burst_write(32'h4_0000,8'h4);  
 #1000;
  //Callback of the Burst Read task in Monitor Class
  tb_environment.tb_monitor.burst_read();  

  // Repeat one more time to analysis the 
  // SDRAM state change for same col/row address
  $display("-------------------------------------- ");
  $display(" Case-2: Repeat same transfer once again ");
  $display("----------------------------------------");
  tb_environment.tb_driver.burst_write(32'h4_0000,8'h4);  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_driver.burst_write(32'h0040_0000,8'h5);  
  tb_environment.tb_monitor.burst_read();  
  $display("----------------------------------------");
  $display(" Case-3 Create a Page Cross Over        ");
  $display("----------------------------------------");
  tb_environment.tb_driver.burst_write_page_crossover();  
  tb_environment.tb_driver.burst_write_page_crossover();  
  tb_environment.tb_driver.burst_write_page_crossover();  
  tb_environment.tb_driver.burst_write_page_crossover();  
  tb_environment.tb_driver.burst_write_page_crossover();  
  tb_environment.tb_driver.burst_write_page_crossover();  
  tb_environment.tb_driver.burst_write_page_crossover();  
  tb_environment.tb_driver.burst_write_page_crossover();  
  tb_environment.tb_driver.burst_write_page_crossover();  
  tb_environment.tb_driver.burst_write_page_crossover();  
  tb_environment.tb_driver.burst_write_page_crossover();  
  tb_environment.tb_driver.burst_write_page_crossover();  
  tb_environment.tb_driver.burst_write_page_crossover();  
  tb_environment.tb_driver.burst_write_page_crossover();  
  tb_environment.tb_driver.burst_write_page_crossover();  
  tb_environment.tb_driver.burst_write_page_crossover();  
  tb_environment.tb_driver.burst_write_page_crossover();  
  tb_environment.tb_driver.burst_write_page_crossover();  
  tb_environment.tb_driver.burst_write_page_crossover();  
  tb_environment.tb_driver.burst_write_page_crossover();  
  tb_environment.tb_driver.burst_write_page_crossover();  
  tb_environment.tb_driver.burst_write_page_crossover();  
  tb_environment.tb_driver.burst_write_page_crossover();  
  tb_environment.tb_driver.burst_write_page_crossover();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  

  $display("----------------------------------------");
  $display(" Case:4 4 Write & 4 Read                ");
  $display("----------------------------------------");
  tb_environment.tb_driver.burst_write_random();  
  tb_environment.tb_driver.burst_write_random();  
  tb_environment.tb_driver.burst_write_random();  
  tb_environment.tb_driver.burst_write_random();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  

  $display("---------------------------------------");
  $display(" Case:5 24 Write & 24 Read With Different Bank and Row ");
  $display("---------------------------------------");
  //----------------------------------------
  // Address Decodeing:
  //  with cfg_col bit configured as: 00
  //    <12 Bit Row> <2 Bit Bank> <8 Bit Column> <2'b00>
  //
  tb_environment.tb_driver.burst_write_random_column(12'h000,2'b00);   // Row: 0 Bank : 0
  tb_environment.tb_driver.burst_write_random_column(12'h000,2'b01);   // Row: 0 Bank : 1
  tb_environment.tb_driver.burst_write_random_column(12'h000,2'b10);   // Row: 0 Bank : 2
  tb_environment.tb_driver.burst_write_random_column(12'h000,2'b11);   // Row: 0 Bank : 3
  tb_environment.tb_driver.burst_write_random_column(12'h001,2'b00);   // Row: 1 Bank : 0
  tb_environment.tb_driver.burst_write_random_column(12'h001,2'b01);   // Row: 1 Bank : 1
  tb_environment.tb_driver.burst_write_random_column(12'h001,2'b10);   // Row: 1 Bank : 2
  tb_environment.tb_driver.burst_write_random_column(12'h001,2'b11);   // Row: 1 Bank : 3
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  

  tb_environment.tb_driver.burst_write_random_column(12'h002,2'b00);   // Row: 2 Bank : 0
  tb_environment.tb_driver.burst_write_random_column(12'h002,2'b01);   // Row: 2 Bank : 1
  tb_environment.tb_driver.burst_write_random_column(12'h002,2'b10);   // Row: 2 Bank : 2
  tb_environment.tb_driver.burst_write_random_column(12'h002,2'b11);   // Row: 2 Bank : 3
  tb_environment.tb_driver.burst_write_random_column(12'h003,2'b00);   // Row: 3 Bank : 0
  tb_environment.tb_driver.burst_write_random_column(12'h003,2'b01);   // Row: 3 Bank : 1
  tb_environment.tb_driver.burst_write_random_column(12'h003,2'b10);   // Row: 3 Bank : 2
  tb_environment.tb_driver.burst_write_random_column(12'h003,2'b11);   // Row: 3 Bank : 3

  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  

  tb_environment.tb_driver.burst_write_random_column(12'h002,2'b00);   // Row: 2 Bank : 0
  tb_environment.tb_driver.burst_write_random_column(12'h002,2'b01);   // Row: 2 Bank : 1
  tb_environment.tb_driver.burst_write_random_column(12'h002,2'b10);   // Row: 2 Bank : 2
  tb_environment.tb_driver.burst_write_random_column(12'h002,2'b11);   // Row: 2 Bank : 3
  tb_environment.tb_driver.burst_write_random_column(12'h003,2'b00);   // Row: 3 Bank : 0
  tb_environment.tb_driver.burst_write_random_column(12'h003,2'b01);   // Row: 3 Bank : 1
  tb_environment.tb_driver.burst_write_random_column(12'h003,2'b10);   // Row: 3 Bank : 2
  tb_environment.tb_driver.burst_write_random_column(12'h003,2'b11);   // Row: 3 Bank : 3

  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  tb_environment.tb_monitor.burst_read();  
  $display("---------------------------------------------------");
  $display(" Case: 6 Random 2 write and 2 read random");
  $display("---------------------------------------------------");
  for(k=0; k < 20; k++) begin
     StartAddr = $random & 32'h003FFFFF;
     tb_environment.tb_driver.burst_write(StartAddr,($random & 8'h0f)+1);  
 #100;

     StartAddr = $random & 32'h003FFFFF;
     tb_environment.tb_driver.burst_write(StartAddr,($random & 8'h0f)+1);  
 #100;
     tb_environment.tb_monitor.burst_read();  
 #100;
     tb_environment.tb_monitor.burst_read();  
 #100;
  end

  #10000;

        $display("###############################");
    if(test_interface.ErrCnt == 0)
        $display("STATUS: SDRAM Write/Read TEST PASSED");
    else
        $display("ERROR:  SDRAM Write/Read TEST FAILED");
        $display("###############################");

    $finish;
end

endprogram
