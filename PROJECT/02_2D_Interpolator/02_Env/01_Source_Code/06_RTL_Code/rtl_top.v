// ./list_rtl.f

module rtl_top(
  input        clk      ,
  input        rst_n    ,

  input        i_en     ,
  input  [7:0] i_x      ,
  input  [9:0] i_weight0,
  input  [9:0] i_weight1,
  input  [9:0] i_weight2,
  input  [9:0] i_weight3,
  input  [9:0] i_weight4,
  input  [9:0] i_weight5,
  input  [9:0] i_weight6,
  input  [9:0] i_weight7,
  output [9:0] o_y      
);

  linear_interpolator_2d u_itp
  (
    .clk      (clk      ),
    .rst_n    (rst_n    ),
                        
    .i_en     (i_en     ),
    .i_x      (i_x      ),
    .i_weight0(i_weight0),
    .i_weight1(i_weight1),
    .i_weight2(i_weight2),
    .i_weight3(i_weight3),
    .i_weight4(i_weight4),
    .i_weight5(i_weight5),
    .i_weight6(i_weight6),
    .i_weight7(i_weight7),
                        
    .o_y      (o_y      )
  );

endmodule
