//////////////////////////////////////////////////////////////////////////
//College: Tecnologico de Costa Rica									//
//																		//
//Authors:																//
//		Bryan Gomez														//
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

reg [31:0] read_data;
int k;
int temp_error;
reg [31:0] StartAddr;

environment2 tb_environment;
//covarage covarage1=new(test_interface,test_whitebox);
/////////////////////////////////////////////////////////////////////////
// Test Case
/////////////////////////////////////////////////////////////////////////

initial begin //{
  //Create a new environment for Validation and to call functions to initialize and write the SDRAM.
  //tb_environment=new(test_interface,test_whitebox);
  tb_environment=new(test_interface);
  
  //Callback of the Reset task in Driver Class and for the Regs
  tb_environment.tb_driver.write_load_mode_reg();
  tb_environment.tb_driver.write_refresh_reg();
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
  for(k=0; k < 5; k++) begin
	tb_environment.tb_driver.burst_write_page_crossover();  
  end
  for(k=0; k < 10; k++) begin
	tb_environment.tb_monitor.burst_read();   
  end  
 
  $display("----------------------------------------");
  $display(" Case:4 4 Write & 4 Read                ");
  $display("----------------------------------------");
  for(k=0; k < 4; k++) begin
	tb_environment.tb_driver.burst_write_random();   
  end  
  for(k=0; k < 4; k++) begin
	tb_environment.tb_monitor.burst_read();   
  end  

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
  for(k=0; k < 8; k++) begin
	tb_environment.tb_monitor.burst_read();   
  end   

  tb_environment.tb_driver.burst_write_random_column(12'h002,2'b00);   // Row: 2 Bank : 0
  tb_environment.tb_driver.burst_write_random_column(12'h002,2'b01);   // Row: 2 Bank : 1
  tb_environment.tb_driver.burst_write_random_column(12'h002,2'b10);   // Row: 2 Bank : 2
  tb_environment.tb_driver.burst_write_random_column(12'h002,2'b11);   // Row: 2 Bank : 3
  tb_environment.tb_driver.burst_write_random_column(12'h003,2'b00);   // Row: 3 Bank : 0
  tb_environment.tb_driver.burst_write_random_column(12'h003,2'b01);   // Row: 3 Bank : 1
  tb_environment.tb_driver.burst_write_random_column(12'h003,2'b10);   // Row: 3 Bank : 2
  tb_environment.tb_driver.burst_write_random_column(12'h003,2'b11);   // Row: 3 Bank : 3

  for(k=0; k < 8; k++) begin
	tb_environment.tb_monitor.burst_read();   
  end   

  tb_environment.tb_driver.burst_write_random_column(12'h002,2'b00);   // Row: 2 Bank : 0
  tb_environment.tb_driver.burst_write_random_column(12'h002,2'b01);   // Row: 2 Bank : 1
  tb_environment.tb_driver.burst_write_random_column(12'h002,2'b10);   // Row: 2 Bank : 2
  tb_environment.tb_driver.burst_write_random_column(12'h002,2'b11);   // Row: 2 Bank : 3
  tb_environment.tb_driver.burst_write_random_column(12'h003,2'b00);   // Row: 3 Bank : 0
  tb_environment.tb_driver.burst_write_random_column(12'h003,2'b01);   // Row: 3 Bank : 1
  tb_environment.tb_driver.burst_write_random_column(12'h003,2'b10);   // Row: 3 Bank : 2
  tb_environment.tb_driver.burst_write_random_column(12'h003,2'b11);   // Row: 3 Bank : 3

  for(k=0; k < 8; k++) begin
	tb_environment.tb_monitor.burst_read();   
  end 
  
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
        $display("STATUS: SDRAM Write/Read TEST PASSED for Cases 1-6");
    else
        $display("ERROR:  SDRAM Write/Read TEST FAILED for Cases 1-6");
        $display("###############################");
	
 #10000
  $display("---------------------------------------------------");
  $display(" Case: 7 Random write and read with different CAS Latency");
  $display("---------------------------------------------------");
  for(k=0; k < 5; k++) begin
	void'(tb_environment.tb_driver.new_load_mode_register.randomize(cas_latency));
	test_interface.cas_latency = tb_environment.tb_driver.new_load_mode_register.cas_latency;
	temp_error = test_interface.ErrCnt;
	tb_environment.tb_driver.Reset();
	test_interface.ErrCnt = temp_error;
	tb_environment.tb_driver.burst_write_page_crossover();
	tb_environment.tb_driver.burst_write_random();   	
	tb_environment.tb_monitor.burst_read(); 
	tb_environment.tb_driver.burst_write_page_crossover();
	tb_environment.tb_driver.burst_write_random(); 
	tb_environment.tb_monitor.burst_read(); 
  end 
  $display("###############################");
    if(test_interface.ErrCnt == 0)
        $display("STATUS: SDRAM Write/Read TEST PASSED for Case 7");
    else
        $display("ERROR:  SDRAM Write/Read TEST FAILED for Case 7");
        $display("###############################");
  
   #10000
  $display("---------------------------------------------------");
  $display(" Case: 8 Random write and read with different refresh settings");
  $display("---------------------------------------------------");
  for(k=0; k < 5; k++) begin
	tb_environment.tb_driver.write_refresh_reg();
	temp_error = test_interface.ErrCnt;
	tb_environment.tb_driver.Reset();
	test_interface.ErrCnt = temp_error;
	
	wait(test_whitebox.x2b_refresh == 1);
	tb_environment.tb_driver.burst_write_page_crossover();
	tb_environment.tb_driver.burst_write_random();  
	
	wait(test_whitebox.x2b_refresh == 1);
	tb_environment.tb_monitor.burst_read();
	tb_environment.tb_monitor.burst_read();
  end
  
  $display("###############################");
    if(test_interface.ErrCnt == 0)
        $display("STATUS: SDRAM Write/Read TEST PASSED for Case 8");
    else
        $display("ERROR:  SDRAM Write/Read TEST FAILED for Case 8");
        $display("###############################");
  
  #10000
  $display("---------------------------------------------------");
  $display(" Case: 9 Random write and read with different Registers settings");
  $display("---------------------------------------------------");
  tb_environment.tb_driver.Reset();
  for(k=0; k < 5; k++) begin
	tb_environment.tb_driver.write_load_mode_reg();
	tb_environment.tb_driver.write_refresh_reg();
	temp_error = test_interface.ErrCnt;
	tb_environment.tb_driver.Reset();
	test_interface.ErrCnt = temp_error;
	
	wait(test_whitebox.x2b_refresh == 1);
	tb_environment.tb_driver.burst_write_page_crossover();
	tb_environment.tb_driver.burst_write_random();  
	tb_environment.tb_driver.burst_write_random();
	tb_environment.tb_driver.burst_write_page_crossover();
	
	wait(test_whitebox.x2b_refresh == 1);
	tb_environment.tb_monitor.burst_read();
	tb_environment.tb_monitor.burst_read();
	tb_environment.tb_monitor.burst_read();
	tb_environment.tb_monitor.burst_read();
  end 
  $display("###############################");
    if(test_interface.ErrCnt == 0)
        $display("STATUS: SDRAM Write/Read TEST PASSED for Case 9");
    else
        $display("ERROR:  SDRAM Write/Read TEST FAILED for Case 9");
        $display("###############################");
  
  #10000;

$finish;   
end

endprogram
