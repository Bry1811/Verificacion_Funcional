//////////////////////////////////////////////////////////////////////
////                                                              ////
////                                                              ////
////  This file is part of the SDRAM Controller project           ////
////  http://www.opencores.org/cores/sdr_ctrl/                    ////
////                                                              ////
////  Description                                                 ////
////  SDRAM CTRL definitions.                                     ////
////                                                              ////
////  To Do:                                                      ////
////    nothing                                                   ////
////                                                              ////
//   Version  :0.1 - Test Bench automation is improvised with     ////
//             seperate data,address,burst length fifo.           ////
//             Now user can create different write and            ////
//             read sequence                                      ////
//                                                                ////
////  Author(s):                                                  ////
////      - Dinesh Annayya, dinesha@opencores.org                 ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2000 Authors and OPENCORES.ORG                 ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

//************************************************************************
// The "ifndef" function is needed in compilation to avoid two  
// times definition for the same module.
// These "include"  is needed to define a previous module compilation.
//************************************************************************

`include "test.sv"
`include "interface.sv"
`include "whitebox.sv"

// This testbench verify with SDRAM TOP

module tb_top;

parameter P_SYS  = 10;     //    200MHz
parameter P_SDR  = 20;     //    100MHz

// General
reg            sdram_clk;
reg            sys_clk;

initial sys_clk = 0;
initial sdram_clk = 0;

always #(P_SYS/2) sys_clk = !sys_clk;
always #(P_SDR/2) sdram_clk = !sdram_clk;

parameter      dw              = 32;  // data width
parameter      tw              = 8;   // tag id width
parameter      bl              = 5;   // burst_lenght_width 

// to fix the sdram interface timing issue
wire #(2.0) sdram_clk_d   = sdram_clk;

bus_interface main_interface(sys_clk,sdram_clk);
whitebox whitebox_interface();

`ifdef SDR_32BIT

   sdrc_top #(.SDR_DW(32),.SDR_BW(4)) u_dut(
`elsif SDR_16BIT 
   sdrc_top #(.SDR_DW(16),.SDR_BW(2)) u_dut(
`else  // 8 BIT SDRAM
   sdrc_top #(.SDR_DW(8),.SDR_BW(1)) u_dut(
`endif
      // System 
`ifdef SDR_32BIT
          .cfg_sdr_width      (2'b00              ), // 32 BIT SDRAM
`elsif SDR_16BIT
          .cfg_sdr_width      (2'b01              ), // 16 BIT SDRAM
`else 
          .cfg_sdr_width      (2'b10              ), // 8 BIT SDRAM
`endif
          .cfg_colbits        (2'b00              ), // 8 Bit Column Address		  
		  
/* WISH BONE */
          .wb_rst_i           (!main_interface.RESETN            ),
          .wb_clk_i           (main_interface.sys_clk            ),
                              
          .wb_stb_i           (main_interface.wb_stb_i           ),
          .wb_ack_o           (main_interface.wb_ack_o           ),
          .wb_addr_i          (main_interface.wb_addr_i          ),
          .wb_we_i            (main_interface.wb_we_i            ),
          .wb_dat_i           (main_interface.wb_dat_i           ),
          .wb_sel_i           (main_interface.wb_sel_i           ),
          .wb_dat_o           (main_interface.wb_dat_o           ),
          .wb_cyc_i           (main_interface.wb_cyc_i           ),
          .wb_cti_i           (main_interface.wb_cti_i           ), 
                               
/* Interface to SDRAMs */      
          .sdram_clk          (main_interface.sdram_clk          ),
          .sdram_resetn       (main_interface.RESETN             ),
          .sdr_cs_n           (sdr_cs_n           ),
          .sdr_cke            (sdr_cke            ),
          .sdr_ras_n          (sdr_ras_n          ),
          .sdr_cas_n          (sdr_cas_n          ),
          .sdr_we_n           (sdr_we_n           ),
          .sdr_dqm            (main_interface.sdr_dqm            ),
          .sdr_ba             (main_interface.sdr_ba             ),
          .sdr_addr           (main_interface.sdr_addr           ), 
          .sdr_dq             (main_interface.Dq                 ),

    /* Parameters */
          .sdr_init_done      (main_interface.sdr_init_done      ),
          .cfg_req_depth      (2'h3               ),	        //how many req. buffer should hold
          .cfg_sdr_en         (1'b1               ),
          .cfg_sdr_mode_reg   (13'h033            ),
          .cfg_sdr_tras_d     (4'h4               ),
          .cfg_sdr_trp_d      (4'h2               ),
          .cfg_sdr_trcd_d     (4'h2               ),
          .cfg_sdr_cas        (3'h3               ),
          .cfg_sdr_trcar_d    (4'h7               ),
          .cfg_sdr_twr_d      (4'h1               ),
          .cfg_sdr_rfsh       (12'h100            ), // reduced from 12'hC35
          .cfg_sdr_rfmax      (3'h6               )

);


`ifdef SDR_32BIT
mt48lc2m32b2 #(.data_bits(32)) u_sdram32 (
          .Dq                 (main_interface.Dq                 ) , 
          .Addr               (main_interface.sdr_addr[10:0]     ), 
          .Ba                 (main_interface.sdr_ba             ), 
          .Clk                (sdram_clk_d        ), 
          .Cke                (sdr_cke            ), 
          .Cs_n               (sdr_cs_n           ), 
          .Ras_n              (sdr_ras_n          ), 
          .Cas_n              (sdr_cas_n          ), 
          .We_n               (sdr_we_n           ), 
          .Dqm                (main_interface.sdr_dqm            )
     );

`elsif SDR_16BIT

   IS42VM16400K u_sdram16 (
          .dq                 (main_interface.Dq                 ), 
          .addr               (main_interface.sdr_addr[11:0]     ), 
          .ba                 (main_interface.sdr_ba             ), 
          .clk                (sdram_clk_d        ), 
          .cke                (sdr_cke            ), 
          .csb                (sdr_cs_n           ), 
          .rasb               (sdr_ras_n          ), 
          .casb               (sdr_cas_n          ), 
          .web                (sdr_we_n           ), 
          .dqm                (main_interface.sdr_dqm            )
    );
`else 


mt48lc8m8a2 #(.data_bits(8)) u_sdram8 (
          .Dq                 (main_interface.Dq                 ) , 
          .Addr               (main_interface.sdr_addr[11:0]     ), 
          .Ba                 (main_interface.sdr_ba             ), 
          .Clk                (sdram_clk_d        ), 
          .Cke                (sdr_cke            ), 
          .Cs_n               (sdr_cs_n           ), 
          .Ras_n              (sdr_ras_n          ), 
          .Cas_n              (sdr_cas_n          ), 
          .We_n               (sdr_we_n           ), 
          .Dqm                (main_interface.sdr_dqm            )
     );
`endif

test main_tb(main_interface,whitebox_interface);

endmodule
