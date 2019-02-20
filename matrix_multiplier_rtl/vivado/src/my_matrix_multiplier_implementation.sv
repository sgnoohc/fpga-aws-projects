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
  parameter integer LP_RD_MAX_OUTSTANDING= 128,
  parameter integer LP_WR_MAX_OUTSTANDING= 32
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
localparam integer  LP_DEFAULT_LENGTH_IN_BYTES = 1024;
localparam integer  LP_NUM_EXAMPLES    = 3;
localparam integer  MATRIX_WIDTH = 16;
localparam integer  MATRIX_DEPTH = 16;
localparam integer  MATRIX_ITER = 16;

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
  .ctrl_start              ( ap_start_pulse          ) ,
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
  .ctrl_start              ( ap_start_pulse          ) ,
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

// AXI4 Write Master, output format is an AXI4-Stream master, one stream per thread.
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
  .C_MAX_OUTSTANDING   ( LP_WR_MAX_OUTSTANDING ) ,
  .C_INCLUDE_DATA_FIFO ( 1                     )
)
inst_axi_write_master_out_C (
  .aclk                    ( ap_clk                  ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start_pulse          ) ,
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

//========================================================================================
// FSM for counting number of inputs pushed into FIFO so I can toggle TLAST the way I want
//========================================================================================

logic [MATRIX_ITER-1:0] in_A_word_counter = 16'h0001;
logic                   in_A_word_tlast = 0;
always @(posedge ap_clk) begin
    if (rd_tvalid_in_A && rd_tready_in_A && in_A_word_counter == 16'h0000) begin
        in_A_word_counter <= 16'h0001;
    end
    else if (rd_tvalid_in_A && rd_tready_in_A && in_A_word_counter == 16'h8000) begin
        in_A_word_counter <= 16'h0001;
    end
    else if (rd_tvalid_in_A && rd_tready_in_A && in_A_word_counter != 16'h0000) begin
        in_A_word_counter <= in_A_word_counter << 1;
    end
end

always @(posedge ap_clk) begin
    if (in_A_word_counter[MATRIX_ITER-2] == 1'b1 && rd_tvalid_in_A && rd_tready_in_A) begin
        in_A_word_tlast <= 1;
    end
    if (in_A_word_tlast == 1 && rd_tready_in_A && rd_tvalid_in_A) begin
        in_A_word_tlast <= 0;
    end
end

logic [MATRIX_ITER-1:0] in_B_word_counter = 16'h0000;
logic                   in_B_word_tlast = 0;
always @(posedge ap_clk) begin
    if (rd_tvalid_in_B && rd_tready_in_B && in_B_word_counter == 16'h0000) begin
        in_B_word_counter <= 16'h0001;
    end
    else if (rd_tvalid_in_B && rd_tready_in_B && in_B_word_counter == 16'h8000) begin
        in_B_word_counter <= 16'h0001;
    end
    else if (rd_tvalid_in_B && rd_tready_in_B && in_B_word_counter != 16'h0000) begin
        in_B_word_counter <= in_B_word_counter << 1;
    end
end

always @(posedge ap_clk) begin
    if (in_B_word_counter[MATRIX_ITER-2] == 1'b1 && rd_tvalid_in_B && rd_tready_in_B) begin
        in_B_word_tlast <= 1;
    end
    if (in_B_word_tlast == 1 && rd_tready_in_B && rd_tvalid_in_B) begin
        in_B_word_tlast <= 0;
    end
end


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
          .s_axis_aresetn     ( ap_rst_n                               ) , // input wire s_axis_aresetn
          .s_axis_aclk        ( ap_clk                                 ) , // input wire s_axis_aclk
          .s_axis_tvalid      ( s_fifo_in_A_word_tvalid[ith_word_in_A] ) , // input wire s_axis_tvalid
          .s_axis_tready      ( s_fifo_in_A_word_tready[ith_word_in_A] ) , // output wire s_axis_tready
          .s_axis_tdata       ( s_fifo_in_A_word_tdata[ith_word_in_A]  ) , // input wire [31 : 0] s_axis_tdata
          .s_axis_tlast       ( s_fifo_in_A_word_tlast[ith_word_in_A]  ) , // input wire s_axis_tlast
          .m_axis_tvalid      ( m_fifo_in_A_word_tvalid[ith_word_in_A] ) , // output wire m_axis_tvalid
          .m_axis_tready      ( m_fifo_in_A_word_tready[ith_word_in_A] ) , // input wire m_axis_tready
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
// assign s_fifo_in_A_word_tlast  = {MATRIX_DEPTH{rd_tlast_in_A}};
assign s_fifo_in_A_word_tlast  = {MATRIX_DEPTH{in_A_word_tlast}};
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
          .s_axis_aresetn     ( ap_rst_n                               ) , // input wire s_axis_aresetn
          .s_axis_aclk        ( ap_clk                                 ) , // input wire s_axis_aclk
          .s_axis_tvalid      ( s_fifo_in_B_word_tvalid[ith_word_in_B] ) , // input wire s_axis_tvalid
          .s_axis_tready      ( s_fifo_in_B_word_tready[ith_word_in_B] ) , // output wire s_axis_tready
          .s_axis_tdata       ( s_fifo_in_B_word_tdata[ith_word_in_B]  ) , // input wire [31 : 0] s_axis_tdata
          .s_axis_tlast       ( s_fifo_in_B_word_tlast[ith_word_in_B]  ) , // input wire s_axis_tlast
          .m_axis_tvalid      ( m_fifo_in_B_word_tvalid[ith_word_in_B] ) , // output wire m_axis_tvalid
          .m_axis_tready      ( m_fifo_in_B_word_tready[ith_word_in_B] ) , // input wire m_axis_tready
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
// assign s_fifo_in_B_word_tlast  = {MATRIX_WIDTH{rd_tlast_in_B}};
assign s_fifo_in_B_word_tlast  = {MATRIX_WIDTH{in_B_word_tlast}};
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

logic [MATRIX_DEPTH-1:0][MATRIX_WIDTH-1:0]         mm_tready;
logic [MATRIX_DEPTH-1:0][MATRIX_WIDTH-1:0]         mm_tvalid;
logic [MATRIX_DEPTH-1:0][MATRIX_WIDTH-1:0][32-1:0] mm_tdata;
logic [MATRIX_DEPTH-1:0][MATRIX_WIDTH-1:0]         mm_tlast;

genvar ii;
genvar jj;
generate
    for (ii = 0; ii < MATRIX_DEPTH; ii++) begin: multipliers_A
        for (jj = 0; jj < MATRIX_WIDTH; jj++) begin: multipliers_B

            logic        AxB_to_accumul_tvalid;
            logic        AxB_to_accumul_tready;
            logic [31:0] AxB_to_accumul_tdata;
            logic        AxB_to_accumul_tlast;
            logic        accumul_result_tready;
            logic        accumul_result_tvalid;
            logic        accumul_result_tvalid_and_tlast;
            logic [31:0] accumul_result_tdata;
            logic        accumul_result_tlast;

            assign accumul_result_tvalid_and_tlast = accumul_result_tvalid && accumul_result_tlast;

            floating_point_AxB multiplier (
              .aclk                 ( ap_clk                                ) , // input wire aclk
              .s_axis_a_tvalid      ( m_fifo_in_A_word_tvalid[ii]           ) , // input wire s_axis_a_tvalid
              .s_axis_a_tready      ( m_fifo_in_A_word_tready[ii]           ) , // output wire s_axis_a_tready
              .s_axis_a_tdata       ( m_fifo_in_A_word_tdata[ii]            ) , // input wire [31 : 0] s_axis_a_tdata
              .s_axis_a_tlast       ( m_fifo_in_A_word_tlast[ii]            ) , // input wire s_axis_a_tlast
              .s_axis_b_tvalid      ( m_fifo_in_B_word_tvalid[jj]           ) , // input wire s_axis_b_tvalid
              .s_axis_b_tready      ( m_fifo_in_B_word_tready[jj]           ) , // output wire s_axis_b_tready
              .s_axis_b_tdata       ( m_fifo_in_B_word_tdata[jj]            ) , // input wire [31 : 0] s_axis_b_tdata
              .s_axis_b_tlast       ( m_fifo_in_B_word_tlast[jj]            ) , // input wire s_axis_b_tlast
              .m_axis_result_tvalid ( AxB_to_accumul_tvalid                 ) , // output wire m_axis_result_tvalid
              .m_axis_result_tready ( AxB_to_accumul_tready                 ) , // input wire m_axis_result_tready
              .m_axis_result_tdata  ( AxB_to_accumul_tdata                  ) , // output wire [31 : 0] m_axis_result_tdata
              .m_axis_result_tlast  ( AxB_to_accumul_tlast                  )   // output wire m_axis_result_tlast
            );

            floating_point_accumulator accumulator (
              .aclk                 ( ap_clk               ) , // input wire aclk
              .s_axis_a_tvalid      ( AxB_to_accumul_tvalid) , // input wire s_axis_a_tvalid
              .s_axis_a_tready      ( AxB_to_accumul_tready) , // output wire s_axis_a_tready
              .s_axis_a_tdata       ( AxB_to_accumul_tdata ) , // input wire [31 : 0] s_axis_a_tdata
              .s_axis_a_tlast       ( AxB_to_accumul_tlast ) , // input wire s_axis_a_tlast
              .m_axis_result_tvalid ( accumul_result_tvalid) , // output wire m_axis_result_tvalid
              .m_axis_result_tready ( accumul_result_tready) , // input wire m_axis_result_tready
              .m_axis_result_tdata  ( accumul_result_tdata ) , // output wire [31 : 0] m_axis_result_tdata
              .m_axis_result_tlast  ( accumul_result_tlast )   // output wire m_axis_result_tlast
            );

            axis_data_fifo_32bit result_fifo (
              .s_axis_aresetn     ( ap_rst_n                               ) , // input wire s_axis_aresetn
              .s_axis_aclk        ( ap_clk                                 ) , // input wire s_axis_aclk
              .s_axis_tvalid      ( accumul_result_tvalid_and_tlast        ) , // input wire s_axis_tvalid
              .s_axis_tready      ( accumul_result_tready                  ) , // output wire s_axis_tready
              .s_axis_tdata       ( accumul_result_tdata                   ) , // input wire [31 : 0] s_axis_tdata
              .s_axis_tlast       ( accumul_result_tlast                   ) , // input wire s_axis_tlast
              .m_axis_tvalid      ( mm_tvalid[ii][jj]                      ) , // output wire m_axis_tvalid
              .m_axis_tready      ( mm_tready[ii][jj]                      ) , // input wire m_axis_tready
              .m_axis_tdata       ( mm_tdata[ii][jj]                       ) , // output wire [31 : 0] m_axis_tdata
              .m_axis_tlast       ( mm_tlast[ii][jj]                       ) , // output wire m_axis_tlast
              .axis_data_count    (                                        ) , // output wire [31 : 0] axis_data_count
              .axis_wr_data_count (                                        ) , // output wire [31 : 0] axis_wr_data_count
              .axis_rd_data_count (                                        )   // output wire [31 : 0] axis_rd_data_count
            );

        end
    end
endgenerate


//
// Combiner
//

logic [MATRIX_DEPTH-1:0]        m_axis_combiner_tvalid;
logic [MATRIX_DEPTH-1:0]        m_axis_combiner_tready;
logic [MATRIX_DEPTH-1:0]        m_axis_combiner_tlast;
logic [MATRIX_DEPTH-1:0][511:0] m_axis_combiner_tdata;

genvar ith_row_out_C;
genvar ith_col_out_C;
generate
    for (ith_row_out_C = 0; ith_row_out_C < MATRIX_DEPTH; ith_row_out_C++) begin

        logic [MATRIX_WIDTH-1:0] s_axis_combiner_tvalid;
        logic [MATRIX_WIDTH-1:0] s_axis_combiner_tready;
        logic [MATRIX_WIDTH-1:0] s_axis_combiner_tlast;
        logic [MATRIX_WIDTH*32-1:0] s_axis_combiner_tdata;

        for (ith_col_out_C = 0; ith_col_out_C < MATRIX_WIDTH; ith_col_out_C++) begin
            assign s_axis_combiner_tvalid[ith_col_out_C] = mm_tvalid[ith_row_out_C][ith_col_out_C];
            assign mm_tready[ith_row_out_C][ith_col_out_C] = s_axis_combiner_tready[ith_col_out_C];
            assign s_axis_combiner_tlast[ith_col_out_C] = mm_tlast[ith_row_out_C][ith_col_out_C];
            assign s_axis_combiner_tdata[(ith_col_out_C)*32+:32] = mm_tdata[ith_row_out_C][ith_col_out_C];
        end

        axis_combiner_0 combiner (
          .aclk          ( ap_clk                                 ) , // input wire aclk
          .aresetn       ( ap_rst_n                               ) , // input wire aresetn
          .s_axis_tvalid ( s_axis_combiner_tvalid                 ) , // input wire [15 : 0] s_axis_tvalid
          .s_axis_tready ( s_axis_combiner_tready                 ) , // output wire [15 : 0] s_axis_tready
          .s_axis_tdata  ( s_axis_combiner_tdata                  ) , // input wire [511 : 0] s_axis_tdata
          .s_axis_tlast  ( s_axis_combiner_tlast                  ) , // input wire [15 : 0] s_axis_tlast
          .m_axis_tvalid ( m_axis_combiner_tvalid[ith_row_out_C]  ) , // output wire m_axis_tvalid
          .m_axis_tready ( m_axis_combiner_tready[ith_row_out_C]  ) , // input wire m_axis_tready
          .m_axis_tdata  ( m_axis_combiner_tdata[ith_row_out_C]   ) , // output wire [511 : 0] m_axis_tdata
          .m_axis_tlast  ( m_axis_combiner_tlast[ith_row_out_C]   )   // output wire m_axis_tlast
        );
    end
endgenerate

// logic [MATRIX_DEPTH-1:0][MATRIX_DEPTH-1:0]        m_axis_combiner_tvalid_shift;
// logic [MATRIX_DEPTH-1:0][MATRIX_DEPTH-1:0]        m_axis_combiner_tready_shift;
// logic [MATRIX_DEPTH-1:0][MATRIX_DEPTH-1:0]        m_axis_combiner_tlast_shift;
// logic [MATRIX_DEPTH-1:0][MATRIX_DEPTH-1:0][511:0] m_axis_combiner_tdata_shift;

// genvar ith_shift;
// always @(posedge ap_clk) begin
//     m_axis_combiner_tvalid_shift[0] <= m_axis_combiner_tvalid;
//     m_axis_combiner_tready_shift[0] <= m_axis_combiner_tready;
//     m_axis_combiner_tdata_shift[0] <= m_axis_combiner_tdata;
//     m_axis_combiner_tlast_shift[0] <= m_axis_combiner_tlast;
// end
// generate
//     for (ith_shift = 0; ith_shift < MATRIX_DEPTH - 1; ++ith_shift) begin
//         always @(posedge ap_clk) begin
//             m_axis_combiner_tvalid_shift[ith_shift + 1] <= m_axis_combiner_tvalid_shift[ith_shift];
//             m_axis_combiner_tready_shift[ith_shift + 1] <= m_axis_combiner_tready_shift[ith_shift];
//             m_axis_combiner_tdata_shift[ith_shift + 1] <= m_axis_combiner_tdata_shift[ith_shift];
//             m_axis_combiner_tlast_shift[ith_shift + 1] <= m_axis_combiner_tlast_shift[ith_shift];
//         end
//     end
// endgenerate

// assign m_axis_combiner_tready = {MATRIX_DEPTH{1'b1}};

logic [MATRIX_DEPTH-1:0][MATRIX_DEPTH-1:0]        m_axis_combiner_tvalid_shift;
logic [MATRIX_DEPTH-1:0][MATRIX_DEPTH-1:0]        m_axis_combiner_tready_shift;
logic [MATRIX_DEPTH-1:0][MATRIX_DEPTH-1:0]        m_axis_combiner_tlast_shift;
logic [MATRIX_DEPTH-1:0][MATRIX_DEPTH-1:0][511:0] m_axis_combiner_tdata_shift;

genvar ith_shift;
genvar jth_shift;
generate
    for (ith_shift = 0; ith_shift < MATRIX_DEPTH; ++ith_shift) begin
        axis_register_slice_0 axis_shift_register (
          .aclk          ( ap_clk                                     ) , // input wire aclk
          .aresetn       ( ap_rst_n                                   ) , // input wire aresetn
          .s_axis_tvalid ( m_axis_combiner_tvalid[ith_shift]          ) , // input wire s_axis_tvalid
          .s_axis_tready ( m_axis_combiner_tready[ith_shift]          ) , // output wire s_axis_tready
          .s_axis_tdata  ( m_axis_combiner_tdata[ith_shift]           ) , // input wire [511 : 0] s_axis_tdata
          .s_axis_tlast  ( m_axis_combiner_tlast[ith_shift]           ) , // input wire s_axis_tlast
          .m_axis_tvalid ( m_axis_combiner_tvalid_shift[0][ith_shift] ) , // output wire m_axis_tvalid
          .m_axis_tready ( m_axis_combiner_tready_shift[0][ith_shift] ) , // input wire m_axis_tready
          .m_axis_tdata  ( m_axis_combiner_tdata_shift[0][ith_shift]  ) , // output wire [511 : 0] m_axis_tdata
          .m_axis_tlast  ( m_axis_combiner_tlast_shift[0][ith_shift]  )   // output wire m_axis_tlast
        );
        for (jth_shift = 1; jth_shift < ith_shift + 1; ++jth_shift) begin
            axis_register_slice_0 axis_shift_register (
              .aclk          ( ap_clk                                               ) , // input wire aclk
              .aresetn       ( ap_rst_n                                             ) , // input wire aresetn
              .s_axis_tvalid ( m_axis_combiner_tvalid_shift[jth_shift-1][ith_shift] ) , // input wire s_axis_tvalid
              .s_axis_tready ( m_axis_combiner_tready_shift[jth_shift-1][ith_shift] ) , // output wire s_axis_tready
              .s_axis_tdata  ( m_axis_combiner_tdata_shift[jth_shift-1][ith_shift]  ) , // input wire [511 : 0] s_axis_tdata
              .s_axis_tlast  ( m_axis_combiner_tlast_shift[jth_shift-1][ith_shift]  ) , // input wire s_axis_tlast
              .m_axis_tvalid ( m_axis_combiner_tvalid_shift[jth_shift][ith_shift]   ) , // output wire m_axis_tvalid
              .m_axis_tready ( m_axis_combiner_tready_shift[jth_shift][ith_shift]   ) , // input wire m_axis_tready
              .m_axis_tdata  ( m_axis_combiner_tdata_shift[jth_shift][ith_shift]    ) , // output wire [511 : 0] m_axis_tdata
              .m_axis_tlast  ( m_axis_combiner_tlast_shift[jth_shift][ith_shift]    )   // output wire m_axis_tlast
            );
        end
    end
endgenerate

logic final_output_tlast;

axis_interconnect_1 axis_interconnect (
  .ACLK                 ( ap_clk                               ) , // input wire ACLK
  .ARESETN              ( ap_rst_n                             ) , // input wire ARESETN
  .S00_AXIS_ACLK        ( ap_clk                               ) , // input wire S00_AXIS_ACLK
  .S01_AXIS_ACLK        ( ap_clk                               ) , // input wire S01_AXIS_ACLK
  .S02_AXIS_ACLK        ( ap_clk                               ) , // input wire S02_AXIS_ACLK
  .S03_AXIS_ACLK        ( ap_clk                               ) , // input wire S03_AXIS_ACLK
  .S04_AXIS_ACLK        ( ap_clk                               ) , // input wire S04_AXIS_ACLK
  .S05_AXIS_ACLK        ( ap_clk                               ) , // input wire S05_AXIS_ACLK
  .S06_AXIS_ACLK        ( ap_clk                               ) , // input wire S06_AXIS_ACLK
  .S07_AXIS_ACLK        ( ap_clk                               ) , // input wire S07_AXIS_ACLK
  .S08_AXIS_ACLK        ( ap_clk                               ) , // input wire S08_AXIS_ACLK
  .S09_AXIS_ACLK        ( ap_clk                               ) , // input wire S09_AXIS_ACLK
  .S10_AXIS_ACLK        ( ap_clk                               ) , // input wire S10_AXIS_ACLK
  .S11_AXIS_ACLK        ( ap_clk                               ) , // input wire S11_AXIS_ACLK
  .S12_AXIS_ACLK        ( ap_clk                               ) , // input wire S12_AXIS_ACLK
  .S13_AXIS_ACLK        ( ap_clk                               ) , // input wire S13_AXIS_ACLK
  .S14_AXIS_ACLK        ( ap_clk                               ) , // input wire S14_AXIS_ACLK
  .S15_AXIS_ACLK        ( ap_clk                               ) , // input wire S15_AXIS_ACLK
  .S00_AXIS_ARESETN     ( ap_rst_n                             ) , // input wire S00_AXIS_ARESETN
  .S01_AXIS_ARESETN     ( ap_rst_n                             ) , // input wire S01_AXIS_ARESETN
  .S02_AXIS_ARESETN     ( ap_rst_n                             ) , // input wire S02_AXIS_ARESETN
  .S03_AXIS_ARESETN     ( ap_rst_n                             ) , // input wire S03_AXIS_ARESETN
  .S04_AXIS_ARESETN     ( ap_rst_n                             ) , // input wire S04_AXIS_ARESETN
  .S05_AXIS_ARESETN     ( ap_rst_n                             ) , // input wire S05_AXIS_ARESETN
  .S06_AXIS_ARESETN     ( ap_rst_n                             ) , // input wire S06_AXIS_ARESETN
  .S07_AXIS_ARESETN     ( ap_rst_n                             ) , // input wire S07_AXIS_ARESETN
  .S08_AXIS_ARESETN     ( ap_rst_n                             ) , // input wire S08_AXIS_ARESETN
  .S09_AXIS_ARESETN     ( ap_rst_n                             ) , // input wire S09_AXIS_ARESETN
  .S10_AXIS_ARESETN     ( ap_rst_n                             ) , // input wire S10_AXIS_ARESETN
  .S11_AXIS_ARESETN     ( ap_rst_n                             ) , // input wire S11_AXIS_ARESETN
  .S12_AXIS_ARESETN     ( ap_rst_n                             ) , // input wire S12_AXIS_ARESETN
  .S13_AXIS_ARESETN     ( ap_rst_n                             ) , // input wire S13_AXIS_ARESETN
  .S14_AXIS_ARESETN     ( ap_rst_n                             ) , // input wire S14_AXIS_ARESETN
  .S15_AXIS_ARESETN     ( ap_rst_n                             ) , // input wire S15_AXIS_ARESETN
  .S00_AXIS_TVALID      ( m_axis_combiner_tvalid_shift[0] [0]  ) , // input wire S00_AXIS_TVALID
  .S01_AXIS_TVALID      ( m_axis_combiner_tvalid_shift[1] [1]  ) , // input wire S01_AXIS_TVALID
  .S02_AXIS_TVALID      ( m_axis_combiner_tvalid_shift[2] [2]  ) , // input wire S02_AXIS_TVALID
  .S03_AXIS_TVALID      ( m_axis_combiner_tvalid_shift[3] [3]  ) , // input wire S03_AXIS_TVALID
  .S04_AXIS_TVALID      ( m_axis_combiner_tvalid_shift[4] [4]  ) , // input wire S04_AXIS_TVALID
  .S05_AXIS_TVALID      ( m_axis_combiner_tvalid_shift[5] [5]  ) , // input wire S05_AXIS_TVALID
  .S06_AXIS_TVALID      ( m_axis_combiner_tvalid_shift[6] [6]  ) , // input wire S06_AXIS_TVALID
  .S07_AXIS_TVALID      ( m_axis_combiner_tvalid_shift[7] [7]  ) , // input wire S07_AXIS_TVALID
  .S08_AXIS_TVALID      ( m_axis_combiner_tvalid_shift[8] [8]  ) , // input wire S08_AXIS_TVALID
  .S09_AXIS_TVALID      ( m_axis_combiner_tvalid_shift[9] [9]  ) , // input wire S09_AXIS_TVALID
  .S10_AXIS_TVALID      ( m_axis_combiner_tvalid_shift[10][10] ) , // input wire S10_AXIS_TVALID
  .S11_AXIS_TVALID      ( m_axis_combiner_tvalid_shift[11][11] ) , // input wire S11_AXIS_TVALID
  .S12_AXIS_TVALID      ( m_axis_combiner_tvalid_shift[12][12] ) , // input wire S12_AXIS_TVALID
  .S13_AXIS_TVALID      ( m_axis_combiner_tvalid_shift[13][13] ) , // input wire S13_AXIS_TVALID
  .S14_AXIS_TVALID      ( m_axis_combiner_tvalid_shift[14][14] ) , // input wire S14_AXIS_TVALID
  .S15_AXIS_TVALID      ( m_axis_combiner_tvalid_shift[15][15] ) , // input wire S15_AXIS_TVALID
  .S00_AXIS_TREADY      ( m_axis_combiner_tready_shift[0] [0]  ) , // output wire S00_AXIS_TREADY
  .S01_AXIS_TREADY      ( m_axis_combiner_tready_shift[1] [1]  ) , // output wire S01_AXIS_TREADY
  .S02_AXIS_TREADY      ( m_axis_combiner_tready_shift[2] [2]  ) , // output wire S02_AXIS_TREADY
  .S03_AXIS_TREADY      ( m_axis_combiner_tready_shift[3] [3]  ) , // output wire S03_AXIS_TREADY
  .S04_AXIS_TREADY      ( m_axis_combiner_tready_shift[4] [4]  ) , // output wire S04_AXIS_TREADY
  .S05_AXIS_TREADY      ( m_axis_combiner_tready_shift[5] [5]  ) , // output wire S05_AXIS_TREADY
  .S06_AXIS_TREADY      ( m_axis_combiner_tready_shift[6] [6]  ) , // output wire S06_AXIS_TREADY
  .S07_AXIS_TREADY      ( m_axis_combiner_tready_shift[7] [7]  ) , // output wire S07_AXIS_TREADY
  .S08_AXIS_TREADY      ( m_axis_combiner_tready_shift[8] [8]  ) , // output wire S08_AXIS_TREADY
  .S09_AXIS_TREADY      ( m_axis_combiner_tready_shift[9] [9]  ) , // output wire S09_AXIS_TREADY
  .S10_AXIS_TREADY      ( m_axis_combiner_tready_shift[10][10] ) , // output wire S10_AXIS_TREADY
  .S11_AXIS_TREADY      ( m_axis_combiner_tready_shift[11][11] ) , // output wire S11_AXIS_TREADY
  .S12_AXIS_TREADY      ( m_axis_combiner_tready_shift[12][12] ) , // output wire S12_AXIS_TREADY
  .S13_AXIS_TREADY      ( m_axis_combiner_tready_shift[13][13] ) , // output wire S13_AXIS_TREADY
  .S14_AXIS_TREADY      ( m_axis_combiner_tready_shift[14][14] ) , // output wire S14_AXIS_TREADY
  .S15_AXIS_TREADY      ( m_axis_combiner_tready_shift[15][15] ) , // output wire S15_AXIS_TREADY
  .S00_AXIS_TDATA       ( m_axis_combiner_tdata_shift[0] [0]   ) , // input wire [511 : 0] S00_AXIS_TDATA
  .S01_AXIS_TDATA       ( m_axis_combiner_tdata_shift[1] [1]   ) , // input wire [511 : 0] S01_AXIS_TDATA
  .S02_AXIS_TDATA       ( m_axis_combiner_tdata_shift[2] [2]   ) , // input wire [511 : 0] S02_AXIS_TDATA
  .S03_AXIS_TDATA       ( m_axis_combiner_tdata_shift[3] [3]   ) , // input wire [511 : 0] S03_AXIS_TDATA
  .S04_AXIS_TDATA       ( m_axis_combiner_tdata_shift[4] [4]   ) , // input wire [511 : 0] S04_AXIS_TDATA
  .S05_AXIS_TDATA       ( m_axis_combiner_tdata_shift[5] [5]   ) , // input wire [511 : 0] S05_AXIS_TDATA
  .S06_AXIS_TDATA       ( m_axis_combiner_tdata_shift[6] [6]   ) , // input wire [511 : 0] S06_AXIS_TDATA
  .S07_AXIS_TDATA       ( m_axis_combiner_tdata_shift[7] [7]   ) , // input wire [511 : 0] S07_AXIS_TDATA
  .S08_AXIS_TDATA       ( m_axis_combiner_tdata_shift[8] [8]   ) , // input wire [511 : 0] S08_AXIS_TDATA
  .S09_AXIS_TDATA       ( m_axis_combiner_tdata_shift[9] [9]   ) , // input wire [511 : 0] S09_AXIS_TDATA
  .S10_AXIS_TDATA       ( m_axis_combiner_tdata_shift[10][10]  ) , // input wire [511 : 0] S10_AXIS_TDATA
  .S11_AXIS_TDATA       ( m_axis_combiner_tdata_shift[11][11]  ) , // input wire [511 : 0] S11_AXIS_TDATA
  .S12_AXIS_TDATA       ( m_axis_combiner_tdata_shift[12][12]  ) , // input wire [511 : 0] S12_AXIS_TDATA
  .S13_AXIS_TDATA       ( m_axis_combiner_tdata_shift[13][13]  ) , // input wire [511 : 0] S13_AXIS_TDATA
  .S14_AXIS_TDATA       ( m_axis_combiner_tdata_shift[14][14]  ) , // input wire [511 : 0] S14_AXIS_TDATA
  .S15_AXIS_TDATA       ( m_axis_combiner_tdata_shift[15][15]  ) , // input wire [511 : 0] S15_AXIS_TDATA
  .S00_AXIS_TLAST       ( m_axis_combiner_tlast_shift[0] [0]   ) , // input wire S00_AXIS_TLAST
  .S01_AXIS_TLAST       ( m_axis_combiner_tlast_shift[1] [1]   ) , // input wire S01_AXIS_TLAST
  .S02_AXIS_TLAST       ( m_axis_combiner_tlast_shift[2] [2]   ) , // input wire S02_AXIS_TLAST
  .S03_AXIS_TLAST       ( m_axis_combiner_tlast_shift[3] [3]   ) , // input wire S03_AXIS_TLAST
  .S04_AXIS_TLAST       ( m_axis_combiner_tlast_shift[4] [4]   ) , // input wire S04_AXIS_TLAST
  .S05_AXIS_TLAST       ( m_axis_combiner_tlast_shift[5] [5]   ) , // input wire S05_AXIS_TLAST
  .S06_AXIS_TLAST       ( m_axis_combiner_tlast_shift[6] [6]   ) , // input wire S06_AXIS_TLAST
  .S07_AXIS_TLAST       ( m_axis_combiner_tlast_shift[7] [7]   ) , // input wire S07_AXIS_TLAST
  .S08_AXIS_TLAST       ( m_axis_combiner_tlast_shift[8] [8]   ) , // input wire S08_AXIS_TLAST
  .S09_AXIS_TLAST       ( m_axis_combiner_tlast_shift[9] [9]   ) , // input wire S09_AXIS_TLAST
  .S10_AXIS_TLAST       ( m_axis_combiner_tlast_shift[10][10]  ) , // input wire S10_AXIS_TLAST
  .S11_AXIS_TLAST       ( m_axis_combiner_tlast_shift[11][11]  ) , // input wire S11_AXIS_TLAST
  .S12_AXIS_TLAST       ( m_axis_combiner_tlast_shift[12][12]  ) , // input wire S12_AXIS_TLAST
  .S13_AXIS_TLAST       ( m_axis_combiner_tlast_shift[13][13]  ) , // input wire S13_AXIS_TLAST
  .S14_AXIS_TLAST       ( m_axis_combiner_tlast_shift[14][14]  ) , // input wire S14_AXIS_TLAST
  .S15_AXIS_TLAST       ( m_axis_combiner_tlast_shift[15][15]  ) , // input wire S15_AXIS_TLAST
  .M00_AXIS_ACLK        ( ap_clk                               ) , // input wire M00_AXIS_ACLK
  .M00_AXIS_ARESETN     ( ap_rst_n                             ) , // input wire M00_AXIS_ARESETN
  .M00_AXIS_TVALID      ( wr_tvalid_out_C                      ) , // output wire M00_AXIS_TVALID
  .M00_AXIS_TREADY      ( wr_tready_out_C                      ) , // input wire M00_AXIS_TREADY
  .M00_AXIS_TDATA       ( wr_tdata_out_C                       ) , // output wire [511 : 0] M00_AXIS_TDATA
  .M00_AXIS_TLAST       ( final_output_tlast                   ) , // output wire M00_AXIS_TLAST
  .S00_ARB_REQ_SUPPRESS ( 1'b0                                 ) , // input wire S00_ARB_REQ_SUPPRESS
  .S01_ARB_REQ_SUPPRESS ( 1'b0                                 ) , // input wire S01_ARB_REQ_SUPPRESS
  .S02_ARB_REQ_SUPPRESS ( 1'b0                                 ) , // input wire S02_ARB_REQ_SUPPRESS
  .S03_ARB_REQ_SUPPRESS ( 1'b0                                 ) , // input wire S03_ARB_REQ_SUPPRESS
  .S04_ARB_REQ_SUPPRESS ( 1'b0                                 ) , // input wire S04_ARB_REQ_SUPPRESS
  .S05_ARB_REQ_SUPPRESS ( 1'b0                                 ) , // input wire S05_ARB_REQ_SUPPRESS
  .S06_ARB_REQ_SUPPRESS ( 1'b0                                 ) , // input wire S06_ARB_REQ_SUPPRESS
  .S07_ARB_REQ_SUPPRESS ( 1'b0                                 ) , // input wire S07_ARB_REQ_SUPPRESS
  .S08_ARB_REQ_SUPPRESS ( 1'b0                                 ) , // input wire S08_ARB_REQ_SUPPRESS
  .S09_ARB_REQ_SUPPRESS ( 1'b0                                 ) , // input wire S09_ARB_REQ_SUPPRESS
  .S10_ARB_REQ_SUPPRESS ( 1'b0                                 ) , // input wire S10_ARB_REQ_SUPPRESS
  .S11_ARB_REQ_SUPPRESS ( 1'b0                                 ) , // input wire S11_ARB_REQ_SUPPRESS
  .S12_ARB_REQ_SUPPRESS ( 1'b0                                 ) , // input wire S12_ARB_REQ_SUPPRESS
  .S13_ARB_REQ_SUPPRESS ( 1'b0                                 ) , // input wire S13_ARB_REQ_SUPPRESS
  .S14_ARB_REQ_SUPPRESS ( 1'b0                                 ) , // input wire S14_ARB_REQ_SUPPRESS
  .S15_ARB_REQ_SUPPRESS ( 1'b0                                 ) // input wire S15_ARB_REQ_SUPPRESS
);

always @(posedge ap_clk) begin
    if (write_done == 1'b1) begin
        ap_done_i <= 3'b111;
    end
    else begin
        ap_done_i <= 3'b000;
    end
end

endmodule : my_matrix_multiplier_implementation
`default_nettype wire
