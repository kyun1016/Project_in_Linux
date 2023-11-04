// import pkg_tx_data::cls_ctrl_l;
// import pkg_tx_data::cls_ctrl_f;
// import pkg_tx_data::cls_image;

interface itf_data #(
  parameter SIZE_PIXEL = 8 ,
  parameter SIZE_LFSR  = 24
)
(
  input clk,
  input rstn
);
  logic [7:0] x;
  logic [7:0] y;
endinterface
