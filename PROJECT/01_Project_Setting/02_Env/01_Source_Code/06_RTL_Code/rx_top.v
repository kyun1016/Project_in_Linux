// ./list_rtl.f

module rx_top(
  input            clk ,
  input            rstn,

  input      [7:0] i_x ,

  output reg [7:0] o_y
);

  always @(posedge clk, negedge rstn) begin
    if(!rstn)
      o_y <= 0;
    else
      o_y <= i_x;
  end

endmodule
