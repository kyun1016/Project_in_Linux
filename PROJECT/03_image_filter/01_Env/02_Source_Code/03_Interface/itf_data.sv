// ./list_interface.f


interface itf_data
#(
  parameter APB_SEL_WIDTH  = 4   , 
  parameter APB_ADDR_WIDTH = 10  , // maximum width 32 bits
  parameter APB_DATA_WIDTH = 32    // 8/16/32 bits wide
)
(
  input clk,
  input rstn,
  input clk_apb,
  input rstn_apb
);
  //=============================================================
  // apb master
  //=============================================================
  logic [APB_ADDR_WIDTH-1:0] i_apb_addr     ;
  logic [APB_DATA_WIDTH-1:0] i_apb_data     ;
  logic                      i_apb_wait     ;
  logic                      i_apb_write_trg;
  logic                      i_apb_read_trg ;
  logic [APB_SEL_WIDTH-1:0]  i_apb_sel      ;
  logic [APB_ADDR_WIDTH-1:0] o_apb_PADDR    ;// APB address bus
  logic [APB_SEL_WIDTH-1:0]  o_apb_PSEL     ;// Select
  logic                      o_apb_PENABLE  ;// Enable
  logic                      o_apb_PWRITE   ;// Direction
  logic [APB_DATA_WIDTH-1:0] o_apb_PWDATA   ;// Write data (PWRITE is HIGH)

  //=============================================================
  // data
  //=============================================================
  int         WIDTH;
  int         HEIGHT;
  logic [9:0] csc_coef[0:2][0:2];
  logic [9:0] icsc_coef[0:2][0:2];
  logic [9:0] filter1_coef[0:4][0:4];
  logic [9:0] filter2_coef[0:4][0:4];
  logic [7:0] csc_bias[0:2];
  logic [7:0] icsc_bias[0:2];
  logic       csc_bypass;
  logic       icsc_bypass;
  logic       filter1_bypass;
  logic       filter2_bypass;

  logic [7:0] frame_r[0:1079][0:1919];
  logic [7:0] frame_g[0:1079][0:1919];
  logic [7:0] frame_b[0:1079][0:1919];
  logic [7:0] line_r[0:1919];
  logic [7:0] line_g[0:1919];
  logic [7:0] line_b[0:1919];
  logic       i_vs;
  logic       i_hs;
  logic       i_de;
  logic [7:0] i_r;
  logic [7:0] i_g;
  logic [7:0] i_b;
  logic       o_vs;
  logic       o_hs;
  logic       o_de;
  logic [7:0] o_r;
  logic [7:0] o_g;
  logic [7:0] o_b;

  int         cnt_ch;
  int         cnt_line;

  event       evt_hs;
  event       evt_vs;
endinterface
