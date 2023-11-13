// ./list_rtl.f

module filter_fsm
(
  input         clk          ,
  input         rstn         ,
  input         i_vs         ,
  input         i_hs         ,
  input         i_de         ,
  output [3:0]  o_mem_wen    ,
  output        o_mem_ren    ,
  output [11:0] o_mem_addr   ,
  output [3:0]  o_conv_wen   ,
  output        o_conv_ren   ,
  output [2:0]  o_conv_ln_sel,
  output [2:0]  o_conv_px_sel,
  output        o_vs         ,
  output        o_hs         ,
  output        o_de          
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
  wire w_set_cnt_v = i_vs 
                      ? 1'b1 
                      : i_hs 
                        ? (r_st_v[WAIT]) & (r_cnt_v == VBP)
                          ? 1'b1
                          : 1'b0
                        : (r_st_v[OPER]) & (r_cnt_v == VAC)
                          ? 1'b1
                          : 1'b0;
                                  
  always @(posedge clk, negedge rstn) begin
    if(!rstn)
      r_cnt_v <= 0;
    else if(w_set_cnt_v)
      r_cnt_v <= 0;
    else if(i_hs & (|r_st_v[OPER:WAIT]))
      r_cnt_v <= r_cnt_v+1;
  end

  reg [CNT_H_SIZE-1:0] r_cnt_h;
  reg [ST_SIZE-1:0] r_st_h;
  wire w_set_cnt_h = i_hs 
                      ? 1'b1
                      : ((r_st_h[WAIT]) & (r_cnt_h == HBP)) || ((r_st_h[OPER]) & (r_cnt_h == HAC))
                        ? 1'b1
                        : 1'b0;

  always @(posedge clk, negedge rstn) begin
    if(!rstn)
      r_cnt_h <= 0;
    else if(w_set_cnt_h)
      r_cnt_h <= 0;
    else if(|r_st_h[OPER:WAIT])
      r_cnt_h <= r_cnt_h+1;
  end
  //=============================================================
  // Part 2. Define counter
  //=============================================================
  reg [2:0] r_cnt_ln;
  always @(posedge clk, negedge rstn) begin
    if(!rstn)
      r_cnt_ln <= 0;
    else if(r_st_v[FILL2])
      r_cnt_ln <= 0;
    else if(i_hs & (|r_st_v[FLUSH2:OPER]))
      r_cnt_ln <= r_cnt_ln+1;
  end
  
  reg [2:0] r_cnt_px;
  always @(posedge clk, negedge rstn) begin
    if(!rstn)
      r_cnt_px <= 0;
    else if(r_st_h[FILL2])
      r_cnt_px <= 0;
    else if(|r_st_h[FLUSH2:OPER])
      r_cnt_px <= r_cnt_px+1;
  end
  //=============================================================
  // Part 3. Define FSM
  //=============================================================
  always @(posedge clk, negedge rstn) begin
    if(!rstn) begin
      r_st_v <= VAL_INIT;
    end
    case(1'b1)
      r_st_v[INIT]  : if(i_vs)                    r_st_v <= VAL_WAIT;
      r_st_v[WAIT]  : if(i_hs & (r_cnt_v == VBP)) r_st_v <= VAL_FILL1;
      r_st_v[FILL1] : if(i_hs)                    r_st_v <= VAL_FILL2;
      r_st_v[FILL2] : if(i_hs)                    r_st_v <= VAL_OPER;
      r_st_v[OPER]  : if(i_hs & (r_cnt_v == VAC)) r_st_v <= VAL_FLUSH1;
      r_st_v[FLUSH1]: if(i_hs)                    r_st_v <= VAL_FLUSH2;
      r_st_v[FLUSH2]: if(i_hs)                    r_st_v <= VAL_INIT;
      default       :                             r_st_v <= VAL_INIT;
    endcase
  end
  always @(posedge clk, negedge rstn) begin
    if(!rstn) begin
      r_st_h <= VAL_INIT;
    end
    case(1'b1)
      r_st_h[INIT]  : if(i_hs)           r_st_h <= VAL_WAIT;
      r_st_h[WAIT]  : if(r_cnt_h == HBP) r_st_h <= VAL_FILL1;
      r_st_h[FILL1] :                    r_st_h <= VAL_FILL2;
      r_st_h[FILL2] :                    r_st_h <= VAL_OPER;
      r_st_h[OPER]  : if(r_cnt_h == HAC) r_st_h <= VAL_FLUSH1;
      r_st_h[FLUSH1]:                    r_st_h <= VAL_FLUSH2;
      r_st_h[FLUSH2]:                    r_st_h <= VAL_INIT;
      default       :                    r_st_h <= VAL_INIT;
    endcase
  end

  //=============================================================
  // Part 4. Output Control
  //=============================================================
  assign o_mem_wen[3]  = ((|r_st_v[OPER:FILL1]) && (|r_st_h[OPER:FILL1]) &&                  (r_cnt_v[1:0] == 2'b01) ) ? 1'b1 : 1'b0;
  assign o_mem_wen[2]  = ((|r_st_v[OPER:FILL1]) && (|r_st_h[OPER:FILL1]) && (r_st_v[FILL1] | (r_cnt_v[1:0] == 2'b00))) ? 1'b1 : 1'b0;
  assign o_mem_wen[1]  = ((|r_st_v[OPER:FILL1]) && (|r_st_h[OPER:FILL1]) && (r_st_v[FILL1] | (r_cnt_v[1:0] == 2'b11))) ? 1'b1 : 1'b0;
  assign o_mem_wen[0]  = ((|r_st_v[OPER:FILL1]) && (|r_st_h[OPER:FILL1]) && (r_st_v[FILL1] | (r_cnt_v[1:0] == 2'b10))) ? 1'b1 : 1'b0;
  assign o_mem_ren     = ((!r_st_v[FILL2:INIT]) &  (!r_st_h[FILL2:INIT])) ? 1'b1 : 1'b0;
  assign o_mem_addr    = ((!r_st_v[WAIT:INIT] ) &  (!r_st_h[WAIT:INIT] )) ? r_cnt_h : 0; // [11:0] 
  assign o_conv_wen[3] = ((|r_st_v[OPER:FILL1]) && (|r_st_h[OPER:FILL1]) &&                  (r_cnt_h[1:0] == 2'b01) ) ? 1'b1 : 1'b0;
  assign o_conv_wen[2] = ((|r_st_v[OPER:FILL1]) && (|r_st_h[OPER:FILL1]) && (r_st_h[FILL1] | (r_cnt_h[1:0] == 2'b00))) ? 1'b1 : 1'b0;
  assign o_conv_wen[1] = ((|r_st_v[OPER:FILL1]) && (|r_st_h[OPER:FILL1]) && (r_st_h[FILL1] | (r_cnt_h[1:0] == 2'b11))) ? 1'b1 : 1'b0;
  assign o_conv_wen[0] = ((|r_st_v[OPER:FILL1]) && (|r_st_h[OPER:FILL1]) && (r_st_h[FILL1] | (r_cnt_h[1:0] == 2'b10))) ? 1'b1 : 1'b0;
  assign o_conv_ren    = ((!r_st_v[FILL2:INIT]) &  (!r_st_h[FILL2:INIT])) ? 1'b1 : 1'b0;
  assign o_conv_ln_sel = r_cnt_ln; // [2:0]  
  assign o_conv_px_sel = r_cnt_px; // [2:0]  
  assign o_vs          = 0;
  assign o_hs          = 0;
  assign o_de          = 0;


endmodule
