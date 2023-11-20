
// ./list_rtl.f

module apb_slave
#(
  parameter ADDR_WIDTH      = 10  , // maximum width 32 bits
  parameter DATA_WIDTH      = 32    // 8/16/32 bits wide
)
(
  input                       clk             , // clock signal. 
  input                       rstn            ,
  input      [ADDR_WIDTH-1:0] i_PADDR         , // APB address bus
  input                       i_PSEL          , // Select
  input                       i_PENABLE       , // Enable
  input                       i_PWRITE        , // Direction
  input      [31:0]           i_PWDATA        , // Write data (PWRITE is HIGH)
  output reg                  o_PREADY        , // used to extend an APB transfer by the Completer
  output reg [31:0]           o_PRDATA        , // Write data (PWRITE is HIGH)
  output reg [9:0]            o_csc_coef00    ,
  output reg [9:0]            o_csc_coef01    ,
  output reg [9:0]            o_csc_coef02    ,
  output reg [9:0]            o_csc_coef10    ,
  output reg [9:0]            o_csc_coef11    ,
  output reg [9:0]            o_csc_coef12    ,
  output reg [9:0]            o_csc_coef20    ,
  output reg [9:0]            o_csc_coef21    ,
  output reg [9:0]            o_csc_coef22    ,
  output reg [7:0]            o_csc_bias0     ,
  output reg [7:0]            o_csc_bias1     ,
  output reg [7:0]            o_csc_bias2     ,
  output reg [9:0]            o_icsc_coef00   ,
  output reg [9:0]            o_icsc_coef01   ,
  output reg [9:0]            o_icsc_coef02   ,
  output reg [9:0]            o_icsc_coef10   ,
  output reg [9:0]            o_icsc_coef11   ,
  output reg [9:0]            o_icsc_coef12   ,
  output reg [9:0]            o_icsc_coef20   ,
  output reg [9:0]            o_icsc_coef21   ,
  output reg [9:0]            o_icsc_coef22   ,
  output reg [7:0]            o_icsc_bias0    ,
  output reg [7:0]            o_icsc_bias1    ,
  output reg [7:0]            o_icsc_bias2    ,
  output reg [9:0]            o_filter1_coef00,
  output reg [9:0]            o_filter1_coef01,
  output reg [9:0]            o_filter1_coef02,
  output reg [9:0]            o_filter1_coef03,
  output reg [9:0]            o_filter1_coef04,
  output reg [9:0]            o_filter1_coef10,
  output reg [9:0]            o_filter1_coef11,
  output reg [9:0]            o_filter1_coef12,
  output reg [9:0]            o_filter1_coef13,
  output reg [9:0]            o_filter1_coef14,
  output reg [9:0]            o_filter1_coef20,
  output reg [9:0]            o_filter1_coef21,
  output reg [9:0]            o_filter1_coef22,
  output reg [9:0]            o_filter1_coef23,
  output reg [9:0]            o_filter1_coef24,
  output reg [9:0]            o_filter1_coef30,
  output reg [9:0]            o_filter1_coef31,
  output reg [9:0]            o_filter1_coef32,
  output reg [9:0]            o_filter1_coef33,
  output reg [9:0]            o_filter1_coef34,
  output reg [9:0]            o_filter1_coef40,
  output reg [9:0]            o_filter1_coef41,
  output reg [9:0]            o_filter1_coef42,
  output reg [9:0]            o_filter1_coef43,
  output reg [9:0]            o_filter1_coef44,
  output reg [9:0]            o_filter2_coef00,
  output reg [9:0]            o_filter2_coef01,
  output reg [9:0]            o_filter2_coef02,
  output reg [9:0]            o_filter2_coef03,
  output reg [9:0]            o_filter2_coef04,
  output reg [9:0]            o_filter2_coef10,
  output reg [9:0]            o_filter2_coef11,
  output reg [9:0]            o_filter2_coef12,
  output reg [9:0]            o_filter2_coef13,
  output reg [9:0]            o_filter2_coef14,
  output reg [9:0]            o_filter2_coef20,
  output reg [9:0]            o_filter2_coef21,
  output reg [9:0]            o_filter2_coef22,
  output reg [9:0]            o_filter2_coef23,
  output reg [9:0]            o_filter2_coef24,
  output reg [9:0]            o_filter2_coef30,
  output reg [9:0]            o_filter2_coef31,
  output reg [9:0]            o_filter2_coef32,
  output reg [9:0]            o_filter2_coef33,
  output reg [9:0]            o_filter2_coef34,
  output reg [9:0]            o_filter2_coef40,
  output reg [9:0]            o_filter2_coef41,
  output reg [9:0]            o_filter2_coef42,
  output reg [9:0]            o_filter2_coef43,
  output reg [9:0]            o_filter2_coef44,
  output reg                  o_csc_bypass    ,
  output reg                  o_filter1_bypass,
  output reg                  o_filter2_bypass,
  output reg                  o_icsc_bypass    
);
  localparam CSC_COEF0      = 8'h00;
  localparam CSC_COEF1      = 8'h04;
  localparam CSC_COEF2      = 8'h08;
  localparam CSC_BIAS       = 8'h0C;
  localparam ICSC_COEF0     = 8'h10;
  localparam ICSC_COEF1     = 8'h14;
  localparam ICSC_COEF2     = 8'h18;
  localparam ICSC_BIAS      = 8'h1C;
  localparam FILTER1_COEF00 = 8'h20;
  localparam FILTER1_COEF03 = 8'h24;
  localparam FILTER1_COEF10 = 8'h28;
  localparam FILTER1_COEF13 = 8'h2C;
  localparam FILTER1_COEF20 = 8'h30;
  localparam FILTER1_COEF23 = 8'h34;
  localparam FILTER1_COEF30 = 8'h38;
  localparam FILTER1_COEF33 = 8'h3C;
  localparam FILTER1_COEF40 = 8'h40;
  localparam FILTER1_COEF43 = 8'h44;
  localparam FILTER2_COEF00 = 8'h48;
  localparam FILTER2_COEF03 = 8'h4C;
  localparam FILTER2_COEF10 = 8'h50;
  localparam FILTER2_COEF13 = 8'h54;
  localparam FILTER2_COEF20 = 8'h58;
  localparam FILTER2_COEF23 = 8'h5C;
  localparam FILTER2_COEF30 = 8'h60;
  localparam FILTER2_COEF33 = 8'h64;
  localparam FILTER2_COEF40 = 8'h68;
  localparam FILTER2_COEF43 = 8'h6C;
  localparam BYPASS         = 8'h70;

  always @(posedge clk, negedge rstn) begin
    if(!rstn)
      o_PREADY <= 1'b0;
    else
      o_PREADY <= i_PSEL & i_PENABLE;
  end

  always @(posedge clk, negedge rstn) begin
    if(!rstn)
      o_PRDATA <= 8'b0;
    else if(i_PSEL & !i_PWRITE & i_PENABLE) begin
      case(i_PADDR)
        CSC_COEF0      : o_PRDATA <= {2'b0, o_csc_coef02, o_csc_coef01, o_csc_coef00}            ;
        CSC_COEF1      : o_PRDATA <= {2'b0, o_csc_coef12, o_csc_coef11, o_csc_coef10}            ;
        CSC_COEF2      : o_PRDATA <= {2'b0, o_csc_coef22, o_csc_coef21, o_csc_coef20}            ;
        CSC_BIAS       : o_PRDATA <= {8'b0, o_csc_bias2 , o_csc_bias1 , o_csc_bias0 }            ;
        ICSC_COEF0     : o_PRDATA <= {2'b0, o_icsc_coef02, o_icsc_coef01, o_icsc_coef00}         ;
        ICSC_COEF1     : o_PRDATA <= {2'b0, o_icsc_coef12, o_icsc_coef11, o_icsc_coef10}         ;
        ICSC_COEF2     : o_PRDATA <= {2'b0, o_icsc_coef22, o_icsc_coef21, o_icsc_coef20}         ;
        ICSC_BIAS      : o_PRDATA <= {8'b0, o_icsc_bias2 , o_icsc_bias1 , o_icsc_bias0 }         ;
        FILTER1_COEF00 : o_PRDATA <= {2'b0, o_filter1_coef02, o_filter1_coef01, o_filter1_coef00};
        FILTER1_COEF03 : o_PRDATA <= {2'b0, 10'b0           , o_filter1_coef04, o_filter1_coef03};
        FILTER1_COEF10 : o_PRDATA <= {2'b0, o_filter1_coef12, o_filter1_coef11, o_filter1_coef10};
        FILTER1_COEF13 : o_PRDATA <= {2'b0, 10'b0           , o_filter1_coef14, o_filter1_coef13};
        FILTER1_COEF20 : o_PRDATA <= {2'b0, o_filter1_coef22, o_filter1_coef21, o_filter1_coef20};
        FILTER1_COEF23 : o_PRDATA <= {2'b0, 10'b0           , o_filter1_coef24, o_filter1_coef23};
        FILTER1_COEF30 : o_PRDATA <= {2'b0, o_filter1_coef32, o_filter1_coef31, o_filter1_coef30};
        FILTER1_COEF33 : o_PRDATA <= {2'b0, 10'b0           , o_filter1_coef34, o_filter1_coef33};
        FILTER1_COEF40 : o_PRDATA <= {2'b0, o_filter1_coef42, o_filter1_coef41, o_filter1_coef40};
        FILTER1_COEF43 : o_PRDATA <= {2'b0, 10'b0           , o_filter1_coef44, o_filter1_coef43};
        FILTER2_COEF00 : o_PRDATA <= {2'b0, o_filter2_coef02, o_filter2_coef01, o_filter2_coef00};
        FILTER2_COEF03 : o_PRDATA <= {2'b0, 10'b0           , o_filter2_coef04, o_filter2_coef03};
        FILTER2_COEF10 : o_PRDATA <= {2'b0, o_filter2_coef12, o_filter2_coef11, o_filter2_coef10};
        FILTER2_COEF13 : o_PRDATA <= {2'b0, 10'b0           , o_filter2_coef14, o_filter2_coef13};
        FILTER2_COEF20 : o_PRDATA <= {2'b0, o_filter2_coef22, o_filter2_coef21, o_filter2_coef20};
        FILTER2_COEF23 : o_PRDATA <= {2'b0, 10'b0           , o_filter2_coef24, o_filter2_coef23};
        FILTER2_COEF30 : o_PRDATA <= {2'b0, o_filter2_coef32, o_filter2_coef31, o_filter2_coef30};
        FILTER2_COEF33 : o_PRDATA <= {2'b0, 10'b0           , o_filter2_coef34, o_filter2_coef33};
        FILTER2_COEF40 : o_PRDATA <= {2'b0, o_filter2_coef42, o_filter2_coef41, o_filter2_coef40};
        FILTER2_COEF43 : o_PRDATA <= {2'b0, 10'b0           , o_filter2_coef44, o_filter2_coef43};
        BYPASS         : o_PRDATA <= {28'b0, o_icsc_bypass, o_filter2_bypass, o_filter1_bypass, o_csc_bypass};
      endcase
    end
  end
  
  always @(posedge clk, negedge rstn) begin
    if(!rstn) begin
      o_csc_coef00     <= 0;
      o_csc_coef01     <= 0;
      o_csc_coef02     <= 0;
      o_csc_coef10     <= 0;
      o_csc_coef11     <= 0;
      o_csc_coef12     <= 0;
      o_csc_coef20     <= 0;
      o_csc_coef21     <= 0;
      o_csc_coef22     <= 0;
      o_csc_bias0      <= 0;
      o_csc_bias1      <= 0;
      o_csc_bias2      <= 0;
      o_icsc_coef00    <= 0;
      o_icsc_coef01    <= 0;
      o_icsc_coef02    <= 0;
      o_icsc_coef10    <= 0;
      o_icsc_coef11    <= 0;
      o_icsc_coef12    <= 0;
      o_icsc_coef20    <= 0;
      o_icsc_coef21    <= 0;
      o_icsc_coef22    <= 0;
      o_icsc_bias0     <= 0;
      o_icsc_bias1     <= 0;
      o_icsc_bias2     <= 0;
      o_filter1_coef00 <= 0;
      o_filter1_coef01 <= 0;
      o_filter1_coef02 <= 0;
      o_filter1_coef03 <= 0;
      o_filter1_coef04 <= 0;
      o_filter1_coef10 <= 0;
      o_filter1_coef11 <= 0;
      o_filter1_coef12 <= 0;
      o_filter1_coef13 <= 0;
      o_filter1_coef14 <= 0;
      o_filter1_coef20 <= 0;
      o_filter1_coef21 <= 0;
      o_filter1_coef22 <= 0;
      o_filter1_coef23 <= 0;
      o_filter1_coef24 <= 0;
      o_filter1_coef30 <= 0;
      o_filter1_coef31 <= 0;
      o_filter1_coef32 <= 0;
      o_filter1_coef33 <= 0;
      o_filter1_coef34 <= 0;
      o_filter1_coef40 <= 0;
      o_filter1_coef41 <= 0;
      o_filter1_coef42 <= 0;
      o_filter1_coef43 <= 0;
      o_filter1_coef44 <= 0;
      o_filter2_coef00 <= 0;
      o_filter2_coef01 <= 0;
      o_filter2_coef02 <= 0;
      o_filter2_coef03 <= 0;
      o_filter2_coef04 <= 0;
      o_filter2_coef10 <= 0;
      o_filter2_coef11 <= 0;
      o_filter2_coef12 <= 0;
      o_filter2_coef13 <= 0;
      o_filter2_coef14 <= 0;
      o_filter2_coef20 <= 0;
      o_filter2_coef21 <= 0;
      o_filter2_coef22 <= 0;
      o_filter2_coef23 <= 0;
      o_filter2_coef24 <= 0;
      o_filter2_coef30 <= 0;
      o_filter2_coef31 <= 0;
      o_filter2_coef32 <= 0;
      o_filter2_coef33 <= 0;
      o_filter2_coef34 <= 0;
      o_filter2_coef40 <= 0;
      o_filter2_coef41 <= 0;
      o_filter2_coef42 <= 0;
      o_filter2_coef43 <= 0;
      o_filter2_coef44 <= 0;
      o_csc_bypass     <= 0;
      o_filter1_bypass <= 0;
      o_filter2_bypass <= 0;
      o_icsc_bypass    <= 0;
    end
    else if(i_PSEL & i_PWRITE & i_PENABLE) begin
      case(i_PADDR)
        CSC_COEF0      : {o_csc_coef02, o_csc_coef01, o_csc_coef00}             <= i_PWDATA;
        CSC_COEF1      : {o_csc_coef12, o_csc_coef11, o_csc_coef10}             <= i_PWDATA;
        CSC_COEF2      : {o_csc_coef22, o_csc_coef21, o_csc_coef20}             <= i_PWDATA;
        CSC_BIAS       : {o_csc_bias2 , o_csc_bias1 , o_csc_bias0 }             <= i_PWDATA;
        ICSC_COEF0     : {o_icsc_coef02, o_icsc_coef01, o_icsc_coef00}          <= i_PWDATA;
        ICSC_COEF1     : {o_icsc_coef12, o_icsc_coef11, o_icsc_coef10}          <= i_PWDATA;
        ICSC_COEF2     : {o_icsc_coef22, o_icsc_coef21, o_icsc_coef20}          <= i_PWDATA;
        ICSC_BIAS      : {o_icsc_bias2 , o_icsc_bias1 , o_icsc_bias0 }          <= i_PWDATA;
        FILTER1_COEF00 : {o_filter1_coef02, o_filter1_coef01, o_filter1_coef00} <= i_PWDATA;
        FILTER1_COEF03 : {o_filter1_coef04, o_filter1_coef03}                   <= i_PWDATA;
        FILTER1_COEF10 : {o_filter1_coef12, o_filter1_coef11, o_filter1_coef10} <= i_PWDATA;
        FILTER1_COEF13 : {o_filter1_coef14, o_filter1_coef13}                   <= i_PWDATA;
        FILTER1_COEF20 : {o_filter1_coef22, o_filter1_coef21, o_filter1_coef20} <= i_PWDATA;
        FILTER1_COEF23 : {o_filter1_coef24, o_filter1_coef23}                   <= i_PWDATA;
        FILTER1_COEF30 : {o_filter1_coef32, o_filter1_coef31, o_filter1_coef30} <= i_PWDATA;
        FILTER1_COEF33 : {o_filter1_coef34, o_filter1_coef33}                   <= i_PWDATA;
        FILTER1_COEF40 : {o_filter1_coef42, o_filter1_coef41, o_filter1_coef40} <= i_PWDATA;
        FILTER1_COEF43 : {o_filter1_coef44, o_filter1_coef43}                   <= i_PWDATA;
        FILTER2_COEF00 : {o_filter2_coef02, o_filter2_coef01, o_filter2_coef00} <= i_PWDATA;
        FILTER2_COEF03 : {o_filter2_coef04, o_filter2_coef03}                   <= i_PWDATA;
        FILTER2_COEF10 : {o_filter2_coef12, o_filter2_coef11, o_filter2_coef10} <= i_PWDATA;
        FILTER2_COEF13 : {o_filter2_coef14, o_filter2_coef13}                   <= i_PWDATA;
        FILTER2_COEF20 : {o_filter2_coef22, o_filter2_coef21, o_filter2_coef20} <= i_PWDATA;
        FILTER2_COEF23 : {o_filter2_coef24, o_filter2_coef23}                   <= i_PWDATA;
        FILTER2_COEF30 : {o_filter2_coef32, o_filter2_coef31, o_filter2_coef30} <= i_PWDATA;
        FILTER2_COEF33 : {o_filter2_coef34, o_filter2_coef33}                   <= i_PWDATA;
        FILTER2_COEF40 : {o_filter2_coef42, o_filter2_coef41, o_filter2_coef40} <= i_PWDATA;
        FILTER2_COEF43 : {o_filter2_coef44, o_filter2_coef43}                   <= i_PWDATA;
        BYPASS         : { o_icsc_bypass, o_filter2_bypass, o_filter1_bypass, o_csc_bypass} <= i_PWDATA;
      endcase
    end
  end

endmodule
