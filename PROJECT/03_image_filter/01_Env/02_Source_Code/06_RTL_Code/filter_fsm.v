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
  output                          o_mem_de     ,
  output     [MEM_ADDR_WIDTH-1:0] o_mem_waddr  ,
  output     [MEM_ADDR_WIDTH-1:0] o_mem_raddr  ,
  output     [MEM_Y_WIDTH-1:0]    o_mem_y_wen  ,
  output                          o_mem_y_ren  ,
  output     [MEM_U_WIDTH-1:0]    o_mem_u_wen  ,
  output     [MEM_U_WIDTH-1:0]    o_mem_u_ren  ,
  output     [MEM_V_WIDTH-1:0]    o_mem_v_wen  ,
  output     [MEM_V_WIDTH-1:0]    o_mem_v_ren  ,
  output     [3:0]                o_aln_ln_y   ,
  output     [3:0]                o_pad_ln_y   ,
  output reg                      o_vs         ,
  output reg                      o_hs         
);

  //=============================================================
  // Part 1. Define Parameters
  //=============================================================
  localparam
    ST_V_SIZE   = 5,
    V_INIT      = 0,
    V_WAIT      = 1,
    V_FILL      = 2,
    V_OPER      = 3,
    V_FLUSH     = 4,
    VAL_V_INIT  = 5'b00001,
    VAL_V_WAIT  = 5'b00010,
    VAL_V_FILL  = 5'b00100,
    VAL_V_OPER  = 5'b01000,
    VAL_V_FLUSH = 5'b10000;
  localparam
    ST_H_SIZE   = 5,
    H_INIT      = 0,
    H_WAIT      = 1,
    H_START     = 2,
    H_OPER      = 3,
    H_END       = 4,
    VAL_H_INIT  = 5'b00001,
    VAL_H_WAIT  = 5'b00010,
    VAL_H_START = 5'b00100,
    VAL_H_OPER  = 5'b01000,
    VAL_H_END   = 5'b10000;

  localparam
    CNT_V_SIZE = 12,
    VBP        = 3,
    VSY        = 3,
    VAC        = 1080,
    VFP        = 3,
    CNT_H_SIZE = 12,
    HBP        = 3,
    HSY        = 1,
    HFP        = 3,
    HAC        = 1920;

  localparam
    LINE_DLY  = 2,
    PIXEL_DLY = 3;

  //=============================================================
  // Part 2. Define counter
  //=============================================================
  reg [CNT_V_SIZE-1:0] r_cnt_v;
  reg [ST_V_SIZE-1:0] r_st_v;
  always @(posedge clk, negedge rstn) begin
    if(!rstn)
      r_cnt_v <= 0;
    else if(i_vs)
      r_cnt_v <= 0;
    else if(i_hs)
      r_cnt_v <= r_cnt_v+1;
  end

  reg [CNT_H_SIZE-1:0] r_cnt_h;
  reg [ST_H_SIZE-1:0] r_st_h;
  always @(posedge clk, negedge rstn) begin
    if(!rstn)
      r_cnt_h <= 0;
    else if(i_hs)
      r_cnt_h <= 0;
    else if(!r_st_h[H_INIT])
      r_cnt_h <= r_cnt_h+1;
  end
  //=============================================================
  // Part 3. Define FSM
  //=============================================================
  always @(posedge clk, negedge rstn) begin
    if(!rstn)
      r_st_v <= VAL_V_INIT;
    else
      case(1'b1)
        r_st_v[V_INIT]  : if(i_vs)                               r_st_v <= VAL_V_WAIT;
        r_st_v[V_WAIT]  : if     (i_hs & (r_cnt_v == VBP))       r_st_v <= VAL_V_FILL;
        r_st_v[V_FILL]  : if(i_vs)                               r_st_v <= VAL_V_WAIT;
                          else if(i_hs & (r_cnt_v == VBP+2))     r_st_v <= VAL_V_OPER;
        r_st_v[V_OPER]  : if(i_vs)                               r_st_v <= VAL_V_WAIT;
                          else if(i_hs & (r_cnt_v == VAC+VBP))   r_st_v <= VAL_V_FLUSH;
        r_st_v[V_FLUSH] : if(i_vs)                               r_st_v <= VAL_V_WAIT;
                          else if(i_hs & (r_cnt_v == VAC+VBP+2)) r_st_v <= VAL_V_INIT;
        default         :                                        r_st_v <= VAL_V_INIT;
      endcase
  end

  always @(posedge clk, negedge rstn) begin
    if(!rstn)
      r_st_h <= VAL_H_INIT;
    else
      case(1'b1)
        r_st_h[H_INIT]  : if(i_hs)                          r_st_h <= VAL_H_WAIT;
        r_st_h[H_WAIT]  : if(r_cnt_h == HBP-1)              r_st_h <= VAL_H_START;
        r_st_h[H_START] : if(i_hs)                          r_st_h <= VAL_H_WAIT;
                          else                              r_st_h <= VAL_H_OPER;
        r_st_h[H_OPER]  : if(i_hs)                          r_st_h <= VAL_H_WAIT;
                          else if(r_cnt_h == (HAC + HBP-1)) r_st_h <= VAL_H_END;
        r_st_h[H_END]   : if(i_hs)                          r_st_h <= VAL_H_WAIT;
                          else                              r_st_h <= VAL_H_INIT;
        default         :                                   r_st_h <= VAL_H_INIT;
      endcase
  end
  //=============================================================
  // Part 4. Output Control
  //=============================================================
  // What is the better design?
  // always @(posedge clk, negedge rstn) begin
  //   if(!rstn)
  //     o_mem_waddr <= 0;
  //   else
  //     o_mem_waddr <= o_mem_raddr;
  // end
  assign o_mem_de        = (|r_st_v[V_FLUSH:V_OPER]) & (|r_st_h[H_END:H_OPER]);
  assign o_mem_raddr     = r_cnt_h[0+:MEM_ADDR_WIDTH] - HBP;
  assign o_mem_waddr     = o_mem_raddr - 1;
  assign o_mem_y_wen[0]  = (|r_st_v[V_OPER :V_FILL]) & (|r_st_h[H_END :H_OPER ]) & (r_cnt_v[1:0] == 2'b00);
  assign o_mem_y_wen[1]  = (|r_st_v[V_OPER :V_FILL]) & (|r_st_h[H_END :H_OPER ]) & (r_cnt_v[1:0] == 2'b01);
  assign o_mem_y_wen[2]  = (|r_st_v[V_OPER :V_FILL]) & (|r_st_h[H_END :H_OPER ]) & (r_cnt_v[1:0] == 2'b10);
  assign o_mem_y_wen[3]  = (|r_st_v[V_OPER :V_FILL]) & (|r_st_h[H_END :H_OPER ]) & (r_cnt_v[1:0] == 2'b11);
  assign o_mem_y_ren     = (|r_st_v[V_FLUSH:V_OPER]) & (|r_st_h[H_OPER:H_START]);
  assign o_mem_u_wen[0]  = (|r_st_v[V_OPER :V_FILL]) & (|r_st_h[H_END :H_OPER ]) & (!r_cnt_v[0]);
  assign o_mem_u_wen[1]  = (|r_st_v[V_OPER :V_FILL]) & (|r_st_h[H_END :H_OPER ]) & ( r_cnt_v[0]);
  assign o_mem_u_ren[0]  = (|r_st_v[V_FLUSH:V_OPER]) & (|r_st_h[H_OPER:H_START]) & (!r_cnt_v[0]);
  assign o_mem_u_ren[1]  = (|r_st_v[V_FLUSH:V_OPER]) & (|r_st_h[H_OPER:H_START]) & ( r_cnt_v[0]);
  assign o_mem_v_wen     = o_mem_u_wen;
  assign o_mem_v_ren     = o_mem_u_ren;
  assign o_aln_ln_y[0]   = r_cnt_v[1:0] == 2'b00;
  assign o_aln_ln_y[1]   = r_cnt_v[1:0] == 2'b01;
  assign o_aln_ln_y[2]   = r_cnt_v[1:0] == 2'b10;
  assign o_aln_ln_y[3]   = r_cnt_v[1:0] == 2'b11;
  assign o_pad_ln_y[0]   = r_cnt_v == (VBP+LINE_DLY+1);
  assign o_pad_ln_y[1]   = r_cnt_v == (VBP+LINE_DLY+2);
  assign o_pad_ln_y[2]   = r_cnt_v == (VBP+LINE_DLY+VAC+1);
  assign o_pad_ln_y[3]   = r_cnt_v == (VBP+LINE_DLY+VAC+2);


  reg [1:0] r_vs;
  always @(posedge clk, negedge rstn) begin
    if(!rstn) begin
      r_vs <= 'b0;
      o_vs <= 1'b0;
    end
    else if(r_cnt_h == PIXEL_DLY) begin
      r_vs[0] <= i_vs;
      r_vs[1] <= r_vs[0];
      o_vs    <= r_vs[1];
    end
  end

  always @(posedge clk, negedge rstn) begin
    if(!rstn) begin
      o_hs <= 1'b0;
    end
    else if(r_cnt_h == PIXEL_DLY      ) begin
      o_hs <= 1'b1;
    end
    else if(r_cnt_h == PIXEL_DLY + HSY) begin
      o_hs <= 1'b0;
    end
  end

endmodule
