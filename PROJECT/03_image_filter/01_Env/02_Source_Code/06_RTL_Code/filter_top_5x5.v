// ./list_rtl.f

module filter_top_5x5
#(
  parameter INPUT_DATA_WIDTH  = 8,
  parameter OUTPUT_DATA_WIDTH = 8,
  parameter CSC_WIDTH         = 8,
  parameter BIAS_WIDTH        = 8
)
(
  input                                     clk      ,
  input                                     rstn     ,
  input   [INPUT_DATA_WIDTH-1:0]            i_x      ,
  input                                     i_en     ,
  input   [1:0]                             i_sel_ln ,
  input   [1:0]                             i_sel_px ,
  input   [10:0]                             i_addr_ln,
  input   [10:0]                             i_addr_px,

  output  [OUTPUT_DATA_WIDTH-1:0]           o_y     
);

  wire signed [OUTPUT_DATA_WIDTH-1:0] w_y00;
  wire signed [OUTPUT_DATA_WIDTH-1:0] w_y01;
  wire signed [OUTPUT_DATA_WIDTH-1:0] w_y02;
  wire signed [OUTPUT_DATA_WIDTH-1:0] w_y03;
  wire signed [OUTPUT_DATA_WIDTH-1:0] w_y04;
  wire signed [OUTPUT_DATA_WIDTH-1:0] w_y10;
  wire signed [OUTPUT_DATA_WIDTH-1:0] w_y11;
  wire signed [OUTPUT_DATA_WIDTH-1:0] w_y12;
  wire signed [OUTPUT_DATA_WIDTH-1:0] w_y13;
  wire signed [OUTPUT_DATA_WIDTH-1:0] w_y14;
  wire signed [OUTPUT_DATA_WIDTH-1:0] w_y20;
  wire signed [OUTPUT_DATA_WIDTH-1:0] w_y21;
  wire signed [OUTPUT_DATA_WIDTH-1:0] w_y22;
  wire signed [OUTPUT_DATA_WIDTH-1:0] w_y23;
  wire signed [OUTPUT_DATA_WIDTH-1:0] w_y24;
  wire signed [OUTPUT_DATA_WIDTH-1:0] w_y30;
  wire signed [OUTPUT_DATA_WIDTH-1:0] w_y31;
  wire signed [OUTPUT_DATA_WIDTH-1:0] w_y32;
  wire signed [OUTPUT_DATA_WIDTH-1:0] w_y33;
  wire signed [OUTPUT_DATA_WIDTH-1:0] w_y34;
  wire signed [OUTPUT_DATA_WIDTH-1:0] w_y40;
  wire signed [OUTPUT_DATA_WIDTH-1:0] w_y41;
  wire signed [OUTPUT_DATA_WIDTH-1:0] w_y42;
  wire signed [OUTPUT_DATA_WIDTH-1:0] w_y43;
  wire signed [OUTPUT_DATA_WIDTH-1:0] w_y44;
  filter_data_align_5x5 u_data_align(
    .clk      (clk      ),
    .rstn     (rstn     ),
    .i_en     (i_en     ),
    .i_x      (i_x      ),
    .i_sel_ln (i_sel_ln ),
    .i_sel_px (i_sel_px ),
    .i_addr_ln(i_addr_ln),
    .i_addr_px(i_addr_px),
    .o_y00    (w_y00    ),
    .o_y01    (w_y01    ),
    .o_y02    (w_y02    ),
    .o_y03    (w_y03    ),
    .o_y04    (w_y04    ),
    .o_y10    (w_y10    ),
    .o_y11    (w_y11    ),
    .o_y12    (w_y12    ),
    .o_y13    (w_y13    ),
    .o_y14    (w_y14    ),
    .o_y20    (w_y20    ),
    .o_y21    (w_y21    ),
    .o_y22    (w_y22    ),
    .o_y23    (w_y23    ),
    .o_y24    (w_y24    ),
    .o_y30    (w_y30    ),
    .o_y31    (w_y31    ),
    .o_y32    (w_y32    ),
    .o_y33    (w_y33    ),
    .o_y34    (w_y34    ),
    .o_y40    (w_y40    ),
    .o_y41    (w_y41    ),
    .o_y42    (w_y42    ),
    .o_y43    (w_y43    ),
    .o_y44    (w_y44    )
  );
  filter_mul_5x5 u_mul (
    .clk     (clk),
    .rstn    (rstn),
    .i_en    (),
    .i_coef00(),
    .i_coef01(),
    .i_coef02(),
    .i_coef03(),
    .i_coef04(),
    .i_coef10(),
    .i_coef11(),
    .i_coef12(),
    .i_coef13(),
    .i_coef14(),
    .i_coef20(),
    .i_coef21(),
    .i_coef22(),
    .i_coef23(),
    .i_coef24(),
    .i_coef30(),
    .i_coef31(),
    .i_coef32(),
    .i_coef33(),
    .i_coef34(),
    .i_coef40(),
    .i_coef41(),
    .i_coef42(),
    .i_coef43(),
    .i_coef44(),
    .i_bias0 (),
    .i_bias1 (),
    .i_bias2 (),
    .i_bias3 (),
    .i_bias4 (),
    .i_x00   (w_y00),
    .i_x01   (w_y01),
    .i_x02   (w_y02),
    .i_x03   (w_y03),
    .i_x04   (w_y04),
    .i_x10   (w_y10),
    .i_x11   (w_y11),
    .i_x12   (w_y12),
    .i_x13   (w_y13),
    .i_x14   (w_y14),
    .i_x20   (w_y20),
    .i_x21   (w_y21),
    .i_x22   (w_y22),
    .i_x23   (w_y23),
    .i_x24   (w_y24),
    .i_x30   (w_y30),
    .i_x31   (w_y31),
    .i_x32   (w_y32),
    .i_x33   (w_y33),
    .i_x34   (w_y34),
    .i_x40   (w_y40),
    .i_x41   (w_y41),
    .i_x42   (w_y42),
    .i_x43   (w_y43),
    .i_x44   (w_y44),
    .o_y     (o_y  ) 
  );

endmodule
