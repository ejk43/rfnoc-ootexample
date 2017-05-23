/* 
 * Copyright 2017 <+YOU OR YOUR COMPANY+>.
 * 
 * This is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3, or (at your option)
 * any later version.
 * 
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street,
 * Boston, MA 02110-1301, USA.
 */

`timescale 1ns/1ps
`define NS_PER_TICK 1
`define NUM_TEST_CASES 5

`include "sim_exec_report.vh"
`include "sim_clks_rsts.vh"
`include "sim_rfnoc_lib.svh"

module noc_block_complextomagphase_tb();
  `TEST_BENCH_INIT("noc_block_complextomagphase",`NUM_TEST_CASES,`NS_PER_TICK);
  localparam BUS_CLK_PERIOD = $ceil(1e9/166.67e6);
  localparam CE_CLK_PERIOD  = $ceil(1e9/200e6);
  localparam NUM_CE         = 1;  // Number of Computation Engines / User RFNoC blocks to simulate
  localparam NUM_STREAMS    = 1;  // Number of test bench streams
  `RFNOC_SIM_INIT(NUM_CE, NUM_STREAMS, BUS_CLK_PERIOD, CE_CLK_PERIOD);
  `RFNOC_ADD_BLOCK(noc_block_complextomagphase, 0);

  localparam SPP = 16; // Samples per packet

  /********************************************************
  ** Verification
  ********************************************************/
  initial begin : tb_main
    string s;
    logic [31:0] random_word;
    logic [63:0] readback;

    /********************************************************
    ** Test 1 -- Reset
    ********************************************************/
    `TEST_CASE_START("Wait for Reset");
    while (bus_rst) @(posedge bus_clk);
    while (ce_rst) @(posedge ce_clk);
    `TEST_CASE_DONE(~bus_rst & ~ce_rst);

    /********************************************************
    ** Test 2 -- Check for correct NoC IDs
    ********************************************************/
    `TEST_CASE_START("Check NoC ID");
    // Read NOC IDs
    tb_streamer.read_reg(sid_noc_block_complextomagphase, RB_NOC_ID, readback);
    $display("Read complextomagphase NOC ID: %16x", readback);
    `ASSERT_ERROR(readback == noc_block_complextomagphase.NOC_ID, "Incorrect NOC ID");
    `TEST_CASE_DONE(1);

    /********************************************************
    ** Test 3 -- Connect RFNoC blocks
    ********************************************************/
    `TEST_CASE_START("Connect RFNoC blocks");
    `RFNOC_CONNECT(noc_block_tb,noc_block_complextomagphase,SC16,SPP);
    `RFNOC_CONNECT(noc_block_complextomagphase,noc_block_tb,SC16,SPP);
    `TEST_CASE_DONE(1);

    /********************************************************
    ** Test 4 -- Write / readback user registers
    ********************************************************/
    `TEST_CASE_START("Write / readback user registers");
    random_word = $random();
    tb_streamer.write_user_reg(sid_noc_block_complextomagphase, noc_block_complextomagphase.SR_TEST_REG_0, random_word);
    tb_streamer.read_user_reg(sid_noc_block_complextomagphase, 0, readback);
    $sformat(s, "User register 0 incorrect readback! Expected: %0d, Actual %0d", readback[31:0], random_word);
    `ASSERT_ERROR(readback[31:0] == random_word, s);
    random_word = $random();
    tb_streamer.write_user_reg(sid_noc_block_complextomagphase, noc_block_complextomagphase.SR_TEST_REG_1, random_word);
    tb_streamer.read_user_reg(sid_noc_block_complextomagphase, 1, readback);
    $sformat(s, "User register 1 incorrect readback! Expected: %0d, Actual %0d", readback[31:0], random_word);
    `ASSERT_ERROR(readback[31:0] == random_word, s);
    `TEST_CASE_DONE(1);

    /********************************************************
    ** Test 5 -- Test sequence
    ********************************************************/
    //  - Looks like CORDIC wants some extra bits to solve the result accurately
    //  - Note due to fixed point details, the CORDIC chops off an LSB
    //  - Phase is at a discontinuity. Just confirm based on magnitude
    `TEST_CASE_START("Test sequence");
    fork
      begin
        logic [15:0] val;
        cvita_payload_t send_payload;
        for (int ii = 0; ii < SPP; ii++) begin
          val = (ii+1)*16;
          tb_streamer.push_word({val, 16'd0},  ii==SPP-1);
        end
      end
      begin
        cvita_payload_t recv_payload;
        cvita_metadata_t md;
        logic [63:0] expected_mag;
        logic [15:0] val1_mag, val1_phs;
        logic lastval;
        for (int ii=0; ii < SPP; ii++) begin
          tb_streamer.pull_word({val1_phs, val1_mag}, lastval);

          $sformat(s, "Received Mag: %0d, Phase: %0d", val1_mag, val1_phs); $display(s);
          
          expected_mag = (ii+1)*8;
          $sformat(s, "Incorrect Magnitude Value received! Expected: %0d, Received: %0d", expected_mag, val1_mag);
          `ASSERT_ERROR(val1_mag == expected_mag, s);
        end
      end
    join
    `TEST_CASE_DONE(1);
    `TEST_BENCH_DONE;

  end
endmodule
