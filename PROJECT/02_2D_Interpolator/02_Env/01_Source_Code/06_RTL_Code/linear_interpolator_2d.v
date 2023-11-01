// ./list_rtl.f

module linear_interpolator_2d 
#(
  parameter BW_X      = 8 ,
  parameter BW_WEIGHT = 10
)
(
  input                      clk      ,
  input                      rst_n    ,

  input                      i_en     ,
  input      [BW_X-1:0]      i_x      ,
  input      [BW_WEIGHT-1:0] i_weight0,
  input      [BW_WEIGHT-1:0] i_weight1,
  input      [BW_WEIGHT-1:0] i_weight2,
  input      [BW_WEIGHT-1:0] i_weight3,
  input      [BW_WEIGHT-1:0] i_weight4,
  input      [BW_WEIGHT-1:0] i_weight5,
  input      [BW_WEIGHT-1:0] i_weight6,
  input      [BW_WEIGHT-1:0] i_weight7,

  output reg [BW_WEIGHT-1:0] o_y
);
  //===================================================
  // Part 1. calc weight
  //===================================================
  reg [7:0] w_msb; // one hot encoding
  always @(*) begin
    w_msb = 0;
    if(i_en) begin
      if(i_x[7])      w_msb[7] = 1;
      else if(i_x[6]) w_msb[6] = 1;
      else if(i_x[5]) w_msb[5] = 1;
      else if(i_x[4]) w_msb[4] = 1;
      else if(i_x[3]) w_msb[3] = 1;
      else if(i_x[2]) w_msb[2] = 1;
      else if(i_x[1]) w_msb[1] = 1;
      else if(i_x[0]) w_msb[0] = 1;
    end
  end

  reg [9:0] w_weight1; // Q[10.0]
  reg [9:0] w_weight2; // Q[10.0]
  always @(*) begin
    case(1'b1)
      w_msb[7] : begin
        w_weight1 = i_weight0;
        w_weight2 = i_weight1;
      end
      w_msb[6] : begin
        w_weight1 = i_weight1;
        w_weight2 = i_weight2;
      end
      w_msb[5] : begin
        w_weight1 = i_weight2;
        w_weight2 = i_weight3;
      end
      w_msb[4] : begin
        w_weight1 = i_weight3;
        w_weight2 = i_weight4;
      end
      w_msb[3] : begin
        w_weight1 = i_weight4;
        w_weight2 = i_weight5;
      end
      w_msb[2] : begin
        w_weight1 = i_weight5;
        w_weight2 = i_weight6;
      end
      default : begin
        w_weight1 = i_weight6;
        w_weight2 = i_weight7;
      end
    endcase
  end

  reg [6:0] w_temp1;  // Q[0.7] Q[0.6] ... Q[0.1]
  always @(*) begin
    w_temp1 = i_x[6:0];
    case(1'b1)
      w_msb[6] : w_temp1[6] = 1'b0; // Q[0.6]
      w_msb[5] : w_temp1[5] = 1'b0; // Q[0.5]
      w_msb[4] : w_temp1[4] = 1'b0; // Q[0.4]
      w_msb[3] : w_temp1[3] = 1'b0; // Q[0.3]
      w_msb[2] : w_temp1[2] = 1'b0; // Q[0.2]
      w_msb[1] : w_temp1[1] = 1'b0; // Q[0.1]
    endcase
  end

  wire [5:0] w_temp1_n = ~w_temp1[5:0];


  reg [6:0] w_temp2_pre;
  always @(*) begin
    w_temp2_pre = 0;
    case(1'b1)
      w_msb[6] : w_temp2_pre = {1'b0, w_temp1_n[5:0]}; // Q[0.6]
      w_msb[5] : w_temp2_pre = {2'b0, w_temp1_n[4:0]}; // Q[0.5]
      w_msb[4] : w_temp2_pre = {3'b0, w_temp1_n[3:0]}; // Q[0.4]
      w_msb[3] : w_temp2_pre = {4'b0, w_temp1_n[2:0]}; // Q[0.3]
      w_msb[2] : w_temp2_pre = {5'b0, w_temp1_n[1:0]}; // Q[0.2]
      w_msb[1] : w_temp2_pre = {6'b0, w_temp1_n[  0]}; // Q[0.1]
    endcase
  end

  wire [6:0] w_temp2 = w_temp2_pre + 1;

  wire [16:0] w_mul_1 = w_temp1 * w_weight1;
  wire [16:0] w_mul_2 = w_temp2 * w_weight2;

  wire [17:0] w_result = w_mul_1 + w_mul_2;

  always @ (posedge clk, negedge rst_n) begin
    if(!rst_n)
      o_y <= 0;
    else
      o_y <= w_result[9:0];
  end

endmodule
