
// ./list_rtl.f

module apb_slave
#(
  parameter ADDR_WIDTH      = 10  , // maximum width 32 bits
  parameter DATA_WIDTH      = 8     // 8/16/32 bits wide
)
(
  input                   clk      , // clock signal. 
  input                   rstn     ,
  
  input  [ADDR_WIDTH-1:0] i_PADDR  , // APB address bus
  input                   i_PSEL   , // Select
  input                   i_PENABLE, // Enable
  input                   i_PWRITE , // Direction
  input  [DATA_WIDTH-1:0] i_PWDATA , // Write data (PWRITE is HIGH)
  input                   i_PREADY , // used to extend an APB transfer by the Completer
  output [DATA_WIDTH-1:0] o_PRDATA , // Write data (PWRITE is HIGH)

  output [9:0]            o_weight0,
  output [9:0]            o_weight1,
  output [9:0]            o_weight2,
  output [9:0]            o_weight3,
  output [9:0]            o_weight4,
  output [9:0]            o_weight5,
  output [9:0]            o_weight6,
  output [9:0]            o_weight7 
);

  reg [ADDR_WIDTH-1:0] r_addr;
  reg [ADDR_WIDTH*DATA_WIDTH-1:0] r_mem;

  always @(posedge clk, negedge rstn) begin
    if(!rstn)
      r_addr <= 0;
    else if(!i_PWRITE && i_PENABLE)
      r_addr <= i_PADDR;
  end

  assign o_PRDATA  = r_mem[r_addr];

  assign o_weight0 = r_mem[00+:10];
  assign o_weight1 = r_mem[10+:10];
  assign o_weight2 = r_mem[20+:10];
  assign o_weight3 = r_mem[30+:10];
  assign o_weight4 = r_mem[40+:10];
  assign o_weight5 = r_mem[50+:10];
  assign o_weight6 = r_mem[60+:10];
  assign o_weight7 = r_mem[70+:10];
endmodule
