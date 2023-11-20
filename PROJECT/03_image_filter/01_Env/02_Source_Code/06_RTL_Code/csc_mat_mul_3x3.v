// ./list_rtl.f

module csc_mat_mul_3x3 
#(
  parameter DATA_WIDTH  = 8 ,
  parameter COEF_WIDTH  = 10,
  parameter BIAS_WIDTH  = 8 ,
  parameter RL          = 9
)
(
  input                              clk     ,
  input                              rstn    ,

  input                              i_bypass,
  input  signed     [COEF_WIDTH-1:0] i_coef00,
  input  signed     [COEF_WIDTH-1:0] i_coef01,
  input  signed     [COEF_WIDTH-1:0] i_coef02,
  input  signed     [COEF_WIDTH-1:0] i_coef10,
  input  signed     [COEF_WIDTH-1:0] i_coef11,
  input  signed     [COEF_WIDTH-1:0] i_coef12,
  input  signed     [COEF_WIDTH-1:0] i_coef20,
  input  signed     [COEF_WIDTH-1:0] i_coef21,
  input  signed     [COEF_WIDTH-1:0] i_coef22,
  input  signed     [BIAS_WIDTH-1:0] i_bias0 ,
  input  signed     [BIAS_WIDTH-1:0] i_bias1 ,
  input  signed     [BIAS_WIDTH-1:0] i_bias2 ,
  input                              i_vs    ,
  input                              i_hs    ,
  input                              i_de    ,
  input             [DATA_WIDTH-1:0] i_x0    ,
  input             [DATA_WIDTH-1:0] i_x1    ,
  input             [DATA_WIDTH-1:0] i_x2    ,
  output        reg                  o_vs    ,
  output        reg                  o_hs    ,
  output        reg                  o_de    ,
  output        reg [DATA_WIDTH-1:0] o_y0    ,
  output reg signed [DATA_WIDTH-1:0] o_y1    ,
  output reg signed [DATA_WIDTH-1:0] o_y2    
);
  //=============================================================
  // Part 1. Sign Extension
  //==============================================================
  wire signed [DATA_WIDTH:0] w_x0 = {1'b0, i_x0};
  wire signed [DATA_WIDTH:0] w_x1 = {1'b0, i_x1};
  wire signed [DATA_WIDTH:0] w_x2 = {1'b0, i_x2};

  //=============================================================
  // Part 2. Calc Matrix Multiply
  //==============================================================
  wire signed [DATA_WIDTH+COEF_WIDTH:0] w_y0 = i_coef00 * w_x0 + i_coef01 * w_x1 + i_coef02 * w_x2 + i_bias0;
  wire signed [DATA_WIDTH+COEF_WIDTH:0] w_y1 = i_coef10 * w_x0 + i_coef11 * w_x1 + i_coef12 * w_x2 + i_bias1;
  wire signed [DATA_WIDTH+COEF_WIDTH:0] w_y2 = i_coef20 * w_x0 + i_coef21 * w_x1 + i_coef22 * w_x2 + i_bias2;

  //=============================================================
  // Part 3. Round Function
  //==============================================================
  wire signed [DATA_WIDTH+1:0] w_y0_r = w_y0[RL+:DATA_WIDTH+2] + w_y0[RL-1];
  wire signed [DATA_WIDTH+1:0] w_y1_r = w_y1[RL+:DATA_WIDTH+2] + w_y1[RL-1];
  wire signed [DATA_WIDTH+1:0] w_y2_r = w_y2[RL+:DATA_WIDTH+2] + w_y2[RL-1];

  //=============================================================
  // Part 4. Cilp Function
  //==============================================================
  wire signed [DATA_WIDTH-1:0] w_y0_c = w_y0_r[DATA_WIDTH+1] ? 'd0 : w_y0_r[DATA_WIDTH] ? {DATA_WIDTH{1'b1}} : w_y0_r[DATA_WIDTH-1:0];
  
  //=============================================================
  // Part 5. Output Mapping
  //==============================================================
  always @(posedge clk, negedge rstn) begin
    if(!rstn) begin
      o_vs <= 1'b0;
      o_hs <= 1'b0;
      o_de <= 1'b0;
    end
    else begin
      o_vs <= i_vs;
      o_hs <= i_hs;
      o_de <= i_de;
    end
  end

  always @(posedge clk, negedge rstn) begin
    if(!rstn) begin
      o_y0 <= 0;
      o_y1 <= 0;
      o_y2 <= 0;
    end
    else if(i_de) begin
      o_y0 <= w_y0_c;
      o_y1 <= w_y1_r[DATA_WIDTH-1:0];
      o_y2 <= w_y2_r[DATA_WIDTH-1:0];
    end
  end

endmodule
