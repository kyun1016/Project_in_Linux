// ./list_rtl.f

module mat_mul_3x3 
#(
  parameter DATA_WIDTH  = 8,
  parameter COEF_WIDTH  = 10,
  parameter BIAS_WIDTH  = 8
)
(
  input                         clk     ,
  input                         rstn    ,

  input                         i_bypass,
  input signed [COEF_WIDTH-1:0] i_coef00,
  input signed [COEF_WIDTH-1:0] i_coef01,
  input signed [COEF_WIDTH-1:0] i_coef02,
  input signed [COEF_WIDTH-1:0] i_coef10,
  input signed [COEF_WIDTH-1:0] i_coef11,
  input signed [COEF_WIDTH-1:0] i_coef12,
  input signed [COEF_WIDTH-1:0] i_coef20,
  input signed [COEF_WIDTH-1:0] i_coef21,
  input signed [COEF_WIDTH-1:0] i_coef22,
  input signed [BIAS_WIDTH-1:0] i_bias0 ,
  input signed [BIAS_WIDTH-1:0] i_bias1 ,
  input signed [BIAS_WIDTH-1:0] i_bias2 ,
  input                         i_vs    ,
  input                         i_hs    ,
  input                         i_de    ,
  input        [DATA_WIDTH-1:0] i_x0    ,
  input        [DATA_WIDTH-1:0] i_x1    ,
  input        [DATA_WIDTH-1:0] i_x2    ,
  output reg                    o_vs    ,
  output reg                    o_hs    ,
  output reg                    o_de    ,
  output reg   [DATA_WIDTH-1:0] o_y0    ,
  output reg   [DATA_WIDTH-1:0] o_y1    ,
  output reg   [DATA_WIDTH-1:0] o_y2    
);
  wire signed [DATA_WIDTH:0] w_x0 = {1'b0, i_x0};
  wire signed [DATA_WIDTH:0] w_x1 = {1'b0, i_x1};
  wire signed [DATA_WIDTH:0] w_x2 = {1'b0, i_x2};
  wire signed [DATA_WIDTH+COEF_WIDTH:0] w_mul0 = i_coef00 * w_x0 + i_coef01 * w_x1 + i_coef02 * w_x2 + i_bias0;
  wire signed [DATA_WIDTH+COEF_WIDTH:0] w_mul1 = i_coef10 * w_x0 + i_coef11 * w_x1 + i_coef12 * w_x2 + i_bias1;
  wire signed [DATA_WIDTH+COEF_WIDTH:0] w_mul2 = i_coef20 * w_x0 + i_coef21 * w_x1 + i_coef22 * w_x2 + i_bias2;

  always @(posedge clk, negedge rstn) begin
    if(!rstn) begin
      o_y0 <= 0;
      o_y1 <= 0;
      o_y2 <= 0;
    end
    else if(i_de) begin
      o_y0 <= w_mul0[COEF_WIDTH+:DATA_WIDTH];
      o_y1 <= w_mul1[COEF_WIDTH+:DATA_WIDTH];
      o_y2 <= w_mul2[COEF_WIDTH+:DATA_WIDTH];
    end
  end

  always @(posedge clk, negedge rstn) begin
    if(!rstn) begin
      o_vs <= 1'b0;
      o_hs <= 1'b0;
      o_de <= 1'b0;
    end
    else begin
      o_vs <= i_vs;
      o_hs <= i_hs;
      o_de <= i_de;
    end
  end

endmodule
