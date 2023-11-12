// ./list_rtl.f

module filter_conv_5x5
#(
  parameter DATA_WIDTH = 8,
  parameter CONF_WIDTH = 8
)
(
  input                              clk     ,
  input                              rstn    ,

  input                              i_en    ,
  input      signed [COEF_WIDTH-1:0] i_coef00,
  input      signed [COEF_WIDTH-1:0] i_coef01,
  input      signed [COEF_WIDTH-1:0] i_coef02,
  input      signed [COEF_WIDTH-1:0] i_coef03,
  input      signed [COEF_WIDTH-1:0] i_coef04,
  input      signed [COEF_WIDTH-1:0] i_coef10,
  input      signed [COEF_WIDTH-1:0] i_coef11,
  input      signed [COEF_WIDTH-1:0] i_coef12,
  input      signed [COEF_WIDTH-1:0] i_coef13,
  input      signed [COEF_WIDTH-1:0] i_coef14,
  input      signed [COEF_WIDTH-1:0] i_coef20,
  input      signed [COEF_WIDTH-1:0] i_coef21,
  input      signed [COEF_WIDTH-1:0] i_coef22,
  input      signed [COEF_WIDTH-1:0] i_coef23,
  input      signed [COEF_WIDTH-1:0] i_coef24,
  input      signed [COEF_WIDTH-1:0] i_coef30,
  input      signed [COEF_WIDTH-1:0] i_coef31,
  input      signed [COEF_WIDTH-1:0] i_coef32,
  input      signed [COEF_WIDTH-1:0] i_coef33,
  input      signed [COEF_WIDTH-1:0] i_coef34,
  input      signed [COEF_WIDTH-1:0] i_coef40,
  input      signed [COEF_WIDTH-1:0] i_coef41,
  input      signed [COEF_WIDTH-1:0] i_coef42,
  input      signed [COEF_WIDTH-1:0] i_coef43,
  input      signed [COEF_WIDTH-1:0] i_coef44,
  input      signed [DATA_WIDTH-1:0] i_x00   ,
  input      signed [DATA_WIDTH-1:0] i_x01   ,
  input      signed [DATA_WIDTH-1:0] i_x02   ,
  input      signed [DATA_WIDTH-1:0] i_x03   ,
  input      signed [DATA_WIDTH-1:0] i_x04   ,
  input      signed [DATA_WIDTH-1:0] i_x10   ,
  input      signed [DATA_WIDTH-1:0] i_x11   ,
  input      signed [DATA_WIDTH-1:0] i_x12   ,
  input      signed [DATA_WIDTH-1:0] i_x13   ,
  input      signed [DATA_WIDTH-1:0] i_x14   ,
  input      signed [DATA_WIDTH-1:0] i_x20   ,
  input      signed [DATA_WIDTH-1:0] i_x21   ,
  input      signed [DATA_WIDTH-1:0] i_x22   ,
  input      signed [DATA_WIDTH-1:0] i_x23   ,
  input      signed [DATA_WIDTH-1:0] i_x24   ,
  input      signed [DATA_WIDTH-1:0] i_x30   ,
  input      signed [DATA_WIDTH-1:0] i_x31   ,
  input      signed [DATA_WIDTH-1:0] i_x32   ,
  input      signed [DATA_WIDTH-1:0] i_x33   ,
  input      signed [DATA_WIDTH-1:0] i_x34   ,
  input      signed [DATA_WIDTH-1:0] i_x40   ,
  input      signed [DATA_WIDTH-1:0] i_x41   ,
  input      signed [DATA_WIDTH-1:0] i_x42   ,
  input      signed [DATA_WIDTH-1:0] i_x43   ,
  input      signed [DATA_WIDTH-1:0] i_x44   ,
  output reg signed [DATA_WIDTH-1:0] o_y      
);

  // (o_y0)   (i_coef00 i_coef01 i_coef02) (i_x0)   (i_bias0)
  // (o_y1) = (i_coef10 i_coef11 i_coef12) (i_x1) + (i_bias1)
  // (o_y2)   (i_coef20 i_coef21 i_coef22) (i_x2)   (i_bias2)
  // wire signed [INPUT_DATA_WIDTH+COEF_WIDTH-1:0] w_mul0 = i_coef00 * i_x0 + i_coef01 * i_x1 + i_coef02 * i_x2 + i_bias0;
  // wire signed [INPUT_DATA_WIDTH+COEF_WIDTH-1:0] w_mul1 = i_coef10 * i_x0 + i_coef11 * i_x1 + i_coef12 * i_x2 + i_bias1;
  // wire signed [INPUT_DATA_WIDTH+COEF_WIDTH-1:0] w_mul2 = i_coef20 * i_x0 + i_coef21 * i_x1 + i_coef22 * i_x2 + i_bias2;

  // always @(posedge clk, negedge rstn) begin
  //   if(!rstn) begin
  //     o_y0 <= 0;
  //     o_y1 <= 0;
  //     o_y2 <= 0;
  //   end
  //   else if(i_en) begin
  //     o_y0 <= w_mul0;
  //     o_y1 <= w_mul1;
  //     o_y2 <= w_mul2;
  //   end
  // end

endmodule
