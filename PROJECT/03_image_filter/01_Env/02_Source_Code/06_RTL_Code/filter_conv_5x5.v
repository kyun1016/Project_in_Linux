// ./list_rtl.f

module filter_conv_5x5
#(
  parameter DATA_WIDTH = 8,
  parameter COEF_WIDTH = 8
)
(
  input                         clk     ,
  input                         rstn    ,

  input signed [COEF_WIDTH-1:0] i_coef00,
  input signed [COEF_WIDTH-1:0] i_coef01,
  input signed [COEF_WIDTH-1:0] i_coef02,
  input signed [COEF_WIDTH-1:0] i_coef03,
  input signed [COEF_WIDTH-1:0] i_coef04,
  input signed [COEF_WIDTH-1:0] i_coef10,
  input signed [COEF_WIDTH-1:0] i_coef11,
  input signed [COEF_WIDTH-1:0] i_coef12,
  input signed [COEF_WIDTH-1:0] i_coef13,
  input signed [COEF_WIDTH-1:0] i_coef14,
  input signed [COEF_WIDTH-1:0] i_coef20,
  input signed [COEF_WIDTH-1:0] i_coef21,
  input signed [COEF_WIDTH-1:0] i_coef22,
  input signed [COEF_WIDTH-1:0] i_coef23,
  input signed [COEF_WIDTH-1:0] i_coef24,
  input signed [COEF_WIDTH-1:0] i_coef30,
  input signed [COEF_WIDTH-1:0] i_coef31,
  input signed [COEF_WIDTH-1:0] i_coef32,
  input signed [COEF_WIDTH-1:0] i_coef33,
  input signed [COEF_WIDTH-1:0] i_coef34,
  input signed [COEF_WIDTH-1:0] i_coef40,
  input signed [COEF_WIDTH-1:0] i_coef41,
  input signed [COEF_WIDTH-1:0] i_coef42,
  input signed [COEF_WIDTH-1:0] i_coef43,
  input signed [COEF_WIDTH-1:0] i_coef44,
  input                         i_de    ,
  input        [DATA_WIDTH-1:0] i_x00   ,
  input        [DATA_WIDTH-1:0] i_x01   ,
  input        [DATA_WIDTH-1:0] i_x02   ,
  input        [DATA_WIDTH-1:0] i_x03   ,
  input        [DATA_WIDTH-1:0] i_x04   ,
  input        [DATA_WIDTH-1:0] i_x10   ,
  input        [DATA_WIDTH-1:0] i_x11   ,
  input        [DATA_WIDTH-1:0] i_x12   ,
  input        [DATA_WIDTH-1:0] i_x13   ,
  input        [DATA_WIDTH-1:0] i_x14   ,
  input        [DATA_WIDTH-1:0] i_x20   ,
  input        [DATA_WIDTH-1:0] i_x21   ,
  input        [DATA_WIDTH-1:0] i_x22   ,
  input        [DATA_WIDTH-1:0] i_x23   ,
  input        [DATA_WIDTH-1:0] i_x24   ,
  input        [DATA_WIDTH-1:0] i_x30   ,
  input        [DATA_WIDTH-1:0] i_x31   ,
  input        [DATA_WIDTH-1:0] i_x32   ,
  input        [DATA_WIDTH-1:0] i_x33   ,
  input        [DATA_WIDTH-1:0] i_x34   ,
  input        [DATA_WIDTH-1:0] i_x40   ,
  input        [DATA_WIDTH-1:0] i_x41   ,
  input        [DATA_WIDTH-1:0] i_x42   ,
  input        [DATA_WIDTH-1:0] i_x43   ,
  input        [DATA_WIDTH-1:0] i_x44   ,
  output reg                    o_de    ,
  output reg   [DATA_WIDTH-1:0] o_y      
);
  wire signed [DATA_WIDTH:0] w_x00 = {1'b0, i_x00};
  wire signed [DATA_WIDTH:0] w_x01 = {1'b0, i_x01};
  wire signed [DATA_WIDTH:0] w_x02 = {1'b0, i_x02};
  wire signed [DATA_WIDTH:0] w_x03 = {1'b0, i_x03};
  wire signed [DATA_WIDTH:0] w_x04 = {1'b0, i_x04};
  wire signed [DATA_WIDTH:0] w_x10 = {1'b0, i_x10};
  wire signed [DATA_WIDTH:0] w_x11 = {1'b0, i_x11};
  wire signed [DATA_WIDTH:0] w_x12 = {1'b0, i_x12};
  wire signed [DATA_WIDTH:0] w_x13 = {1'b0, i_x13};
  wire signed [DATA_WIDTH:0] w_x14 = {1'b0, i_x14};
  wire signed [DATA_WIDTH:0] w_x20 = {1'b0, i_x20};
  wire signed [DATA_WIDTH:0] w_x21 = {1'b0, i_x21};
  wire signed [DATA_WIDTH:0] w_x22 = {1'b0, i_x22};
  wire signed [DATA_WIDTH:0] w_x23 = {1'b0, i_x23};
  wire signed [DATA_WIDTH:0] w_x24 = {1'b0, i_x24};
  wire signed [DATA_WIDTH:0] w_x30 = {1'b0, i_x30};
  wire signed [DATA_WIDTH:0] w_x31 = {1'b0, i_x31};
  wire signed [DATA_WIDTH:0] w_x32 = {1'b0, i_x32};
  wire signed [DATA_WIDTH:0] w_x33 = {1'b0, i_x33};
  wire signed [DATA_WIDTH:0] w_x34 = {1'b0, i_x34};
  wire signed [DATA_WIDTH:0] w_x40 = {1'b0, i_x40};
  wire signed [DATA_WIDTH:0] w_x41 = {1'b0, i_x41};
  wire signed [DATA_WIDTH:0] w_x42 = {1'b0, i_x42};
  wire signed [DATA_WIDTH:0] w_x43 = {1'b0, i_x43};
  wire signed [DATA_WIDTH:0] w_x44 = {1'b0, i_x44};
  wire signed [DATA_WIDTH+COEF_WIDTH:0] w_conv0 = i_coef00 * w_x00 + i_coef01 * w_x01 + i_coef02 * w_x02 + i_coef03 * w_x03 + i_coef04 * w_x04;
  wire signed [DATA_WIDTH+COEF_WIDTH:0] w_conv1 = i_coef10 * w_x10 + i_coef11 * w_x11 + i_coef12 * w_x12 + i_coef13 * w_x13 + i_coef14 * w_x14;
  wire signed [DATA_WIDTH+COEF_WIDTH:0] w_conv2 = i_coef20 * w_x20 + i_coef21 * w_x21 + i_coef22 * w_x22 + i_coef23 * w_x23 + i_coef24 * w_x24;
  wire signed [DATA_WIDTH+COEF_WIDTH:0] w_conv3 = i_coef30 * w_x30 + i_coef31 * w_x31 + i_coef32 * w_x32 + i_coef33 * w_x33 + i_coef34 * w_x34;
  wire signed [DATA_WIDTH+COEF_WIDTH:0] w_conv4 = i_coef40 * w_x40 + i_coef41 * w_x41 + i_coef42 * w_x42 + i_coef43 * w_x43 + i_coef44 * w_x44;
  wire signed [DATA_WIDTH+COEF_WIDTH:0] w_conv = w_conv0 + w_conv1 + w_conv2 + w_conv3 + w_conv4;

  always @(posedge clk, negedge rstn) begin
    if(!rstn)
      o_de <= 1'b0;
    else
      o_de <= i_de;
  end

  always @(posedge clk, negedge rstn) begin
    if(!rstn)
      o_y <= 'b0;
    else if (i_de)
      o_y <= w_conv[COEF_WIDTH+:DATA_WIDTH];
  end

endmodule
