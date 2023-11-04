// ./list_interface.f


interface itf_data #(
  parameter SIZE_PIXEL = 8 ,
  parameter SIZE_LFSR  = 24
)
(
  input clk,
  input rst_n
);
  logic       i_en     ;
  logic [7:0] i_x      ;
  logic [9:0] i_weight0;
  logic [9:0] i_weight1;
  logic [9:0] i_weight2;
  logic [9:0] i_weight3;
  logic [9:0] i_weight4;
  logic [9:0] i_weight5;
  logic [9:0] i_weight6;
  logic [9:0] i_weight7;
  logic [9:0] o_y      ;
endinterface
