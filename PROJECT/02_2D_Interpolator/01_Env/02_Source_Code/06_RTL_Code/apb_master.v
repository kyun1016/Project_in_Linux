
// ./list_rtl.f

module apb_master
#(
  parameter SEL_WIDTH       = 4   , 
  parameter ADDR_WIDTH      = 10  , // maximum width 32 bits
  parameter DATA_WIDTH      = 8   , // 8/16/32 bits wide
  parameter USER_REQ_WIDTH  = 4   , // maximum width of 128 bits
  parameter USER_DATA_WIDTH = 4   , // maximum width of DATA_WIDTH/2
  parameter USER_RESP_WIDTH = 4     // maximum width of 16 bits
)
(
  input                        clk        , // clock signal. 
  input                        rstn       ,
  
  input  [ADDR_WIDTH-1:0]      i_addr     ,
  input  [DATA_WIDTH-1:0]      i_data     ,
  input                        i_wait     ,
  input                        i_write_trg,
  input                        i_read_trg ,
  input  [SEL_WIDTH-1:0]       i_sel      ,

  output [ADDR_WIDTH-1:0]      o_PADDR    , // APB address bus
  output [2:0]                 o_PPROT    , // Protection type (normal, privileged, secure)
  output                       o_PNSE     , // Extension to protection type
  output [SEL_WIDTH-1:0]       o_PSEL     , // Select
  output                       o_PENABLE  , // Enable
  output                       o_PWRITE   , // Direction
  output [DATA_WIDTH-1:0]      o_PWDATA   , // Write data (PWRITE is HIGH)
  output [DATA_WIDTH/8:0]      o_PSTRB    , // indicateds which byte lanes to update during a write transfer
  output                       o_PSLAVERR , // (option) can be asserted HIGH by the Completer
  output                       o_PWAKEUP  , // indicateds any activvity associated with an APB interface
  output                       o_PREADY   , // used to extend an APB transfer by the Completer
  output [DATA_WIDTH-1:0]      o_PRDATA   , // Read data (PWRITE is LOW)

  output [USER_REQ_WIDTH-1:0]  o_PAUSER   , // User request attribute
  output [USER_DATA_WIDTH-1:0] o_PWUSER   , // User write data attribute
  output [USER_DATA_WIDTH-1:0] o_PRUSER   , // User read data attribute
  output [USER_RESP_WIDTH-1:0] o_PBUSER     // User response attribute
);
  //=============================================================
  // Part 1. Define Parameter
  //=============================================================
  localparam
    ST_WIDTH    = 4,
    ST_IDLE    = 0,
    ST_SETUP   = 1,
    ST_WAIT    = 2,
    ST_READY   = 3,
    ST_V_IDLE  = 4'b0001,
    ST_V_SETUP = 4'b0010,
    ST_V_WAIT  = 4'b0100,
    ST_V_READY = 4'b1000;

  localparam
    CNT_SIZE = 8,
    CNT_MAX  = 4;

  //=============================================================
  // Part 2. Control Counter
  //=============================================================
  reg [ST_WIDTH-1:0] r_st;
  reg [CNT_SIZE-1:0] r_cnt;
  wire w_cnt_max = (r_cnt == CNT_MAX) ? 1'b1 : 1'b0;
  always @(posedge clk, negedge rstn) begin
    if(!rstn)
      r_cnt <= 0;
    else if(r_st[ST_SETUP])
      r_cnt <= 0;
    else if(r_st[ST_WAIT])
      r_cnt <= r_cnt+1;
  end

  //=============================================================
  // Part 3. Control FSM
  //=============================================================
  reg r_write;
  always @(posedge clk, negedge rstn) begin
    if(!rstn) begin
      r_st <= ST_V_IDLE;
      r_write <= 1'b0;
    end
    else begin
      case(1'b1)
        r_st[ST_IDLE]: begin
          if(i_write_trg | i_read_trg) begin
            r_st <= ST_V_SETUP;
            r_write <= i_write_trg;   // priority of write > priority of read
          end
        end
        r_st[ST_SETUP]: begin
          if(i_wait)
            r_st <= ST_V_WAIT;
          else
            r_st <= ST_V_READY;
        end
        r_st[ST_WAIT]: begin
          if(w_cnt_max)
            r_st <= ST_V_READY;
        end
        r_st[ST_READY]: begin
          if(i_write_trg | i_read_trg) begin
            r_st <= ST_V_SETUP;
            r_write <= i_write_trg;   // priority of write > priority of read
          end
          else
            r_st <= ST_V_IDLE;
        end
      endcase
    end
  end

  //=============================================================
  // Part 4. Control Output
  //=============================================================
  assign o_PADDR   = !r_st[ST_IDLE]             ? i_addr  : 0;
  assign o_PSEL    = !r_st[ST_IDLE]             ? i_sel   : 0;
  assign o_PENABLE = !(|r_st[ST_SETUP:ST_IDLE]) ? 1'b1    : 1'b0;
  assign o_PWRITE  = !r_st[ST_IDLE]             ? r_write : 1'b0;
  assign o_PWDATA  = !r_st[ST_IDLE]             ? i_data  : 0;
  assign o_PREADY  =  r_st[ST_READY]            ? 1'b1    : 1'b0;
  assign o_PRDATA  =  r_st[ST_READY] & !r_write ? i_data  : 0;
endmodule
