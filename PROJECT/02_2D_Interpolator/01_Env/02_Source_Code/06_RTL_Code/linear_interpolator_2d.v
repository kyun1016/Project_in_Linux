// ./list_rtl.f

module linear_interpolator_2d 
#(
  parameter X_WIDTH      = 8 ,
  parameter WEIGHT_WIDTH = 10
)
(
  input                         clk      ,
  input                         rstn     ,

  input                         i_en     ,
  input      [X_WIDTH-1:0]      i_x      ,
  input      [WEIGHT_WIDTH-1:0] i_weight0,
  input      [WEIGHT_WIDTH-1:0] i_weight1,
  input      [WEIGHT_WIDTH-1:0] i_weight2,
  input      [WEIGHT_WIDTH-1:0] i_weight3,
  input      [WEIGHT_WIDTH-1:0] i_weight4,
  input      [WEIGHT_WIDTH-1:0] i_weight5,
  input      [WEIGHT_WIDTH-1:0] i_weight6,
  input      [WEIGHT_WIDTH-1:0] i_weight7,

  output reg [WEIGHT_WIDTH-1:0] o_y      
);
  //===================================================
  // Part 1. calc w
  //===================================================
  localparam
    SEL_WIDTH = 3,
    MSB_0 = 3'b000,
    MSB_1 = 3'b001,
    MSB_2 = 3'b010,
    MSB_3 = 3'b011,
    MSB_4 = 3'b100,
    MSB_5 = 3'b101,
    MSB_6 = 3'b110,
    MSB_7 = 3'b111;

  reg [SEL_WIDTH-1:0] w_sel; // one hot encoding
  always @(*) begin
    if(i_x[7])      w_sel = MSB_0;
    else if(i_x[6]) w_sel = MSB_1;
    else if(i_x[5]) w_sel = MSB_2;
    else if(i_x[4]) w_sel = MSB_3;
    else if(i_x[3]) w_sel = MSB_4;
    else if(i_x[2]) w_sel = MSB_5;
    else if(i_x[1]) w_sel = MSB_6;
    else            w_sel = MSB_7;
  end

  reg [9:0] w_weight1; // Q[10.0]
  always @(*) begin
    case(w_sel)
      MSB_0   : w_weight1 = i_weight0;
      MSB_1   : w_weight1 = i_weight1;
      MSB_2   : w_weight1 = i_weight2;
      MSB_3   : w_weight1 = i_weight3;
      MSB_4   : w_weight1 = i_weight4;
      MSB_5   : w_weight1 = i_weight5;
      default : w_weight1 = i_weight6;
    endcase
  end
  reg [9:0] w_weight2; // Q[10.0]
  always @(*) begin
    case(w_sel)
      MSB_0   : w_weight2 = i_weight1;
      MSB_1   : w_weight2 = i_weight2;
      MSB_2   : w_weight2 = i_weight3;
      MSB_3   : w_weight2 = i_weight4;
      MSB_4   : w_weight2 = i_weight5;
      MSB_5   : w_weight2 = i_weight6;
      default : w_weight2 = i_weight7;
    endcase
  end

  reg [6:0] w_alpha1;  // Q[0.7]
  always @(*) begin
    case(w_sel)
      MSB_0   : w_alpha1 =  i_x[6:0]       ; // Q[0.7]
      MSB_1   : w_alpha1 = {i_x[5:0], 1'b0}; // Q[0.6]
      MSB_2   : w_alpha1 = {i_x[4:0], 2'b0}; // Q[0.5]
      MSB_3   : w_alpha1 = {i_x[3:0], 3'b0}; // Q[0.4]
      MSB_4   : w_alpha1 = {i_x[2:0], 4'b0}; // Q[0.3]
      MSB_5   : w_alpha1 = {i_x[1:0], 5'b0}; // Q[0.2]
      default : w_alpha1 = {i_x[0]  , 6'b0}; // Q[0.1]
    endcase
  end

  wire [6:0] w_alpha2 = ~w_alpha1 + 1;

  wire [16:0] w_mul1 = w_alpha1 * w_weight1;
  wire [16:0] w_mul2 = w_alpha2 * w_weight2;

  wire [17:0] w_result = w_mul1 + w_mul2;

  always @ (posedge clk, negedge rstn) begin
    if(!rstn)
      o_y <= 0;
    else if(i_en) begin
      if(w_sel == MSB_7)
        o_y <= 0;
      else
        o_y <= w_result[9:0];
    end
  end

endmodule
