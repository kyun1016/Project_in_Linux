// ./list_rtl.f

module simple_dual_one_clock
#(
  parameter DATA_WIDTH = 8,
  parameter ADDR_WIDTH = 12

)
(
  input                       clk     ,
  input                       i_a_en  ,
  input                       i_b_en  ,
  input                       i_a_we  ,
  input      [ADDR_WIDTH-1:0] i_a_addr,
  input      [ADDR_WIDTH-1:0] i_b_addr,
  input      [DATA_WIDTH-1:0] i_a_data,
  output reg [DATA_WIDTH-1:0] o_b_data
);
  reg [DATA_WIDTH-1:0] ram [(1<<ADDR_WIDTH)-1:0];
  always @(posedge clk) begin
    if (i_a_en & i_a_we)
      ram[i_a_addr] <= i_a_data;
  end

  always @(posedge clk) begin
    if (i_b_en)
      o_b_data <= ram[i_b_addr];
  end
endmodule
