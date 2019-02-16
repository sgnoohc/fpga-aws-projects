// This is a generated file. Use and modify at your own risk.
//////////////////////////////////////////////////////////////////////////////// 
// default_nettype of none prevents implicit wire declaration.
`default_nettype none
module my_matrix_multiplier_implementation #(
  parameter integer C_M00_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M00_AXI_DATA_WIDTH = 512,
  parameter integer C_M01_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M01_AXI_DATA_WIDTH = 512,
  parameter integer C_M02_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M02_AXI_DATA_WIDTH = 512,
  parameter integer C_XFER_SIZE_WIDTH    = 32 ,
  parameter integer LP_RD_MAX_OUTSTANDING= 128
)
(
  // System Signals
  input  wire                              ap_clk         ,
  input  wire                              ap_rst_n       ,
  // AXI4 master interface m00_axi
  output wire                              m00_axi_awvalid,
  input  wire                              m00_axi_awready,
  output wire [C_M00_AXI_ADDR_WIDTH-1:0]   m00_axi_awaddr ,
  output wire [8-1:0]                      m00_axi_awlen  ,
  output wire                              m00_axi_wvalid ,
  input  wire                              m00_axi_wready ,
  output wire [C_M00_AXI_DATA_WIDTH-1:0]   m00_axi_wdata  ,
  output wire [C_M00_AXI_DATA_WIDTH/8-1:0] m00_axi_wstrb  ,
  output wire                              m00_axi_wlast  ,
  input  wire                              m00_axi_bvalid ,
  output wire                              m00_axi_bready ,
  output wire                              m00_axi_arvalid,
  input  wire                              m00_axi_arready,
  output wire [C_M00_AXI_ADDR_WIDTH-1:0]   m00_axi_araddr ,
  output wire [8-1:0]                      m00_axi_arlen  ,
  input  wire                              m00_axi_rvalid ,
  output wire                              m00_axi_rready ,
  input  wire [C_M00_AXI_DATA_WIDTH-1:0]   m00_axi_rdata  ,
  input  wire                              m00_axi_rlast  ,
  // AXI4 master interface m01_axi
  output wire                              m01_axi_awvalid,
  input  wire                              m01_axi_awready,
  output wire [C_M01_AXI_ADDR_WIDTH-1:0]   m01_axi_awaddr ,
  output wire [8-1:0]                      m01_axi_awlen  ,
  output wire                              m01_axi_wvalid ,
  input  wire                              m01_axi_wready ,
  output wire [C_M01_AXI_DATA_WIDTH-1:0]   m01_axi_wdata  ,
  output wire [C_M01_AXI_DATA_WIDTH/8-1:0] m01_axi_wstrb  ,
  output wire                              m01_axi_wlast  ,
  input  wire                              m01_axi_bvalid ,
  output wire                              m01_axi_bready ,
  output wire                              m01_axi_arvalid,
  input  wire                              m01_axi_arready,
  output wire [C_M01_AXI_ADDR_WIDTH-1:0]   m01_axi_araddr ,
  output wire [8-1:0]                      m01_axi_arlen  ,
  input  wire                              m01_axi_rvalid ,
  output wire                              m01_axi_rready ,
  input  wire [C_M01_AXI_DATA_WIDTH-1:0]   m01_axi_rdata  ,
  input  wire                              m01_axi_rlast  ,
  // AXI4 master interface m02_axi
  output wire                              m02_axi_awvalid,
  input  wire                              m02_axi_awready,
  output wire [C_M02_AXI_ADDR_WIDTH-1:0]   m02_axi_awaddr ,
  output wire [8-1:0]                      m02_axi_awlen  ,
  output wire                              m02_axi_wvalid ,
  input  wire                              m02_axi_wready ,
  output wire [C_M02_AXI_DATA_WIDTH-1:0]   m02_axi_wdata  ,
  output wire [C_M02_AXI_DATA_WIDTH/8-1:0] m02_axi_wstrb  ,
  output wire                              m02_axi_wlast  ,
  input  wire                              m02_axi_bvalid ,
  output wire                              m02_axi_bready ,
  output wire                              m02_axi_arvalid,
  input  wire                              m02_axi_arready,
  output wire [C_M02_AXI_ADDR_WIDTH-1:0]   m02_axi_araddr ,
  output wire [8-1:0]                      m02_axi_arlen  ,
  input  wire                              m02_axi_rvalid ,
  output wire                              m02_axi_rready ,
  input  wire [C_M02_AXI_DATA_WIDTH-1:0]   m02_axi_rdata  ,
  input  wire                              m02_axi_rlast  ,
  // SDx Control Signals
  input  wire                              ap_start       ,
  output wire                              ap_idle        ,
  output wire                              ap_done        ,
  input  wire [32-1:0]                     nrows_A        ,
  input  wire [32-1:0]                     ncols_A        ,
  input  wire [32-1:0]                     ncols_B        ,
  input  wire [64-1:0]                     in_A           ,
  input  wire [64-1:0]                     in_B           ,
  input  wire [64-1:0]                     out_C          
);


timeunit 1ps;
timeprecision 1ps;

///////////////////////////////////////////////////////////////////////////////
// Local Parameters
///////////////////////////////////////////////////////////////////////////////
// Large enough for interesting traffic.
localparam integer  LP_DEFAULT_LENGTH_IN_BYTES = 16384;
localparam integer  LP_NUM_EXAMPLES    = 3;
localparam integer  MATRIX_WIDTH = 16;
localparam integer  MATRIX_DEPTH = 16;

///////////////////////////////////////////////////////////////////////////////
// Wires and Variables
///////////////////////////////////////////////////////////////////////////////
(* KEEP = "yes" *)
logic                                areset                         = 1'b0;
logic                                ap_start_r                     = 1'b0;
logic                                ap_idle_r                      = 1'b1;
logic                                ap_start_pulse                ;
logic [LP_NUM_EXAMPLES-1:0]          ap_done_i                     ;
logic [LP_NUM_EXAMPLES-1:0]          ap_done_r                      = {LP_NUM_EXAMPLES{1'b0}};
logic [32-1:0]                       ctrl_xfer_size_in_bytes        = LP_DEFAULT_LENGTH_IN_BYTES;
logic [32-1:0]                       ctrl_constant                  = 32'd1;

///////////////////////////////////////////////////////////////////////////////
// Begin RTL
///////////////////////////////////////////////////////////////////////////////

// Register and invert reset signal.
always @(posedge ap_clk) begin
  areset <= ~ap_rst_n;
end

// create pulse when ap_start transitions to 1
always @(posedge ap_clk) begin
  begin
    ap_start_r <= ap_start;
  end
end

assign ap_start_pulse = ap_start & ~ap_start_r;

// ap_idle is asserted when done is asserted, it is de-asserted when ap_start_pulse
// is asserted
always @(posedge ap_clk) begin
  if (areset) begin
    ap_idle_r <= 1'b1;
  end
  else begin
    ap_idle_r <= ap_done ? 1'b1 :
      ap_start_pulse ? 1'b0 : ap_idle;
  end
end

assign ap_idle = ap_idle_r;

// Done logic
always @(posedge ap_clk) begin
  if (areset) begin
    ap_done_r <= '0;
  end
  else begin
    ap_done_r <= (ap_start_pulse | ap_done) ? '0 : ap_done_r | ap_done_i;
  end
end

assign ap_done = &ap_done_r;


//=================================================================================
//
// Matrix input A (in_A)
//
//=================================================================================

// AXI4 Read Master, output format is an AXI4-Stream master, one stream per thread.
//---------
logic                            read_done_in_A;
logic                            rd_tvalid_in_A;
logic                            rd_tready_in_A;
logic                            rd_tlast_in_A;
logic [C_M00_AXI_DATA_WIDTH-1:0] rd_tdata_in_A;
//---------
my_matrix_multiplier_example_axi_read_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M00_AXI_ADDR_WIDTH  ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M00_AXI_DATA_WIDTH  ) ,
  .C_XFER_SIZE_WIDTH   ( C_XFER_SIZE_WIDTH     ) ,
  .C_MAX_OUTSTANDING   ( LP_RD_MAX_OUTSTANDING ) ,
  .C_INCLUDE_DATA_FIFO ( 1                     )
)
inst_axi_read_master_in_A (
  .aclk                    ( ap_clk                  ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start                ) ,
  .ctrl_done               ( read_done_in_A          ) ,
  .ctrl_addr_offset        ( in_A                    ) ,
  .ctrl_xfer_size_in_bytes ( ctrl_xfer_size_in_bytes ) ,
  .m_axi_arvalid           ( m00_axi_arvalid         ) ,
  .m_axi_arready           ( m00_axi_arready         ) ,
  .m_axi_araddr            ( m00_axi_araddr          ) ,
  .m_axi_arlen             ( m00_axi_arlen           ) ,
  .m_axi_rvalid            ( m00_axi_rvalid          ) ,
  .m_axi_rready            ( m00_axi_rready          ) ,
  .m_axi_rdata             ( m00_axi_rdata           ) ,
  .m_axi_rlast             ( m00_axi_rlast           ) ,
  .m_axis_aclk             ( ap_clk                  ) ,
  .m_axis_areset           ( areset                  ) ,
  .m_axis_tvalid           ( rd_tvalid_in_A          ) ,
  .m_axis_tready           ( rd_tready_in_A          ) ,
  .m_axis_tlast            ( rd_tlast_in_A           ) ,
  .m_axis_tdata            ( rd_tdata_in_A           )
);

//=================================================================================
//
// Matrix input B (in_B)
//
//=================================================================================

// AXI4 Read Master, output format is an AXI4-Stream master, one stream per thread.
//---------
logic                            read_done_in_B;
logic                            rd_tvalid_in_B;
logic                            rd_tready_in_B;
logic                            rd_tlast_in_B;
logic [C_M01_AXI_DATA_WIDTH-1:0] rd_tdata_in_B;
//---------
my_matrix_multiplier_example_axi_read_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M01_AXI_ADDR_WIDTH  ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M01_AXI_DATA_WIDTH  ) ,
  .C_XFER_SIZE_WIDTH   ( C_XFER_SIZE_WIDTH     ) ,
  .C_MAX_OUTSTANDING   ( LP_RD_MAX_OUTSTANDING ) ,
  .C_INCLUDE_DATA_FIFO ( 1                     )
)
inst_axi_read_master_in_B (
  .aclk                    ( ap_clk                  ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start                ) ,
  .ctrl_done               ( read_done_in_B          ) ,
  .ctrl_addr_offset        ( in_B                    ) ,
  .ctrl_xfer_size_in_bytes ( ctrl_xfer_size_in_bytes ) ,
  .m_axi_arvalid           ( m01_axi_arvalid         ) ,
  .m_axi_arready           ( m01_axi_arready         ) ,
  .m_axi_araddr            ( m01_axi_araddr          ) ,
  .m_axi_arlen             ( m01_axi_arlen           ) ,
  .m_axi_rvalid            ( m01_axi_rvalid          ) ,
  .m_axi_rready            ( m01_axi_rready          ) ,
  .m_axi_rdata             ( m01_axi_rdata           ) ,
  .m_axi_rlast             ( m01_axi_rlast           ) ,
  .m_axis_aclk             ( ap_clk                  ) ,
  .m_axis_areset           ( areset                  ) ,
  .m_axis_tvalid           ( rd_tvalid_in_B          ) ,
  .m_axis_tready           ( rd_tready_in_B          ) ,
  .m_axis_tlast            ( rd_tlast_in_B           ) ,
  .m_axis_tdata            ( rd_tdata_in_B           )
);

//=================================================================================
//
// Matrix output C (out_C)
//
//=================================================================================

// AXI4 Read Master, output format is an AXI4-Stream master, one stream per thread.
//---------
logic                            write_done;
logic                            wr_tvalid_out_C;
logic                            wr_tready_out_C;
logic [C_M02_AXI_DATA_WIDTH-1:0] wr_tdata_out_C;
//---------
my_matrix_multiplier_example_axi_write_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M02_AXI_ADDR_WIDTH  ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M02_AXI_DATA_WIDTH  ) ,
  .C_XFER_SIZE_WIDTH   ( C_XFER_SIZE_WIDTH     ) ,
  .C_MAX_OUTSTANDING   ( LP_RD_MAX_OUTSTANDING ) ,
  .C_INCLUDE_DATA_FIFO ( 1                     )
)
inst_axi_read_master_out_C (
  .aclk                    ( ap_clk                  ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start                ) ,
  .ctrl_done               ( write_done              ) ,
  .ctrl_addr_offset        ( out_C                   ) ,
  .ctrl_xfer_size_in_bytes ( ctrl_xfer_size_in_bytes ) ,
  .m_axi_awvalid           ( m02_axi_awvalid         ) ,
  .m_axi_awready           ( m02_axi_awready         ) ,
  .m_axi_awaddr            ( m02_axi_awaddr          ) ,
  .m_axi_awlen             ( m02_axi_awlen           ) ,
  .m_axi_wvalid            ( m02_axi_wvalid          ) ,
  .m_axi_wready            ( m02_axi_wready          ) ,
  .m_axi_wdata             ( m02_axi_wdata           ) ,
  .m_axi_wstrb             ( m02_axi_wstrb           ) ,
  .m_axi_wlast             ( m02_axi_wlast           ) ,
  .m_axi_bvalid            ( m02_axi_bvalid          ) ,
  .m_axi_bready            ( m02_axi_bready          ) ,
  .s_axis_aclk             ( ap_clk                  ) ,
  .s_axis_areset           ( areset                  ) ,
  .s_axis_tvalid           ( wr_tvalid_out_C         ) ,
  .s_axis_tready           ( wr_tready_out_C         ) ,
  .s_axis_tdata            ( wr_tdata_out_C          )
);

//=================================================================================
//
//
// Parsing input streams into several words
//
//
//=================================================================================

logic [MATRIX_DEPTH-1:0]         s_fifo_in_A_word_tready;
logic [MATRIX_DEPTH-1:0]         s_fifo_in_A_word_tvalid;
logic [MATRIX_DEPTH-1:0]         s_fifo_in_A_word_tlast;
logic [MATRIX_DEPTH-1:0][32-1:0] s_fifo_in_A_word_tdata;

logic [MATRIX_DEPTH-1:0]         m_fifo_in_A_word_tready;
logic [MATRIX_DEPTH-1:0]         m_fifo_in_A_word_tvalid;
logic [MATRIX_DEPTH-1:0]         m_fifo_in_A_word_tlast;
logic [MATRIX_DEPTH-1:0][32-1:0] m_fifo_in_A_word_tdata;

genvar ith_word_in_A;
generate
    for (ith_word_in_A = 0; ith_word_in_A < MATRIX_DEPTH; ith_word_in_A++) begin: parse_words_in_A
        axis_data_fifo_32bit inst_fifo_in_A_word (
          .s_axis_aresetn     ( areset                                 ) , // input wire s_axis_aresetn
          .s_axis_aclk        ( ap_clk                                 ) , // input wire s_axis_aclk
          .s_axis_tvalid      ( s_fifo_in_A_word_tvalid[ith_word_in_A] ) , // input wire s_axis_tvalid
          .s_axis_tready      ( s_fifo_in_A_word_tready[ith_word_in_A] ) , // output wire s_axis_tready
          .s_axis_tdata       ( s_fifo_in_A_word_tdata[ith_word_in_A]  ) , // input wire [31 : 0] s_axis_tdata
          .s_axis_tlast       ( s_fifo_in_A_word_tlast[ith_word_in_A]  ) , // input wire s_axis_tlast
          .m_axis_tvalid      ( m_fifo_in_A_word_tvalid[ith_word_in_A] ) , // output wire m_axis_tvalid
          .m_axis_tready      ( 1'b1                                   ) , // input wire m_axis_tready
          // .m_axis_tready      ( m_fifo_in_A_word_tready[ith_word_in_A] ) , // input wire m_axis_tready
          .m_axis_tdata       ( m_fifo_in_A_word_tdata[ith_word_in_A]  ) , // output wire [31 : 0] m_axis_tdata
          .m_axis_tlast       ( m_fifo_in_A_word_tlast[ith_word_in_A]  ) , // output wire m_axis_tlast
          .axis_data_count    (                                        ) , // output wire [31 : 0] axis_data_count
          .axis_wr_data_count (                                        ) , // output wire [31 : 0] axis_wr_data_count
          .axis_rd_data_count (                                        )   // output wire [31 : 0] axis_rd_data_count
        );
    end
endgenerate

// Wire the in_A read module to individual fifos
assign s_fifo_in_A_word_tvalid = {MATRIX_DEPTH{rd_tvalid_in_A}};
assign s_fifo_in_A_word_tlast  = {MATRIX_DEPTH{rd_tlast_in_A}};
assign rd_tready_in_A = &s_fifo_in_A_word_tready;
genvar i_in_A_to_s_fifo;
generate
    for (i_in_A_to_s_fifo = 0; i_in_A_to_s_fifo < MATRIX_DEPTH; i_in_A_to_s_fifo++)
        assign s_fifo_in_A_word_tdata[i_in_A_to_s_fifo] = rd_tdata_in_A[i_in_A_to_s_fifo*32+:32];
endgenerate

logic [MATRIX_WIDTH-1:0]         s_fifo_in_B_word_tready;
logic [MATRIX_WIDTH-1:0]         s_fifo_in_B_word_tvalid;
logic [MATRIX_WIDTH-1:0]         s_fifo_in_B_word_tlast;
logic [MATRIX_WIDTH-1:0][32-1:0] s_fifo_in_B_word_tdata;
                                
logic [MATRIX_WIDTH-1:0]         m_fifo_in_B_word_tready;
logic [MATRIX_WIDTH-1:0]         m_fifo_in_B_word_tvalid;
logic [MATRIX_WIDTH-1:0]         m_fifo_in_B_word_tlast;
logic [MATRIX_WIDTH-1:0][32-1:0] m_fifo_in_B_word_tdata;

genvar ith_word_in_B;
generate
    for (ith_word_in_B = 0; ith_word_in_B < MATRIX_WIDTH; ith_word_in_B++) begin: parse_words_in_B
        axis_data_fifo_32bit inst_fifo_in_B_word (
          .s_axis_aresetn     ( areset                                 ) , // input wire s_axis_aresetn
          .s_axis_aclk        ( ap_clk                                 ) , // input wire s_axis_aclk
          .s_axis_tvalid      ( s_fifo_in_B_word_tvalid[ith_word_in_B] ) , // input wire s_axis_tvalid
          .s_axis_tready      ( s_fifo_in_B_word_tready[ith_word_in_B] ) , // output wire s_axis_tready
          .s_axis_tdata       ( s_fifo_in_B_word_tdata[ith_word_in_B]  ) , // input wire [31 : 0] s_axis_tdata
          .s_axis_tlast       ( s_fifo_in_B_word_tlast[ith_word_in_B]  ) , // input wire s_axis_tlast
          .m_axis_tvalid      ( m_fifo_in_B_word_tvalid[ith_word_in_B] ) , // output wire m_axis_tvalid
          .m_axis_tready      ( 1'b1                                   ) , // input wire m_axis_tready
          // .m_axis_tready      ( m_fifo_in_B_word_tready[ith_word_in_B] ) , // input wire m_axis_tready
          .m_axis_tdata       ( m_fifo_in_B_word_tdata[ith_word_in_B]  ) , // output wire [31 : 0] m_axis_tdata
          .m_axis_tlast       ( m_fifo_in_B_word_tlast[ith_word_in_B]  ) , // output wire m_axis_tlast
          .axis_data_count    (                                        ) , // output wire [31 : 0] axis_data_count
          .axis_wr_data_count (                                        ) , // output wire [31 : 0] axis_wr_data_count
          .axis_rd_data_count (                                        )   // output wire [31 : 0] axis_rd_data_count
        );
    end
endgenerate

// Wire the in_B read module to individual fifos
assign s_fifo_in_B_word_tvalid = {MATRIX_WIDTH{rd_tvalid_in_B}};
assign s_fifo_in_B_word_tlast  = {MATRIX_WIDTH{rd_tlast_in_B}};
assign rd_tready_in_B = &s_fifo_in_B_word_tready;
genvar i_in_B_to_s_fifo;
generate
    for (i_in_B_to_s_fifo = 0; i_in_B_to_s_fifo < MATRIX_WIDTH; i_in_B_to_s_fifo++)
        assign s_fifo_in_B_word_tdata[i_in_B_to_s_fifo] = rd_tdata_in_B[i_in_B_to_s_fifo*32+:32];
endgenerate

//=================================================================================
//
//
// Multiplier
//
//
//=================================================================================

// logic                                              mm_tready;
// logic                                              mm_tvalid;
// logic [MATRIX_WIDTH-1:0][MATRIX_DEPTH-1:0][32-1:0] mm_tdata;

// genvar ii;
// genvar jj;
// generate
//     for (ii = 0; ii < MATRIX_DEPTH; ii++) begin: multipliers_A
//         for (jj = 0; jj < MATRIX_DEPTH; jj++) begin: multipliers_B

//             logic        AxB_to_accumul_tvalid;
//             logic        AxB_to_accumul_tready;
//             logic [31:0] AxB_to_accumul_tdata;
//             logic        AxB_to_accumul_tlast;

//             floating_point_AxB multiplier (
//               .aclk                 ( ap_clk                     ) , // input wire aclk
//               .s_axis_a_tvalid      ( rd_tvalid_in_A             ) , // input wire s_axis_a_tvalid
//               .s_axis_a_tready      ( rd_tready_in_A             ) , // output wire s_axis_a_tready
//               .s_axis_a_tdata       ( rd_tdata_in_A[(ii*32)+:32] ) , // input wire [31 : 0] s_axis_a_tdata
//               .s_axis_a_tlast       ( rd_tlast_in_A              ) , // input wire s_axis_a_tlast
//               .s_axis_b_tvalid      ( rd_tvalid_in_B             ) , // input wire s_axis_b_tvalid
//               .s_axis_b_tready      ( rd_tready_in_B             ) , // output wire s_axis_b_tready
//               .s_axis_b_tdata       ( rd_tdata_in_B[(jj*32)+:32] ) , // input wire [31 : 0] s_axis_b_tdata
//               .s_axis_b_tlast       ( rd_tlast_in_B              ) , // input wire s_axis_b_tlast
//               .m_axis_result_tvalid ( AxB_to_accumul_tvalid      ) , // output wire m_axis_result_tvalid
//               .m_axis_result_tready ( AxB_to_accumul_tready      ) , // input wire m_axis_result_tready
//               .m_axis_result_tdata  ( AxB_to_accumul_tdata       ) , // output wire [31 : 0] m_axis_result_tdata
//               .m_axis_result_tlast  ( AxB_to_accumul_tlast       )   // output wire m_axis_result_tlast
//             );

//             floating_point_accumulator accumulator (
//               .aclk                 ( ap_clk               ) , // input wire aclk
//               .s_axis_a_tvalid      ( AxB_to_accumul_tvalid) , // input wire s_axis_a_tvalid
//               .s_axis_a_tready      ( AxB_to_accumul_tready) , // output wire s_axis_a_tready
//               .s_axis_a_tdata       ( AxB_to_accumul_tdata ) , // input wire [31 : 0] s_axis_a_tdata
//               .s_axis_a_tlast       ( AxB_to_accumul_tlast ) , // input wire s_axis_a_tlast
//               .m_axis_result_tvalid ( mm_tvalid            ) , // output wire m_axis_result_tvalid
//               .m_axis_result_tready ( mm_tready            ) , // input wire m_axis_result_tready
//               .m_axis_result_tdata  ( mm_tdata[ii][jj]     ) , // output wire [31 : 0] m_axis_result_tdata
//               .m_axis_result_tlast  (                      )   // output wire m_axis_result_tlast
//             );

//         end
//     end
// endgenerate


// axis_interconnect_0 inst_axis_interconnect_in_A_plus_in_B (
//   .ACLK                     ( ap_clk                   ) , // input wire aclk
//   .ARESETN                  ( areset                   ) , // input wire aresetn
//   .S00_AXIS_ACLK            ( ap_clk                   ) , // input wire s00_axis_aclk
//   .S01_AXIS_ACLK            ( ap_clk                   ) , // input wire s01_axis_aclk
//   .S00_AXIS_ARESETN         ( areset                   ) , // input wire s00_axis_aresetn
//   .S01_AXIS_ARESETN         ( areset                   ) , // input wire s01_axis_aresetn
//   .S00_AXIS_TVALID          ( rd_tvalid_in_A           ) , // input wire s00_axis_tvalid
//   .S01_AXIS_TVALID          ( rd_tvalid_in_B           ) , // input wire s01_axis_tvalid
//   .S00_AXIS_TREADY          ( rd_tready_in_A           ) , // output wire s00_axis_tready
//   .S01_AXIS_TREADY          ( rd_tready_in_B           ) , // output wire s01_axis_tready
//   .S00_AXIS_TDATA           ( rd_tdata_in_A            ) , // input wire [511 : 0] s00_axis_tdata
//   .S01_AXIS_TDATA           ( rd_tdata_in_B            ) , // input wire [511 : 0] s01_axis_tdata
//   .S00_AXIS_TLAST           ( rd_tlast_in_A            ) , // input wire s00_axis_tlast
//   .S01_AXIS_TLAST           ( rd_tlast_in_B            ) , // input wire s01_axis_tlast
//   .M00_AXIS_ACLK            ( ap_clk                   ) , // input wire m00_axis_aclk
//   .M00_AXIS_ARESETN         ( areset                   ) , // input wire m00_axis_aresetn
//   .M00_AXIS_TVALID          ( wr_tvalid_out_C          ) , // output wire m00_axis_tvalid
//   .M00_AXIS_TREADY          ( wr_tready_out_C          ) , // input wire m00_axis_tready
//   .M00_AXIS_TDATA           ( wr_tdata_out_C           ) , // output wire [511 : 0] m00_axis_tdata
//   .M00_AXIS_TLAST           (                          ) , // output wire m00_axis_tlast
//   .S00_ARB_REQ_SUPPRESS     (                          ) , // input wire s00_arb_req_suppress
//   .S01_ARB_REQ_SUPPRESS     (                          ) , // input wire s01_arb_req_suppress
//   .M00_SPARSE_TKEEP_REMOVED (                          ) , // output wire m00_sparse_tkeep_removed
//   .M00_FIFO_DATA_COUNT      (                          )   // output wire [31 : 0] m00_fifo_data_count
// );

endmodule : my_matrix_multiplier_implementation
`default_nettype wire
