//
// Copyright 2019 Ettus Research, A National Instruments Brand
//
// SPDX-License-Identifier: LGPL-3.0-or-later
//
// Module: rfnoc_block_gain_oot
//
// Description:
//
//   <Add block description here>
//
// Parameters:
//
//   THIS_PORTID : Control crossbar port to which this block is connected
//   CHDR_W      : AXIS-CHDR data bus width
//   MTU         : Maximum transmission unit (i.e., maximum packet size in
//                 CHDR words is 2**MTU).
//

`default_nettype none


module rfnoc_block_gain_oot #(
  parameter [9:0] THIS_PORTID     = 10'd0,
  parameter       CHDR_W          = 64,
  parameter [5:0] MTU             = 10
)(
  // RFNoC Framework Clocks and Resets
  input  wire                   rfnoc_chdr_clk,
  input  wire                   rfnoc_ctrl_clk,
  // RFNoC Backend Interface
  input  wire [511:0]           rfnoc_core_config,
  output wire [511:0]           rfnoc_core_status,
  // AXIS-CHDR Input Ports (from framework)
  input  wire [(1)*CHDR_W-1:0] s_rfnoc_chdr_tdata,
  input  wire [(1)-1:0]        s_rfnoc_chdr_tlast,
  input  wire [(1)-1:0]        s_rfnoc_chdr_tvalid,
  output wire [(1)-1:0]        s_rfnoc_chdr_tready,
  // AXIS-CHDR Output Ports (to framework)
  output wire [(1)*CHDR_W-1:0] m_rfnoc_chdr_tdata,
  output wire [(1)-1:0]        m_rfnoc_chdr_tlast,
  output wire [(1)-1:0]        m_rfnoc_chdr_tvalid,
  input  wire [(1)-1:0]        m_rfnoc_chdr_tready,
  // AXIS-Ctrl Input Port (from framework)
  input  wire [31:0]            s_rfnoc_ctrl_tdata,
  input  wire                   s_rfnoc_ctrl_tlast,
  input  wire                   s_rfnoc_ctrl_tvalid,
  output wire                   s_rfnoc_ctrl_tready,
  // AXIS-Ctrl Output Port (to framework)
  output wire [31:0]            m_rfnoc_ctrl_tdata,
  output wire                   m_rfnoc_ctrl_tlast,
  output wire                   m_rfnoc_ctrl_tvalid,
  input  wire                   m_rfnoc_ctrl_tready
);

  //---------------------------------------------------------------------------
  // Signal Declarations
  //---------------------------------------------------------------------------

  // Clocks and Resets
  wire               ctrlport_clk;
  wire               ctrlport_rst;
  wire               axis_data_clk;
  wire               axis_data_rst;
  // CtrlPort Master
  wire               m_ctrlport_req_wr;
  wire               m_ctrlport_req_rd;
  wire [19:0]        m_ctrlport_req_addr;
  wire [31:0]        m_ctrlport_req_data;
  wire               m_ctrlport_resp_ack;
  wire [31:0]        m_ctrlport_resp_data;
  // Payload Stream to User Logic: in
  wire [32*1-1:0]    m_in_payload_tdata;
  wire [1-1:0]       m_in_payload_tkeep;
  wire               m_in_payload_tlast;
  wire               m_in_payload_tvalid;
  wire               m_in_payload_tready;
  // Context Stream to User Logic: in
  wire [CHDR_W-1:0]  m_in_context_tdata;
  wire [3:0]         m_in_context_tuser;
  wire               m_in_context_tlast;
  wire               m_in_context_tvalid;
  wire               m_in_context_tready;
  // Payload Stream from User Logic: out
  wire [32*1-1:0]    s_out_payload_tdata;
  wire [0:0]         s_out_payload_tkeep;
  wire               s_out_payload_tlast;
  wire               s_out_payload_tvalid;
  wire               s_out_payload_tready;
  // Context Stream from User Logic: out
  wire [CHDR_W-1:0]  s_out_context_tdata;
  wire [3:0]         s_out_context_tuser;
  wire               s_out_context_tlast;
  wire               s_out_context_tvalid;
  wire               s_out_context_tready;

  //---------------------------------------------------------------------------
  // NoC Shell
  //---------------------------------------------------------------------------

  noc_shell_gain_oot #(
    .CHDR_W      (CHDR_W),
    .THIS_PORTID (THIS_PORTID),
    .MTU         (MTU)
  ) noc_shell_gain_oot_i (
    //---------------------
    // Framework Interface
    //---------------------

    // Clock Inputs
    .rfnoc_chdr_clk      (rfnoc_chdr_clk),
    .rfnoc_ctrl_clk      (rfnoc_ctrl_clk),
    // Reset Outputs
    .rfnoc_chdr_rst      (),
    .rfnoc_ctrl_rst      (),
    // RFNoC Backend Interface
    .rfnoc_core_config   (rfnoc_core_config),
    .rfnoc_core_status   (rfnoc_core_status),
    // CHDR Input Ports  (from framework)
    .s_rfnoc_chdr_tdata  (s_rfnoc_chdr_tdata),
    .s_rfnoc_chdr_tlast  (s_rfnoc_chdr_tlast),
    .s_rfnoc_chdr_tvalid (s_rfnoc_chdr_tvalid),
    .s_rfnoc_chdr_tready (s_rfnoc_chdr_tready),
    // CHDR Output Ports (to framework)
    .m_rfnoc_chdr_tdata  (m_rfnoc_chdr_tdata),
    .m_rfnoc_chdr_tlast  (m_rfnoc_chdr_tlast),
    .m_rfnoc_chdr_tvalid (m_rfnoc_chdr_tvalid),
    .m_rfnoc_chdr_tready (m_rfnoc_chdr_tready),
    // AXIS-Ctrl Input Port (from framework)
    .s_rfnoc_ctrl_tdata  (s_rfnoc_ctrl_tdata),
    .s_rfnoc_ctrl_tlast  (s_rfnoc_ctrl_tlast),
    .s_rfnoc_ctrl_tvalid (s_rfnoc_ctrl_tvalid),
    .s_rfnoc_ctrl_tready (s_rfnoc_ctrl_tready),
    // AXIS-Ctrl Output Port (to framework)
    .m_rfnoc_ctrl_tdata  (m_rfnoc_ctrl_tdata),
    .m_rfnoc_ctrl_tlast  (m_rfnoc_ctrl_tlast),
    .m_rfnoc_ctrl_tvalid (m_rfnoc_ctrl_tvalid),
    .m_rfnoc_ctrl_tready (m_rfnoc_ctrl_tready),

    //---------------------
    // Client Interface
    //---------------------

    // CtrlPort Clock and Reset
    .ctrlport_clk              (ctrlport_clk),
    .ctrlport_rst              (ctrlport_rst),
    // CtrlPort Master
    .m_ctrlport_req_wr         (m_ctrlport_req_wr),
    .m_ctrlport_req_rd         (m_ctrlport_req_rd),
    .m_ctrlport_req_addr       (m_ctrlport_req_addr),
    .m_ctrlport_req_data       (m_ctrlport_req_data),
    .m_ctrlport_resp_ack       (m_ctrlport_resp_ack),
    .m_ctrlport_resp_data      (m_ctrlport_resp_data),

    // AXI-Stream Payload Context Clock and Reset
    .axis_data_clk (axis_data_clk),
    .axis_data_rst (axis_data_rst),
    // Payload Stream to User Logic: in
    .m_in_payload_tdata  (m_in_payload_tdata),
    .m_in_payload_tkeep  (m_in_payload_tkeep),
    .m_in_payload_tlast  (m_in_payload_tlast),
    .m_in_payload_tvalid (m_in_payload_tvalid),
    .m_in_payload_tready (m_in_payload_tready),
    // Context Stream to User Logic: in
    .m_in_context_tdata  (m_in_context_tdata),
    .m_in_context_tuser  (m_in_context_tuser),
    .m_in_context_tlast  (m_in_context_tlast),
    .m_in_context_tvalid (m_in_context_tvalid),
    .m_in_context_tready (m_in_context_tready),
    // Payload Stream from User Logic: out
    .s_out_payload_tdata  (s_out_payload_tdata),
    .s_out_payload_tkeep  (s_out_payload_tkeep),
    .s_out_payload_tlast  (s_out_payload_tlast),
    .s_out_payload_tvalid (s_out_payload_tvalid),
    .s_out_payload_tready (s_out_payload_tready),
    // Context Stream from User Logic: out
    .s_out_context_tdata  (s_out_context_tdata),
    .s_out_context_tuser  (s_out_context_tuser),
    .s_out_context_tlast  (s_out_context_tlast),
    .s_out_context_tvalid (s_out_context_tvalid),
    .s_out_context_tready (s_out_context_tready)
  );

  //---------------------------------------------------------------------------
  // User Logic
  //---------------------------------------------------------------------------

  // < Replace this section with your logic >

  // Nothing to do yet, so just drive control signals to default values
  assign m_ctrlport_resp_ack = 1'b0;
  assign m_in_payload_tready = 1'b0;
  assign m_in_context_tready = 1'b0;
  assign s_out_payload_tvalid = 1'b0;
  assign s_out_context_tvalid = 1'b0;

endmodule // rfnoc_block_gain_oot


`default_nettype wire
