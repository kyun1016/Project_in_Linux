// ./list_rtl.f

module filter_data_align_5x5
#(
  parameter INPUT_DATA_WIDTH  = 8,
  parameter OUTPUT_DATA_WIDTH = 8,
  parameter CSC_WIDTH         = 8,
  parameter BIAS_WIDTH        = 8
)
(
  input                                     clk           ,
  input                                     rstn          ,

  input                                     i_en          ,
  input      signed [INPUT_DATA_WIDTH-1:0]  i_x           ,
  input             [1:0]                   i_sel_ln      ,
  input             [1:0]                   i_sel_px      ,
  input             [2:0]                   i_case_sel_ln ,
  input             [2:0]                   i_case_sel_px ,
  input             [10:0]                  i_addr_ln     ,
  input             [10:0]                  i_addr_px     ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y00         ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y01         ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y02         ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y03         ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y04         ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y10         ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y11         ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y12         ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y13         ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y14         ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y20         ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y21         ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y22         ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y23         ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y24         ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y30         ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y31         ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y32         ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y33         ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y34         ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y40         ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y41         ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y42         ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y43         ,
  output reg signed [OUTPUT_DATA_WIDTH-1:0] o_y44         
);
  //============================================================
  // Part 1. Select Memory
  //============================================================
  wire [7:0] w_x0 = i_sel_ln == 2'b00 ? i_x : 0;
  wire [7:0] w_x1 = i_sel_ln == 2'b01 ? i_x : 0;
  wire [7:0] w_x2 = i_sel_ln == 2'b10 ? i_x : 0;
  wire [7:0] w_x3 = i_sel_ln == 2'b11 ? i_x : 0;

  wire [7:0] w_data_ln_pre0;
  wire [7:0] w_data_ln_pre1;
  wire [7:0] w_data_ln_pre2;
  wire [7:0] w_data_ln_pre3;
  memory_1920x8 u_mem0(
    .clk    (clk           ),
    .rstn   (rstn          ),
    .i_en   (i_en          ),
    .i_addr (i_addr_ln     ),
    .i_data (w_x0          ),
    .o_data (w_data_ln_pre0)
  );
  memory_1920x8 u_mem1(
    .clk    (clk           ),
    .rstn   (rstn          ),
    .i_en   (i_en          ),
    .i_addr (i_addr_ln     ),
    .i_data (w_x1          ),
    .o_data (w_data_ln_pre1)
  );
  memory_1920x8 u_mem2(
    .clk    (clk           ),
    .rstn   (rstn          ),
    .i_en   (i_en          ),
    .i_addr (i_addr_ln     ),
    .i_data (w_x2          ),
    .o_data (w_data_ln_pre2)
  );
  memory_1920x8 u_mem3(
    .clk    (clk           ),
    .rstn   (rstn          ),
    .i_en   (i_en          ),
    .i_addr (i_addr_ln     ),
    .i_data (w_x3          ),
    .o_data (w_data_ln_pre3)
  );

  //=============================================================
  // Re-Align
  //=============================================================
  reg [7:0] w_data_ln0;
  reg [7:0] w_data_ln1;
  reg [7:0] w_data_ln2;
  reg [7:0] w_data_ln3;
  reg [7:0] w_data_ln4;
  always @(*) begin
    case(i_case_sel_ln)
      3'b000 : w_data_ln0 = w_data_ln_pre0;
      3'b001 : w_data_ln0 = w_data_ln_pre1;
      3'b010 : w_data_ln0 = w_data_ln_pre2;
      3'b011 : w_data_ln0 = w_data_ln_pre3;
      default: w_data_ln0 = i_x;
    endcase
  end
  always @(*) begin
    case(i_case_sel_ln)
      3'b000 : w_data_ln1 = w_data_ln_pre1;
      3'b001 : w_data_ln1 = w_data_ln_pre2;
      3'b010 : w_data_ln1 = w_data_ln_pre3;
      3'b011 : w_data_ln1 = i_x;
      default: w_data_ln1 = w_data_ln_pre0;
    endcase
  end
  always @(*) begin
    case(i_case_sel_ln)
      3'b000 : w_data_ln2 = w_data_ln_pre2;
      3'b001 : w_data_ln2 = w_data_ln_pre3;
      3'b010 : w_data_ln2 = i_x; 
      3'b011 : w_data_ln2 = w_data_ln_pre0;
      default: w_data_ln2 = w_data_ln_pre1;
    endcase
  end
  always @(*) begin
    case(i_case_sel_ln)
      3'b000 : w_data_ln3 = w_data_ln_pre3;
      3'b001 : w_data_ln3 = i_x;
      3'b010 : w_data_ln3 = w_data_ln_pre0;
      3'b011 : w_data_ln3 = w_data_ln_pre1;
      default: w_data_ln3 = w_data_ln_pre2;
    endcase
  end
  always @(*) begin
    case(i_case_sel_ln)
      3'b000 : w_data_ln4 = i_x;
      3'b001 : w_data_ln4 = w_data_ln_pre0;
      3'b010 : w_data_ln4 = w_data_ln_pre1;
      3'b011 : w_data_ln4 = w_data_ln_pre2;
      default: w_data_ln4 = w_data_ln_pre3;
    endcase
  end

  //============================================================
  // Part 2. Data Shift or Select (TODO : must compare Synthesis Result)
  //============================================================

  reg [7:0] r_data_px_pre00;
  reg [7:0] r_data_px_pre01;
  reg [7:0] r_data_px_pre02;
  reg [7:0] r_data_px_pre03;
  reg [7:0] r_data_px_pre10;
  reg [7:0] r_data_px_pre11;
  reg [7:0] r_data_px_pre12;
  reg [7:0] r_data_px_pre13;
  reg [7:0] r_data_px_pre20;
  reg [7:0] r_data_px_pre21;
  reg [7:0] r_data_px_pre22;
  reg [7:0] r_data_px_pre23;
  reg [7:0] r_data_px_pre30;
  reg [7:0] r_data_px_pre31;
  reg [7:0] r_data_px_pre32;
  reg [7:0] r_data_px_pre33;
  reg [7:0] r_data_px_pre40;
  reg [7:0] r_data_px_pre41;
  reg [7:0] r_data_px_pre42;
  reg [7:0] r_data_px_pre43;

  always @(posedge clk, negedge rstn) begin
    if(!rstn) begin
      r_data_px_pre00 <= 0;
      r_data_px_pre10 <= 0;
      r_data_px_pre20 <= 0;
      r_data_px_pre30 <= 0;
      r_data_px_pre40 <= 0;
    end
    else if(i_en & (i_sel_px == 2'b00)) begin
      r_data_px_pre00 <= w_data_ln0;
      r_data_px_pre10 <= w_data_ln1;
      r_data_px_pre20 <= w_data_ln2;
      r_data_px_pre30 <= w_data_ln3;
      r_data_px_pre40 <= w_data_ln4;
    end
  end
  always @(posedge clk, negedge rstn) begin
    if(!rstn) begin
      r_data_px_pre01 <= 0;
      r_data_px_pre11 <= 0;
      r_data_px_pre21 <= 0;
      r_data_px_pre31 <= 0;
      r_data_px_pre41 <= 0;
    end
    else if(i_en & (i_sel_px == 2'b01)) begin
      r_data_px_pre01 <= w_data_ln0;
      r_data_px_pre11 <= w_data_ln1;
      r_data_px_pre21 <= w_data_ln2;
      r_data_px_pre31 <= w_data_ln3;
      r_data_px_pre41 <= w_data_ln4;
    end
  end
  always @(posedge clk, negedge rstn) begin
    if(!rstn) begin
      r_data_px_pre02 <= 0;
      r_data_px_pre12 <= 0;
      r_data_px_pre22 <= 0;
      r_data_px_pre32 <= 0;
      r_data_px_pre42 <= 0;
    end
    else if(i_en & (i_sel_px == 2'b10)) begin
      r_data_px_pre02 <= w_data_ln0;
      r_data_px_pre12 <= w_data_ln1;
      r_data_px_pre22 <= w_data_ln2;
      r_data_px_pre32 <= w_data_ln3;
      r_data_px_pre42 <= w_data_ln4;
    end
  end
  always @(posedge clk, negedge rstn) begin
    if(!rstn) begin
      r_data_px_pre03 <= 0;
      r_data_px_pre13 <= 0;
      r_data_px_pre23 <= 0;
      r_data_px_pre33 <= 0;
      r_data_px_pre43 <= 0;
    end
    else if(i_en & (i_sel_px == 2'b11)) begin
      r_data_px_pre03 <= w_data_ln0;
      r_data_px_pre13 <= w_data_ln1;
      r_data_px_pre23 <= w_data_ln2;
      r_data_px_pre33 <= w_data_ln3;
      r_data_px_pre43 <= w_data_ln4;
    end
  end
  always @(*) begin
    case(i_case_sel_px)
      3'b000 : o_y00 = r_data_px_pre00;
      3'b001 : o_y00 = r_data_px_pre01;
      3'b010 : o_y00 = r_data_px_pre02;
      3'b011 : o_y00 = r_data_px_pre03;
      default: o_y00 = w_data_ln0;
    endcase
  end
  always @(*) begin
    case(i_case_sel_px)
      3'b000 : o_y01 = r_data_px_pre01;
      3'b001 : o_y01 = r_data_px_pre02;
      3'b010 : o_y01 = r_data_px_pre03;
      3'b011 : o_y01 = w_data_ln0  ;
      default: o_y01 = r_data_px_pre00;
    endcase
  end
  always @(*) begin
    case(i_case_sel_px)
      3'b000 : o_y02 = r_data_px_pre02;
      3'b001 : o_y02 = r_data_px_pre03;
      3'b010 : o_y02 = w_data_ln0  ;
      3'b011 : o_y02 = r_data_px_pre00;
      default: o_y02 = r_data_px_pre01;
    endcase
  end
  always @(*) begin
    case(i_case_sel_px)
      3'b000 : o_y03 = r_data_px_pre03;
      3'b001 : o_y03 = w_data_ln0  ;
      3'b010 : o_y03 = r_data_px_pre00;
      3'b011 : o_y03 = r_data_px_pre01;
      default: o_y03 = r_data_px_pre02;
    endcase
  end
  always @(*) begin
    case(i_case_sel_px)
      3'b000 : o_y04 = w_data_ln0  ;
      3'b001 : o_y04 = r_data_px_pre00;
      3'b010 : o_y04 = r_data_px_pre01;
      3'b011 : o_y04 = r_data_px_pre02;
      default: o_y04 = r_data_px_pre03;
    endcase
  end
  always @(*) begin
    case(i_case_sel_px)
      3'b000 : o_y10 = r_data_px_pre10;
      3'b001 : o_y10 = r_data_px_pre11;
      3'b010 : o_y10 = r_data_px_pre12;
      3'b011 : o_y10 = r_data_px_pre13;
      default: o_y10 = w_data_ln1;
    endcase
  end
  always @(*) begin
    case(i_case_sel_px)
      3'b000 : o_y11 = r_data_px_pre11;
      3'b001 : o_y11 = r_data_px_pre12;
      3'b010 : o_y11 = r_data_px_pre13;
      3'b011 : o_y11 = w_data_ln1  ;
      default: o_y11 = r_data_px_pre10;
    endcase
  end
  always @(*) begin
    case(i_case_sel_px)
      3'b000 : o_y12 = r_data_px_pre12;
      3'b001 : o_y12 = r_data_px_pre13;
      3'b010 : o_y12 = w_data_ln1  ;
      3'b011 : o_y12 = r_data_px_pre10;
      default: o_y12 = r_data_px_pre11;
    endcase
  end
  always @(*) begin
    case(i_case_sel_px)
      3'b000 : o_y13 = r_data_px_pre03;
      3'b001 : o_y13 = w_data_ln1  ;
      3'b010 : o_y13 = r_data_px_pre10;
      3'b011 : o_y13 = r_data_px_pre11;
      default: o_y13 = r_data_px_pre12;
    endcase
  end
  always @(*) begin
    case(i_case_sel_px)
      3'b000 : o_y14 = w_data_ln1  ;
      3'b001 : o_y14 = r_data_px_pre10;
      3'b010 : o_y14 = r_data_px_pre11;
      3'b011 : o_y14 = r_data_px_pre12;
      default: o_y14 = r_data_px_pre13;
    endcase
  end
  always @(*) begin
    case(i_case_sel_px)
      3'b000 : o_y20 = r_data_px_pre20;
      3'b001 : o_y20 = r_data_px_pre21;
      3'b010 : o_y20 = r_data_px_pre22;
      3'b011 : o_y20 = r_data_px_pre23;
      default: o_y20 = w_data_ln2;
    endcase
  end
  always @(*) begin
    case(i_case_sel_px)
      3'b000 : o_y21 = r_data_px_pre21;
      3'b001 : o_y21 = r_data_px_pre22;
      3'b010 : o_y21 = r_data_px_pre23;
      3'b011 : o_y21 = w_data_ln2  ;
      default: o_y21 = r_data_px_pre20;
    endcase
  end
  always @(*) begin
    case(i_case_sel_px)
      3'b000 : o_y22 = r_data_px_pre22;
      3'b001 : o_y22 = r_data_px_pre23;
      3'b010 : o_y22 = w_data_ln2  ;
      3'b011 : o_y22 = r_data_px_pre20;
      default: o_y22 = r_data_px_pre21;
    endcase
  end
  always @(*) begin
    case(i_case_sel_px)
      3'b000 : o_y23 = r_data_px_pre23;
      3'b001 : o_y23 = w_data_ln2  ;
      3'b010 : o_y23 = r_data_px_pre20;
      3'b011 : o_y23 = r_data_px_pre21;
      default: o_y23 = r_data_px_pre22;
    endcase
  end
  always @(*) begin
    case(i_case_sel_px)
      3'b000 : o_y24 = w_data_ln2  ;
      3'b001 : o_y24 = r_data_px_pre20;
      3'b010 : o_y24 = r_data_px_pre21;
      3'b011 : o_y24 = r_data_px_pre22;
      default: o_y24 = r_data_px_pre23;
    endcase
  end
  always @(*) begin
    case(i_case_sel_px)
      3'b000 : o_y30 = r_data_px_pre00;
      3'b001 : o_y30 = r_data_px_pre01;
      3'b010 : o_y30 = r_data_px_pre02;
      3'b011 : o_y30 = r_data_px_pre03;
      default: o_y30 = w_data_ln3;
    endcase
  end
  always @(*) begin
    case(i_case_sel_px)
      3'b000 : o_y31 = r_data_px_pre31;
      3'b001 : o_y31 = r_data_px_pre32;
      3'b010 : o_y31 = r_data_px_pre33;
      3'b011 : o_y31 = w_data_ln3  ;
      default: o_y31 = r_data_px_pre30;
    endcase
  end
  always @(*) begin
    case(i_case_sel_px)
      3'b000 : o_y32 = r_data_px_pre32;
      3'b001 : o_y32 = r_data_px_pre33;
      3'b010 : o_y32 = w_data_ln3  ;
      3'b011 : o_y32 = r_data_px_pre30;
      default: o_y32 = r_data_px_pre31;
    endcase
  end
  always @(*) begin
    case(i_case_sel_px)
      3'b000 : o_y33 = r_data_px_pre33;
      3'b001 : o_y33 = w_data_ln3  ;
      3'b010 : o_y33 = r_data_px_pre30;
      3'b011 : o_y33 = r_data_px_pre31;
      default: o_y33 = r_data_px_pre32;
    endcase
  end
  always @(*) begin
    case(i_case_sel_px)
      3'b000 : o_y34 = w_data_ln3  ;
      3'b001 : o_y34 = r_data_px_pre30;
      3'b010 : o_y34 = r_data_px_pre31;
      3'b011 : o_y34 = r_data_px_pre32;
      default: o_y34 = r_data_px_pre33;
    endcase
  end
  always @(*) begin
    case(i_case_sel_px)
      3'b000 : o_y40 = r_data_px_pre40;
      3'b001 : o_y40 = r_data_px_pre41;
      3'b010 : o_y40 = r_data_px_pre42;
      3'b011 : o_y40 = r_data_px_pre43;
      default: o_y40 = w_data_ln4;
    endcase
  end
  always @(*) begin
    case(i_case_sel_px)
      3'b000 : o_y41 = r_data_px_pre41;
      3'b001 : o_y41 = r_data_px_pre42;
      3'b010 : o_y41 = r_data_px_pre43;
      3'b011 : o_y41 = w_data_ln4  ;
      default: o_y41 = r_data_px_pre40;
    endcase
  end
  always @(*) begin
    case(i_case_sel_px)
      3'b000 : o_y42 = r_data_px_pre42;
      3'b001 : o_y42 = r_data_px_pre43;
      3'b010 : o_y42 = w_data_ln4  ;
      3'b011 : o_y42 = r_data_px_pre40;
      default: o_y42 = r_data_px_pre41;
    endcase
  end
  always @(*) begin
    case(i_case_sel_px)
      3'b000 : o_y43 = r_data_px_pre43;
      3'b001 : o_y43 = w_data_ln4  ;
      3'b010 : o_y43 = r_data_px_pre40;
      3'b011 : o_y43 = r_data_px_pre41;
      default: o_y43 = r_data_px_pre42;
    endcase
  end
  always @(*) begin
    case(i_case_sel_px)
      3'b000 : o_y44 = w_data_ln4  ;
      3'b001 : o_y44 = r_data_px_pre40;
      3'b010 : o_y44 = r_data_px_pre41;
      3'b011 : o_y44 = r_data_px_pre42;
      default: o_y44 = r_data_px_pre43;
    endcase
  end
endmodule
