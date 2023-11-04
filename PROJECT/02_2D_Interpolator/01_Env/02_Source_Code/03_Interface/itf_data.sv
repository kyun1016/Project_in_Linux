// ./list_interface.f


interface itf_data
#(
  parameter SEL_WIDTH       = 4   , 
  parameter ADDR_WIDTH      = 10  , // maximum width 32 bits
  parameter DATA_WIDTH      = 8   , // 8/16/32 bits wide
  parameter USER_REQ_WIDTH  = 4   , // maximum width of 128 bits
  parameter USER_DATA_WIDTH = 4   , // maximum width of DATA_WIDTH/2
  parameter USER_RESP_WIDTH = 4     // maximum width of 16 bits
)
(
  input clk,
  input rstn,
  input clk_apb,
  input rstn_apb
);
  logic [ADDR_WIDTH-1:0] i_apb_addr     ;
  logic [DATA_WIDTH-1:0] i_apb_data     ;
  logic                  i_apb_wait     ;
  logic                  i_apb_write_trg;
  logic                  i_apb_read_trg ;
  logic [SEL_WIDTH-1:0]  i_apb_sel      ;
  logic [7:0]            i_x            ;
  logic [9:0]            o_y            ;
endinterface
