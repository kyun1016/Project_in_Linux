// ./list_rtl.f

module mat_mul_3x3 
#(
  parameter INPUT_DATA_WIDTH  = 8,
  parameter OUTPUT_DATA_WIDTH = 8,
  parameter CSC_WIDTH         = 8,
  parameter BIAS_WIDTH        = 8
)
(
  input                                     clk     ,
  input                                     rstn    ,

  input                                     i_en    ,
  input      signed [CSC_WIDTH-1:0]         i_coef00,
  input      signed [CSC_WIDTH-1:0]         i_coef01,
  input      signed [CSC_WIDTH-1:0]         i_coef02,
  input      signed [CSC_WIDTH-1:0]         i_coef10,
  input      signed [CSC_WIDTH-1:0]         i_coef11,
  input      signed [CSC_WIDTH-1:0]         i_coef12,
  input      signed [CSC_WIDTH-1:0]         i_coef20,
  input      signed [CSC_WIDTH-1:0]         i_coef21,
  input      signed [CSC_WIDTH-1:0]         i_coef22,
  input      signed [BIAS_WIDTH-1:0]        i_bias0 ,
  input      signed [BIAS_WIDTH-1:0]        i_bias1 ,
  input      signed [BIAS_WIDTH-1:0]        i_bias2 ,
  input      signed [INPUT_DATA_WIDTH-1:0]  i_x0    ,
  input      signed [INPUT_DATA_WIDTH-1:0]  i_x1    ,
  input      signed [INPUT_DATA_WIDTH-1:0]  i_x2    ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y0    ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y1    ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y2    
);

  // (o_y0)   (i_coef00 i_coef01 i_coef02) (i_x0)   (i_bias0)
  // (o_y1) = (i_coef10 i_coef11 i_coef12) (i_x1) + (i_bias1)
  // (o_y2)   (i_coef20 i_coef21 i_coef22) (i_x2)   (i_bias2)
  wire signed [INPUT_DATA_WIDTH+CSC_WIDTH-1:0] w_mul0 = i_coef00 * i_x0 + i_coef01 * i_x1 + i_coef02 * i_x2 + i_bias0;
  wire signed [INPUT_DATA_WIDTH+CSC_WIDTH-1:0] w_mul1 = i_coef10 * i_x0 + i_coef11 * i_x1 + i_coef12 * i_x2 + i_bias1;
  wire signed [INPUT_DATA_WIDTH+CSC_WIDTH-1:0] w_mul2 = i_coef20 * i_x0 + i_coef21 * i_x1 + i_coef22 * i_x2 + i_bias2;

  always @(posedge clk, negedge rstn) begin
    if(!rstn) begin
      o_y0 <= 0;
      o_y1 <= 0;
      o_y2 <= 0;
    end
    else if(i_en) begin
      o_y0 <= w_mul0;
      o_y1 <= w_mul1;
      o_y2 <= w_mul2;
    end
  end

endmodule
