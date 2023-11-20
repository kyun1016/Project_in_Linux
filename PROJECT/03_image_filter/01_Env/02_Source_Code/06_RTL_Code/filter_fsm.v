// ./list_rtl.f

module filter_fsm
#(
  parameter MEM_Y_WIDTH    = 4 ,
  parameter MEM_U_WIDTH    = 2 ,
  parameter MEM_V_WIDTH    = 2 ,
  parameter MEM_ADDR_WIDTH = 11
)
(
  input                           clk          ,
  input                           rstn         ,
  input                           i_vs         ,
  input                           i_hs         ,
  input                           i_de         ,
  output     [MEM_Y_WIDTH-1:0]    o_mem_y_wen  ,
  output     [MEM_Y_WIDTH-1:0]    o_mem_y_ren  ,
  output     [MEM_U_WIDTH-1:0]    o_mem_u_wen  ,
  output     [MEM_U_WIDTH-1:0]    o_mem_u_ren  ,
  output     [MEM_V_WIDTH-1:0]    o_mem_v_wen  ,
  output     [MEM_V_WIDTH-1:0]    o_mem_v_ren  ,
  output reg [MEM_ADDR_WIDTH-1:0] o_mem_waddr  ,
  output     [MEM_ADDR_WIDTH-1:0] o_mem_raddr  ,
  output                          o_vs         ,
  output                          o_hs         ,
  output                          o_de          
);

  //=============================================================
  // Part 1. Define Parameters
  //=============================================================
  localparam
    ST_SIZE     = 7,
    INIT        = 0,
    WAIT        = 1,
    FILL1       = 2,
    FILL2       = 3,
    OPER        = 4,
    FLUSH1      = 5,
    FLUSH2      = 6,
    VAL_INIT    = 7'b0000001,
    VAL_WAIT    = 7'b0000010,
    VAL_FILL1   = 7'b0000100,
    VAL_FILL2   = 7'b0001000,
    VAL_OPER    = 7'b0010000,
    VAL_FLUSH1  = 7'b0100000,
    VAL_FLUSH2  = 7'b1000000;

  localparam
    CNT_V_SIZE = 12,
    VBP        = 3,
    VFP        = 3,
    VAC        = 1080,
    CNT_H_SIZE = 12,
    HBP        = 3,
    HFP        = 3,
    HAC        = 1920;

  //=============================================================
  // Part 2. Define counter
  //=============================================================
  reg [CNT_V_SIZE-1:0] r_cnt_v;
  reg [ST_SIZE-1:0] r_st_v;
  always @(posedge clk, negedge rstn) begin
    if(!rstn)
      r_cnt_v <= 0;
    else if(i_vs)
      r_cnt_v <= 0;
    else if(i_hs)
      r_cnt_v <= r_cnt_v+1;
  end

  reg [CNT_H_SIZE-1:0] r_cnt_h;
  always @(posedge clk, negedge rstn) begin
    if(!rstn)
      r_cnt_h <= 0;
    else if(i_hs)
      r_cnt_h <= 0;
    else
      r_cnt_h <= r_cnt_h+1;
  end
  //=============================================================
  // Part 3. Define FSM
  //=============================================================
  always @(posedge clk, negedge rstn) begin
    if(!rstn)
      r_st_v <= VAL_INIT;
    else
      case(1'b1)
        r_st_v[INIT]  : if(i_vs)                    r_st_v <= VAL_WAIT;
        r_st_v[WAIT]  : if(i_hs & (r_cnt_v == VBP)) r_st_v <= VAL_FILL1;
        r_st_v[FILL1] : if(i_hs)                    r_st_v <= VAL_FILL2;
        r_st_v[FILL2] : if(i_hs)                    r_st_v <= VAL_OPER;
        r_st_v[OPER]  : if(i_hs & (r_cnt_v == (VAC + VBP))) r_st_v <= VAL_FLUSH1;
        r_st_v[FLUSH1]: if(i_hs)                    r_st_v <= VAL_FLUSH2;
        r_st_v[FLUSH2]: if(i_hs)                    r_st_v <= VAL_INIT;
        default       :                             r_st_v <= VAL_INIT;
      endcase
  end

  //=============================================================
  // Part 4. Output Control
  //=============================================================
  assign o_mem_y_wen[3]  = ((|r_st_v[OPER:FILL1]) && (r_cnt_v[1:0] == 2'b11)) ? i_de : 1'b0;
  assign o_mem_y_wen[2]  = ((|r_st_v[OPER:FILL1]) && (r_cnt_v[1:0] == 2'b10)) ? i_de : 1'b0;
  assign o_mem_y_wen[1]  = ((|r_st_v[OPER:FILL1]) && (r_cnt_v[1:0] == 2'b01)) ? i_de : 1'b0;
  assign o_mem_y_wen[0]  = ((|r_st_v[OPER:FILL1]) && (r_cnt_v[1:0] == 2'b00)) ? i_de : 1'b0;
  assign o_mem_y_ren[3]  = (|r_st_v[FLUSH2:OPER]) ? 1'b1 : 1'b0;
  assign o_mem_y_ren[2]  = (|r_st_v[FLUSH2:OPER]) ? 1'b1 : 1'b0;
  assign o_mem_y_ren[1]  = (|r_st_v[FLUSH2:OPER]) ? 1'b1 : 1'b0;
  assign o_mem_y_ren[0]  = (|r_st_v[FLUSH2:OPER]) ? 1'b1 : 1'b0;
  assign o_mem_raddr     = r_cnt_h[0+:MEM_ADDR_WIDTH]; // [11:0] 
  assign o_mem_waddr     = o_mem_raddr - 1;
  assign o_vs          = 0;
  assign o_hs          = 0;
  assign o_de          = 0;

  // What is the better design?
  // always @(posedge clk, negedge rstn) begin
  //   if(!rstn)
  //     o_mem_waddr <= 0;
  //   else
  //     o_mem_waddr <= o_mem_raddr;
  // end

endmodule
