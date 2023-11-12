// ./list_rtl.f

module filter_data_align_5x5
#(
  parameter DATA_WIDTH = 8
)
(
  input                       clk           ,
  input                       rstn          ,
  input      [DATA_WIDTH-1:0] i_y           ,
  input      [DATA_WIDTH-1:0] i_u           ,
  input      [DATA_WIDTH-1:0] i_v           ,
  input      [11:0]           i_mem_addr    ,
  input      [3:0]            i_mem_wen     ,
  input                       i_mem_ren     ,
  input      [3:0]            i_conv_wen    ,
  input                       i_conv_ren    ,
  input      [2:0]            i_conv_ln_sel ,
  input      [2:0]            i_conv_px_sel ,
  output reg [DATA_WIDTH-1:0] o_y00         ,
  output reg [DATA_WIDTH-1:0] o_y01         ,
  output reg [DATA_WIDTH-1:0] o_y02         ,
  output reg [DATA_WIDTH-1:0] o_y03         ,
  output reg [DATA_WIDTH-1:0] o_y04         ,
  output reg [DATA_WIDTH-1:0] o_y10         ,
  output reg [DATA_WIDTH-1:0] o_y11         ,
  output reg [DATA_WIDTH-1:0] o_y12         ,
  output reg [DATA_WIDTH-1:0] o_y13         ,
  output reg [DATA_WIDTH-1:0] o_y14         ,
  output reg [DATA_WIDTH-1:0] o_y20         ,
  output reg [DATA_WIDTH-1:0] o_y21         ,
  output reg [DATA_WIDTH-1:0] o_y22         ,
  output reg [DATA_WIDTH-1:0] o_y23         ,
  output reg [DATA_WIDTH-1:0] o_y24         ,
  output reg [DATA_WIDTH-1:0] o_y30         ,
  output reg [DATA_WIDTH-1:0] o_y31         ,
  output reg [DATA_WIDTH-1:0] o_y32         ,
  output reg [DATA_WIDTH-1:0] o_y33         ,
  output reg [DATA_WIDTH-1:0] o_y34         ,
  output reg [DATA_WIDTH-1:0] o_y40         ,
  output reg [DATA_WIDTH-1:0] o_y41         ,
  output reg [DATA_WIDTH-1:0] o_y42         ,
  output reg [DATA_WIDTH-1:0] o_y43         ,
  output reg [DATA_WIDTH-1:0] o_y44         ,
  output     [DATA_WIDTH-1:0] o_u           ,
  output     [DATA_WIDTH-1:0] o_v           
);
  //============================================================
  // Part 1. Select Memory
  //============================================================
  wire [7:0] w_y_ln_pre0;
  wire [7:0] w_y_ln_pre1;
  wire [7:0] w_y_ln_pre2;
  wire [7:0] w_y_ln_pre3;
  simple_dual_one_clock u_mem_y0(
    .clk     (clk           ),
    .i_a_en  (i_mem_wen[0]  ),
    .i_b_en  (i_mem_ren     ),
    .i_a_we  (i_mem_wen[0]  ),
    .i_a_addr(i_mem_addr    ),
    .i_b_addr(i_mem_addr    ),
    .i_a_data(i_y           ),
    .o_b_data(w_y_ln_pre0)
  );
  simple_dual_one_clock u_mem_y1(
    .clk     (clk           ),
    .i_a_en  (i_mem_wen[1]  ),
    .i_b_en  (i_mem_ren     ),
    .i_a_we  (i_mem_wen[1]  ),
    .i_a_addr(i_mem_addr    ),
    .i_b_addr(i_mem_addr    ),
    .i_a_data(i_y           ),
    .o_b_data(w_y_ln_pre1)
  );
  simple_dual_one_clock u_mem_y2(
    .clk     (clk           ),
    .i_a_en  (i_mem_wen[2]  ),
    .i_b_en  (i_mem_ren     ),
    .i_a_we  (i_mem_wen[2]  ),
    .i_a_addr(i_mem_addr    ),
    .i_b_addr(i_mem_addr    ),
    .i_a_data(i_y           ),
    .o_b_data(w_y_ln_pre2)
  );
  simple_dual_one_clock u_mem_y3(
    .clk     (clk           ),
    .i_a_en  (i_mem_wen[3]  ),
    .i_b_en  (i_mem_ren     ),
    .i_a_we  (i_mem_wen[3]  ),
    .i_a_addr(i_mem_addr    ),
    .i_b_addr(i_mem_addr    ),
    .i_a_data(i_y           ),
    .o_b_data(w_y_ln_pre3)
  );

  wire [7:0] w_u_ln_pre0;
  wire [7:0] w_u_ln_pre1;
  simple_dual_one_clock u_mem_u0(
    .clk     (clk                      ),
    .i_a_en  (i_mem_wen[0]|i_mem_wen[2]),
    .i_b_en  (i_mem_ren                ),
    .i_a_we  (i_mem_wen[0]|i_mem_wen[2]),
    .i_a_addr(i_mem_addr               ),
    .i_b_addr(i_mem_addr               ),
    .i_a_data(i_u                      ),
    .o_b_data(w_u_ln_pre0              )
  );
  simple_dual_one_clock u_mem_u1(
    .clk     (clk                      ),
    .i_a_en  (i_mem_wen[1]|i_mem_wen[3]),
    .i_b_en  (i_mem_ren                ),
    .i_a_we  (i_mem_wen[1]|i_mem_wen[3]),
    .i_a_addr(i_mem_addr               ),
    .i_b_addr(i_mem_addr               ),
    .i_a_data(i_u                      ),
    .o_b_data(w_u_ln_pre1              )
  );
  wire [7:0] w_v_ln_pre0;
  wire [7:0] w_v_ln_pre1;
  simple_dual_one_clock u_mem_v0(
    .clk     (clk                      ),
    .i_a_en  (i_mem_wen[0]|i_mem_wen[2]),
    .i_b_en  (i_mem_ren                ),
    .i_a_we  (i_mem_wen[0]|i_mem_wen[2]),
    .i_a_addr(i_mem_addr               ),
    .i_b_addr(i_mem_addr               ),
    .i_a_data(i_v                      ),
    .o_b_data(w_v_ln_pre0              )
  );
  simple_dual_one_clock u_mem_v1(
    .clk     (clk                      ),
    .i_a_en  (i_mem_wen[1]|i_mem_wen[3]),
    .i_b_en  (i_mem_ren                ),
    .i_a_we  (i_mem_wen[1]|i_mem_wen[3]),
    .i_a_addr(i_mem_addr               ),
    .i_b_addr(i_mem_addr               ),
    .i_a_data(i_v                      ),
    .o_b_data(w_v_ln_pre1              )
  );
  //=============================================================
  // Re-Align
  //=============================================================
  reg [7:0] w_y_ln0;
  reg [7:0] w_y_ln1;
  reg [7:0] w_y_ln2;
  reg [7:0] w_y_ln3;
  reg [7:0] w_y_ln4;
  always @(*) begin
    case(i_conv_ln_sel)
      3'b000 : w_y_ln0 = w_y_ln_pre0;
      3'b001 : w_y_ln0 = w_y_ln_pre1;
      3'b010 : w_y_ln0 = w_y_ln_pre2;
      3'b011 : w_y_ln0 = w_y_ln_pre3;
      default: w_y_ln0 = i_y;
    endcase
  end
  always @(*) begin
    case(i_conv_ln_sel)
      3'b000 : w_y_ln1 = w_y_ln_pre1;
      3'b001 : w_y_ln1 = w_y_ln_pre2;
      3'b010 : w_y_ln1 = w_y_ln_pre3;
      3'b011 : w_y_ln1 = i_y;
      default: w_y_ln1 = w_y_ln_pre0;
    endcase
  end
  always @(*) begin
    case(i_conv_ln_sel)
      3'b000 : w_y_ln2 = w_y_ln_pre2;
      3'b001 : w_y_ln2 = w_y_ln_pre3;
      3'b010 : w_y_ln2 = i_y; 
      3'b011 : w_y_ln2 = w_y_ln_pre0;
      default: w_y_ln2 = w_y_ln_pre1;
    endcase
  end
  always @(*) begin
    case(i_conv_ln_sel)
      3'b000 : w_y_ln3 = w_y_ln_pre3;
      3'b001 : w_y_ln3 = i_y;
      3'b010 : w_y_ln3 = w_y_ln_pre0;
      3'b011 : w_y_ln3 = w_y_ln_pre1;
      default: w_y_ln3 = w_y_ln_pre2;
    endcase
  end
  always @(*) begin
    case(i_conv_ln_sel)
      3'b000 : w_y_ln4 = i_y;
      3'b001 : w_y_ln4 = w_y_ln_pre0;
      3'b010 : w_y_ln4 = w_y_ln_pre1;
      3'b011 : w_y_ln4 = w_y_ln_pre2;
      default: w_y_ln4 = w_y_ln_pre3;
    endcase
  end

  //============================================================
  // Part 2. Data Shift or Select (TODO : must compare Synthesis Result)
  //============================================================

  reg [7:0] r_y_px_pre00;
  reg [7:0] r_y_px_pre01;
  reg [7:0] r_y_px_pre02;
  reg [7:0] r_y_px_pre03;
  reg [7:0] r_y_px_pre10;
  reg [7:0] r_y_px_pre11;
  reg [7:0] r_y_px_pre12;
  reg [7:0] r_y_px_pre13;
  reg [7:0] r_y_px_pre20;
  reg [7:0] r_y_px_pre21;
  reg [7:0] r_y_px_pre22;
  reg [7:0] r_y_px_pre23;
  reg [7:0] r_y_px_pre30;
  reg [7:0] r_y_px_pre31;
  reg [7:0] r_y_px_pre32;
  reg [7:0] r_y_px_pre33;
  reg [7:0] r_y_px_pre40;
  reg [7:0] r_y_px_pre41;
  reg [7:0] r_y_px_pre42;
  reg [7:0] r_y_px_pre43;

  always @(posedge clk, negedge rstn) begin
    if(!rstn) begin
      r_y_px_pre00 <= 0;
      r_y_px_pre10 <= 0;
      r_y_px_pre20 <= 0;
      r_y_px_pre30 <= 0;
      r_y_px_pre40 <= 0;
    end
    else if(i_conv_wen[0]) begin
      r_y_px_pre00 <= w_y_ln0;
      r_y_px_pre10 <= w_y_ln1;
      r_y_px_pre20 <= w_y_ln2;
      r_y_px_pre30 <= w_y_ln3;
      r_y_px_pre40 <= w_y_ln4;
    end
  end
  always @(posedge clk, negedge rstn) begin
    if(!rstn) begin
      r_y_px_pre01 <= 0;
      r_y_px_pre11 <= 0;
      r_y_px_pre21 <= 0;
      r_y_px_pre31 <= 0;
      r_y_px_pre41 <= 0;
    end
    else if(i_conv_wen[1]) begin
      r_y_px_pre01 <= w_y_ln0;
      r_y_px_pre11 <= w_y_ln1;
      r_y_px_pre21 <= w_y_ln2;
      r_y_px_pre31 <= w_y_ln3;
      r_y_px_pre41 <= w_y_ln4;
    end
  end
  always @(posedge clk, negedge rstn) begin
    if(!rstn) begin
      r_y_px_pre02 <= 0;
      r_y_px_pre12 <= 0;
      r_y_px_pre22 <= 0;
      r_y_px_pre32 <= 0;
      r_y_px_pre42 <= 0;
    end
    else if(i_conv_wen[2]) begin
      r_y_px_pre02 <= w_y_ln0;
      r_y_px_pre12 <= w_y_ln1;
      r_y_px_pre22 <= w_y_ln2;
      r_y_px_pre32 <= w_y_ln3;
      r_y_px_pre42 <= w_y_ln4;
    end
  end
  always @(posedge clk, negedge rstn) begin
    if(!rstn) begin
      r_y_px_pre03 <= 0;
      r_y_px_pre13 <= 0;
      r_y_px_pre23 <= 0;
      r_y_px_pre33 <= 0;
      r_y_px_pre43 <= 0;
    end
    else if(i_conv_wen[3]) begin
      r_y_px_pre03 <= w_y_ln0;
      r_y_px_pre13 <= w_y_ln1;
      r_y_px_pre23 <= w_y_ln2;
      r_y_px_pre33 <= w_y_ln3;
      r_y_px_pre43 <= w_y_ln4;
    end
  end

  reg [7:0] w_y00;
  reg [7:0] w_y01;
  reg [7:0] w_y02;
  reg [7:0] w_y03;
  reg [7:0] w_y04;
  reg [7:0] w_y10;
  reg [7:0] w_y11;
  reg [7:0] w_y12;
  reg [7:0] w_y13;
  reg [7:0] w_y14;
  reg [7:0] w_y20;
  reg [7:0] w_y21;
  reg [7:0] w_y22;
  reg [7:0] w_y23;
  reg [7:0] w_y24;
  reg [7:0] w_y30;
  reg [7:0] w_y31;
  reg [7:0] w_y32;
  reg [7:0] w_y33;
  reg [7:0] w_y34;
  reg [7:0] w_y40;
  reg [7:0] w_y41;
  reg [7:0] w_y42;
  reg [7:0] w_y43;
  reg [7:0] w_y44;

  always @(*) begin
    case(i_conv_px_sel)
      3'b000 : w_y00 = r_y_px_pre00;
      3'b001 : w_y00 = r_y_px_pre01;
      3'b010 : w_y00 = r_y_px_pre02;
      3'b011 : w_y00 = r_y_px_pre03;
      default: w_y00 = w_y_ln0;
    endcase
  end
  always @(*) begin
    case(i_conv_px_sel)
      3'b000 : w_y01 = r_y_px_pre01;
      3'b001 : w_y01 = r_y_px_pre02;
      3'b010 : w_y01 = r_y_px_pre03;
      3'b011 : w_y01 = w_y_ln0  ;
      default: w_y01 = r_y_px_pre00;
    endcase
  end
  always @(*) begin
    case(i_conv_px_sel)
      3'b000 : w_y02 = r_y_px_pre02;
      3'b001 : w_y02 = r_y_px_pre03;
      3'b010 : w_y02 = w_y_ln0  ;
      3'b011 : w_y02 = r_y_px_pre00;
      default: w_y02 = r_y_px_pre01;
    endcase
  end
  always @(*) begin
    case(i_conv_px_sel)
      3'b000 : w_y03 = r_y_px_pre03;
      3'b001 : w_y03 = w_y_ln0  ;
      3'b010 : w_y03 = r_y_px_pre00;
      3'b011 : w_y03 = r_y_px_pre01;
      default: w_y03 = r_y_px_pre02;
    endcase
  end
  always @(*) begin
    case(i_conv_px_sel)
      3'b000 : w_y04 = w_y_ln0  ;
      3'b001 : w_y04 = r_y_px_pre00;
      3'b010 : w_y04 = r_y_px_pre01;
      3'b011 : w_y04 = r_y_px_pre02;
      default: w_y04 = r_y_px_pre03;
    endcase
  end
  always @(*) begin
    case(i_conv_px_sel)
      3'b000 : w_y10 = r_y_px_pre10;
      3'b001 : w_y10 = r_y_px_pre11;
      3'b010 : w_y10 = r_y_px_pre12;
      3'b011 : w_y10 = r_y_px_pre13;
      default: w_y10 = w_y_ln1;
    endcase
  end
  always @(*) begin
    case(i_conv_px_sel)
      3'b000 : w_y11 = r_y_px_pre11;
      3'b001 : w_y11 = r_y_px_pre12;
      3'b010 : w_y11 = r_y_px_pre13;
      3'b011 : w_y11 = w_y_ln1  ;
      default: w_y11 = r_y_px_pre10;
    endcase
  end
  always @(*) begin
    case(i_conv_px_sel)
      3'b000 : w_y12 = r_y_px_pre12;
      3'b001 : w_y12 = r_y_px_pre13;
      3'b010 : w_y12 = w_y_ln1  ;
      3'b011 : w_y12 = r_y_px_pre10;
      default: w_y12 = r_y_px_pre11;
    endcase
  end
  always @(*) begin
    case(i_conv_px_sel)
      3'b000 : w_y13 = r_y_px_pre03;
      3'b001 : w_y13 = w_y_ln1  ;
      3'b010 : w_y13 = r_y_px_pre10;
      3'b011 : w_y13 = r_y_px_pre11;
      default: w_y13 = r_y_px_pre12;
    endcase
  end
  always @(*) begin
    case(i_conv_px_sel)
      3'b000 : w_y14 = w_y_ln1  ;
      3'b001 : w_y14 = r_y_px_pre10;
      3'b010 : w_y14 = r_y_px_pre11;
      3'b011 : w_y14 = r_y_px_pre12;
      default: w_y14 = r_y_px_pre13;
    endcase
  end
  always @(*) begin
    case(i_conv_px_sel)
      3'b000 : w_y20 = r_y_px_pre20;
      3'b001 : w_y20 = r_y_px_pre21;
      3'b010 : w_y20 = r_y_px_pre22;
      3'b011 : w_y20 = r_y_px_pre23;
      default: w_y20 = w_y_ln2;
    endcase
  end
  always @(*) begin
    case(i_conv_px_sel)
      3'b000 : w_y21 = r_y_px_pre21;
      3'b001 : w_y21 = r_y_px_pre22;
      3'b010 : w_y21 = r_y_px_pre23;
      3'b011 : w_y21 = w_y_ln2  ;
      default: w_y21 = r_y_px_pre20;
    endcase
  end
  always @(*) begin
    case(i_conv_px_sel)
      3'b000 : w_y22 = r_y_px_pre22;
      3'b001 : w_y22 = r_y_px_pre23;
      3'b010 : w_y22 = w_y_ln2  ;
      3'b011 : w_y22 = r_y_px_pre20;
      default: w_y22 = r_y_px_pre21;
    endcase
  end
  always @(*) begin
    case(i_conv_px_sel)
      3'b000 : w_y23 = r_y_px_pre23;
      3'b001 : w_y23 = w_y_ln2  ;
      3'b010 : w_y23 = r_y_px_pre20;
      3'b011 : w_y23 = r_y_px_pre21;
      default: w_y23 = r_y_px_pre22;
    endcase
  end
  always @(*) begin
    case(i_conv_px_sel)
      3'b000 : w_y24 = w_y_ln2  ;
      3'b001 : w_y24 = r_y_px_pre20;
      3'b010 : w_y24 = r_y_px_pre21;
      3'b011 : w_y24 = r_y_px_pre22;
      default: w_y24 = r_y_px_pre23;
    endcase
  end
  always @(*) begin
    case(i_conv_px_sel)
      3'b000 : w_y30 = r_y_px_pre00;
      3'b001 : w_y30 = r_y_px_pre01;
      3'b010 : w_y30 = r_y_px_pre02;
      3'b011 : w_y30 = r_y_px_pre03;
      default: w_y30 = w_y_ln3;
    endcase
  end
  always @(*) begin
    case(i_conv_px_sel)
      3'b000 : w_y31 = r_y_px_pre31;
      3'b001 : w_y31 = r_y_px_pre32;
      3'b010 : w_y31 = r_y_px_pre33;
      3'b011 : w_y31 = w_y_ln3  ;
      default: w_y31 = r_y_px_pre30;
    endcase
  end
  always @(*) begin
    case(i_conv_px_sel)
      3'b000 : w_y32 = r_y_px_pre32;
      3'b001 : w_y32 = r_y_px_pre33;
      3'b010 : w_y32 = w_y_ln3  ;
      3'b011 : w_y32 = r_y_px_pre30;
      default: w_y32 = r_y_px_pre31;
    endcase
  end
  always @(*) begin
    case(i_conv_px_sel)
      3'b000 : w_y33 = r_y_px_pre33;
      3'b001 : w_y33 = w_y_ln3  ;
      3'b010 : w_y33 = r_y_px_pre30;
      3'b011 : w_y33 = r_y_px_pre31;
      default: w_y33 = r_y_px_pre32;
    endcase
  end
  always @(*) begin
    case(i_conv_px_sel)
      3'b000 : w_y34 = w_y_ln3  ;
      3'b001 : w_y34 = r_y_px_pre30;
      3'b010 : w_y34 = r_y_px_pre31;
      3'b011 : w_y34 = r_y_px_pre32;
      default: w_y34 = r_y_px_pre33;
    endcase
  end
  always @(*) begin
    case(i_conv_px_sel)
      3'b000 : w_y40 = r_y_px_pre40;
      3'b001 : w_y40 = r_y_px_pre41;
      3'b010 : w_y40 = r_y_px_pre42;
      3'b011 : w_y40 = r_y_px_pre43;
      default: w_y40 = w_y_ln4;
    endcase
  end
  always @(*) begin
    case(i_conv_px_sel)
      3'b000 : w_y41 = r_y_px_pre41;
      3'b001 : w_y41 = r_y_px_pre42;
      3'b010 : w_y41 = r_y_px_pre43;
      3'b011 : w_y41 = w_y_ln4  ;
      default: w_y41 = r_y_px_pre40;
    endcase
  end
  always @(*) begin
    case(i_conv_px_sel)
      3'b000 : w_y42 = r_y_px_pre42;
      3'b001 : w_y42 = r_y_px_pre43;
      3'b010 : w_y42 = w_y_ln4  ;
      3'b011 : w_y42 = r_y_px_pre40;
      default: w_y42 = r_y_px_pre41;
    endcase
  end
  always @(*) begin
    case(i_conv_px_sel)
      3'b000 : w_y43 = r_y_px_pre43;
      3'b001 : w_y43 = w_y_ln4  ;
      3'b010 : w_y43 = r_y_px_pre40;
      3'b011 : w_y43 = r_y_px_pre41;
      default: w_y43 = r_y_px_pre42;
    endcase
  end
  always @(*) begin
    case(i_conv_px_sel)
      3'b000 : w_y44 = w_y_ln4  ;
      3'b001 : w_y44 = r_y_px_pre40;
      3'b010 : w_y44 = r_y_px_pre41;
      3'b011 : w_y44 = r_y_px_pre42;
      default: w_y44 = r_y_px_pre43;
    endcase
  end

  always @(posedge clk, negedge rstn) begin
    if(!rstn) begin
      o_y00 <= 0;
      o_y01 <= 0;
      o_y02 <= 0;
      o_y03 <= 0;
      o_y04 <= 0;
      o_y10 <= 0;
      o_y11 <= 0;
      o_y12 <= 0;
      o_y13 <= 0;
      o_y14 <= 0;
      o_y20 <= 0;
      o_y21 <= 0;
      o_y22 <= 0;
      o_y23 <= 0;
      o_y24 <= 0;
      o_y30 <= 0;
      o_y31 <= 0;
      o_y32 <= 0;
      o_y33 <= 0;
      o_y34 <= 0;
      o_y40 <= 0;
      o_y41 <= 0;
      o_y42 <= 0;
      o_y43 <= 0;
      o_y44 <= 0;
    end
    else if(i_conv_ren) begin
      o_y00 <= w_y00;
      o_y01 <= w_y01;
      o_y02 <= w_y02;
      o_y03 <= w_y03;
      o_y04 <= w_y04;
      o_y10 <= w_y10;
      o_y11 <= w_y11;
      o_y12 <= w_y12;
      o_y13 <= w_y13;
      o_y14 <= w_y14;
      o_y20 <= w_y20;
      o_y21 <= w_y21;
      o_y22 <= w_y22;
      o_y23 <= w_y23;
      o_y24 <= w_y24;
      o_y30 <= w_y30;
      o_y31 <= w_y31;
      o_y32 <= w_y32;
      o_y33 <= w_y33;
      o_y34 <= w_y34;
      o_y40 <= w_y40;
      o_y41 <= w_y41;
      o_y42 <= w_y42;
      o_y43 <= w_y43;
      o_y44 <= w_y44;
    end
  end
endmodule
