// ./list_rtl.f

module filter_control
#(
  parameter MEM_ADDR_WIDTH = 11,
  parameter PAD_SIZE       = 2 ,
  parameter MEM_NUM        = 2   // 2^2 = 4 (y memory count)
)
(
  input                       clk          ,
  input                       rstn         ,
  input                       i_vs         ,
  input                       i_hs         ,
  output                      o_mem_ren    ,
  output [MEM_NUM-1:0]        o_mem_sel    ,
  output [MEM_ADDR_WIDTH-1:0] o_mem_waddr  ,
  output [MEM_ADDR_WIDTH-1:0] o_mem_raddr  ,
  output [PAD_SIZE*2-1:0]     o_pad_y      ,
  output                      o_vs         ,
  output                      o_hs         
);

  //=============================================================
  // Part 1. Define Parameters
  //=============================================================
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
    PIXEL_DLY = 2;

  //=============================================================
  // Part 2. Define counter
  //=============================================================
  reg [CNT_V_SIZE-1:0] r_cnt_v;
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
      r_cnt_h <= 'd0;
    else if(r_cnt_h == HBP+HAC+PIXEL_DLY)
      r_cnt_h <= 'd0;
    else if(i_hs)
      r_cnt_h <= 'd1;
    else if(|r_cnt_h)
      r_cnt_h <= r_cnt_h+1;
  end
  //=============================================================
  // Part 3. Define FSM
  //=============================================================
  reg [LINE_DLY:0] r_vs;
  always @(posedge clk, negedge rstn) begin
    if(!rstn)
      r_vs <= 'b0;
    else if(r_cnt_h == PIXEL_DLY)
      r_vs <= {r_vs[LINE_DLY-1:0], i_vs};
  end

  reg r_hs;
  always @(posedge clk, negedge rstn) begin
    if(!rstn)
      r_hs <= 1'b0;
    else if(r_cnt_h == PIXEL_DLY+HSY)
      r_hs <= 1'b0;
    else if(r_cnt_h == PIXEL_DLY    )
      r_hs <= 1'b1;
  end

  reg r_de;
  always @(posedge clk, negedge rstn) begin
    if(!rstn)
      r_de <= 1'b0;
    else if(r_cnt_h == PIXEL_DLY+HBP+HAC)
      r_de <= 1'b0;
    else if((r_cnt_v > (VBP+LINE_DLY)) & (r_cnt_v < (VBP+LINE_DLY+VAC+3)) & r_cnt_h == PIXEL_DLY)
      r_de <= 1'b1;
  end



  assign o_vs      = r_vs[LINE_DLY];
  assign o_hs      = r_hs;
  assign o_mem_ren = r_de; 
  //=============================================================
  // Part 4. Output Control
  //=============================================================
  assign o_mem_sel     = r_cnt_h[1:0];
  assign o_mem_raddr   = r_cnt_h[0+:MEM_ADDR_WIDTH] - HBP;
  assign o_mem_waddr   = o_mem_raddr - 1;


  reg [PAD_SIZE*2-1:0] r_pad_y;
  always @(*) begin
    for(int i=0; i<PAD_SIZE;++i)
      r_pad_y[i] = r_cnt_v == (VBP+LINE_DLY+1+i);
    for(int i=0; i<PAD_SIZE;++i)
      r_pad_y[i+PAD_SIZE] = r_cnt_v == (VBP+LINE_DLY+VAC+1+i);
  end

  assign o_pad_y = r_pad_y == (VBP+LINE_DLY+1);
  /* Before
  assign o_pad_ln_y[0] = r_cnt_v == (VBP+LINE_DLY+1);
  assign o_pad_ln_y[1] = r_cnt_v == (VBP+LINE_DLY+2);
  assign o_pad_ln_y[2] = r_cnt_v == (VBP+LINE_DLY+VAC+1);
  assign o_pad_ln_y[3] = r_cnt_v == (VBP+LINE_DLY+VAC+2);
  */
endmodule
