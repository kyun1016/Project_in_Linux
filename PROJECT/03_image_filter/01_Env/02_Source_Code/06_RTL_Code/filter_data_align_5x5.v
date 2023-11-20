// ./list_rtl.f

module filter_data_align_5x5
#(
  parameter DATA_WIDTH     = 8 ,
  parameter MEM_Y_WIDTH    = 4 ,
  parameter MEM_U_WIDTH    = 2 ,
  parameter MEM_V_WIDTH    = 2 ,
  parameter MEM_ADDR_WIDTH = 11
)
(
  input                           clk           ,
  input                           rstn          ,
  input      [DATA_WIDTH-1:0]     i_y           ,
  input      [DATA_WIDTH-1:0]     i_u           ,
  input      [DATA_WIDTH-1:0]     i_v           ,
  input      [MEM_Y_WIDTH-1:0]    i_mem_y_wen   ,
  input      [MEM_Y_WIDTH-1:0]    i_mem_y_ren   ,
  input      [MEM_U_WIDTH-1:0]    i_mem_u_wen   ,
  input      [MEM_U_WIDTH-1:0]    i_mem_u_ren   ,
  input      [MEM_V_WIDTH-1:0]    i_mem_v_wen   ,
  input      [MEM_V_WIDTH-1:0]    i_mem_v_ren   ,
  input      [MEM_ADDR_WIDTH-1:0] i_mem_waddr   ,
  input      [MEM_ADDR_WIDTH-1:0] i_mem_raddr   ,
  output reg [DATA_WIDTH-1:0]     o_y00         ,
  output reg [DATA_WIDTH-1:0]     o_y01         ,
  output reg [DATA_WIDTH-1:0]     o_y02         ,
  output reg [DATA_WIDTH-1:0]     o_y03         ,
  output reg [DATA_WIDTH-1:0]     o_y04         ,
  output reg [DATA_WIDTH-1:0]     o_y10         ,
  output reg [DATA_WIDTH-1:0]     o_y11         ,
  output reg [DATA_WIDTH-1:0]     o_y12         ,
  output reg [DATA_WIDTH-1:0]     o_y13         ,
  output reg [DATA_WIDTH-1:0]     o_y14         ,
  output reg [DATA_WIDTH-1:0]     o_y20         ,
  output reg [DATA_WIDTH-1:0]     o_y21         ,
  output reg [DATA_WIDTH-1:0]     o_y22         ,
  output reg [DATA_WIDTH-1:0]     o_y23         ,
  output reg [DATA_WIDTH-1:0]     o_y24         ,
  output reg [DATA_WIDTH-1:0]     o_y30         ,
  output reg [DATA_WIDTH-1:0]     o_y31         ,
  output reg [DATA_WIDTH-1:0]     o_y32         ,
  output reg [DATA_WIDTH-1:0]     o_y33         ,
  output reg [DATA_WIDTH-1:0]     o_y34         ,
  output reg [DATA_WIDTH-1:0]     o_y40         ,
  output reg [DATA_WIDTH-1:0]     o_y41         ,
  output reg [DATA_WIDTH-1:0]     o_y42         ,
  output reg [DATA_WIDTH-1:0]     o_y43         ,
  output reg [DATA_WIDTH-1:0]     o_y44         ,
  output     [DATA_WIDTH-1:0]     o_u           ,
  output     [DATA_WIDTH-1:0]     o_v           
);
  //============================================================
  // Part 1. Select Memory
  //============================================================
  wire [DATA_WIDTH-1:0] w_mem_y0;
  wire [DATA_WIDTH-1:0] w_mem_y1;
  wire [DATA_WIDTH-1:0] w_mem_y2;
  wire [DATA_WIDTH-1:0] w_mem_y3;
  simple_dual_one_clock u_mem_y0(
    .clk     (clk           ),
    .i_a_en  (i_mem_y_wen[0]),
    .i_b_en  (i_mem_y_ren[0]),
    .i_a_we  (i_mem_y_wen[0]),
    .i_a_addr(i_mem_waddr   ),
    .i_b_addr(i_mem_raddr   ),
    .i_a_data(i_y           ),
    .o_b_data(w_mem_y0      )
  );
  simple_dual_one_clock u_mem_y1(
    .clk     (clk           ),
    .i_a_en  (i_mem_y_wen[1]),
    .i_b_en  (i_mem_y_ren[1]),
    .i_a_we  (i_mem_y_wen[1]),
    .i_a_addr(i_mem_waddr   ),
    .i_b_addr(i_mem_raddr   ),
    .i_a_data(i_y           ),
    .o_b_data(w_mem_y1      )
  );
  simple_dual_one_clock u_mem_y2(
    .clk     (clk           ),
    .i_a_en  (i_mem_y_wen[2]),
    .i_b_en  (i_mem_y_ren[2]),
    .i_a_we  (i_mem_y_wen[2]),
    .i_a_addr(i_mem_waddr   ),
    .i_b_addr(i_mem_raddr   ),
    .i_a_data(i_y           ),
    .o_b_data(w_mem_y2      )
  );
  simple_dual_one_clock u_mem_y3(
    .clk     (clk           ),
    .i_a_en  (i_mem_y_wen[3]),
    .i_b_en  (i_mem_y_ren[3]),
    .i_a_we  (i_mem_y_wen[3]),
    .i_a_addr(i_mem_waddr   ),
    .i_b_addr(i_mem_raddr   ),
    .i_a_data(i_y           ),
    .o_b_data(w_mem_y3      )
  );

  wire [DATA_WIDTH-1:0] w_mem_u0;
  wire [DATA_WIDTH-1:0] w_mem_u1;
  simple_dual_one_clock u_mem_u0(
    .clk     (clk           ),
    .i_a_en  (i_mem_u_wen[0]),
    .i_b_en  (i_mem_u_ren[0]),
    .i_a_we  (i_mem_u_wen[0]),
    .i_a_addr(i_mem_waddr   ),
    .i_b_addr(i_mem_raddr   ),
    .i_a_data(i_u           ),
    .o_b_data(w_mem_u0      )
  );
  simple_dual_one_clock u_mem_u1(
    .clk     (clk           ),
    .i_a_en  (i_mem_u_wen[1]),
    .i_b_en  (i_mem_u_ren[1]),
    .i_a_we  (i_mem_u_wen[1]),
    .i_a_addr(i_mem_waddr   ),
    .i_b_addr(i_mem_raddr   ),
    .i_a_data(i_u           ),
    .o_b_data(w_mem_u1      )
  );
  wire [DATA_WIDTH-1:0] w_mem_v0;
  wire [DATA_WIDTH-1:0] w_mem_v1;
  simple_dual_one_clock u_mem_v0(
    .clk     (clk           ),
    .i_a_en  (i_mem_v_wen[0]),
    .i_b_en  (i_mem_v_ren[0]),
    .i_a_we  (i_mem_v_wen[0]),
    .i_a_addr(i_mem_waddr   ),
    .i_b_addr(i_mem_raddr   ),
    .i_a_data(i_v           ),
    .o_b_data(w_mem_v0      )
  );
  simple_dual_one_clock u_mem_v1(
    .clk     (clk           ),
    .i_a_en  (i_mem_v_wen[1]),
    .i_b_en  (i_mem_v_ren[1]),
    .i_a_we  (i_mem_v_wen[1]),
    .i_a_addr(i_mem_waddr   ),
    .i_b_addr(i_mem_raddr   ),
    .i_a_data(i_v           ),
    .o_b_data(w_mem_v1      )
  );

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
    else begin
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
