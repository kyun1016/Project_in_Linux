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
  input                           clk          ,
  input                           rstn         ,
  input                           i_input_de   ,
  input      [DATA_WIDTH-1:0]     i_y          ,
  input      [DATA_WIDTH-1:0]     i_u          ,
  input      [DATA_WIDTH-1:0]     i_v          ,
  input                           i_mem_de     ,
  input      [MEM_ADDR_WIDTH-1:0] i_mem_waddr  ,
  input      [MEM_ADDR_WIDTH-1:0] i_mem_raddr  ,
  input      [MEM_Y_WIDTH-1:0]    i_mem_y_wen  ,
  input                           i_mem_y_ren  ,
  input      [MEM_U_WIDTH-1:0]    i_mem_u_wen  ,
  input      [MEM_U_WIDTH-1:0]    i_mem_u_ren  ,
  input      [MEM_V_WIDTH-1:0]    i_mem_v_wen  ,
  input      [MEM_V_WIDTH-1:0]    i_mem_v_ren  ,
  input      [3:0]                i_aln_ln_y   ,
  input      [3:0]                i_pad_ln_y   ,
  output reg                      o_de         ,
  output     [DATA_WIDTH-1:0]     o_y00        ,
  output     [DATA_WIDTH-1:0]     o_y01        ,
  output     [DATA_WIDTH-1:0]     o_y02        ,
  output     [DATA_WIDTH-1:0]     o_y03        ,
  output     [DATA_WIDTH-1:0]     o_y04        ,
  output     [DATA_WIDTH-1:0]     o_y10        ,
  output     [DATA_WIDTH-1:0]     o_y11        ,
  output     [DATA_WIDTH-1:0]     o_y12        ,
  output     [DATA_WIDTH-1:0]     o_y13        ,
  output     [DATA_WIDTH-1:0]     o_y14        ,
  output     [DATA_WIDTH-1:0]     o_y20        ,
  output     [DATA_WIDTH-1:0]     o_y21        ,
  output     [DATA_WIDTH-1:0]     o_y22        ,
  output     [DATA_WIDTH-1:0]     o_y23        ,
  output     [DATA_WIDTH-1:0]     o_y24        ,
  output     [DATA_WIDTH-1:0]     o_y30        ,
  output     [DATA_WIDTH-1:0]     o_y31        ,
  output     [DATA_WIDTH-1:0]     o_y32        ,
  output     [DATA_WIDTH-1:0]     o_y33        ,
  output     [DATA_WIDTH-1:0]     o_y34        ,
  output     [DATA_WIDTH-1:0]     o_y40        ,
  output     [DATA_WIDTH-1:0]     o_y41        ,
  output     [DATA_WIDTH-1:0]     o_y42        ,
  output     [DATA_WIDTH-1:0]     o_y43        ,
  output     [DATA_WIDTH-1:0]     o_y44        ,
  output     [DATA_WIDTH-1:0]     o_u          ,
  output     [DATA_WIDTH-1:0]     o_v          
);
  //============================================================
  // Part 1. Delay Data
  //============================================================
  reg [DATA_WIDTH-1:0] r_y;
  reg [DATA_WIDTH-1:0] r_u;
  reg [DATA_WIDTH-1:0] r_v;

  always @(posedge clk, negedge rstn) begin
    if(!rstn) begin
      r_y <= 'b0;
      r_u <= 'b0;
      r_v <= 'b0;
    end
    else if(i_input_de) begin
      r_y <= i_y;
      r_u <= i_u;
      r_v <= i_v;
    end
  end

  //============================================================
  // Part 2. Select Memory
  //============================================================
  wire [DATA_WIDTH-1:0] w_mem_y0;
  wire [DATA_WIDTH-1:0] w_mem_y1;
  wire [DATA_WIDTH-1:0] w_mem_y2;
  wire [DATA_WIDTH-1:0] w_mem_y3;
  simple_dual_one_clock u_mem_y0(
    .clk     (clk           ),
    .i_a_en  (i_mem_y_wen[0]),
    .i_b_en  (i_mem_y_ren   ),
    .i_a_we  (i_mem_y_wen[0]),
    .i_a_addr(i_mem_waddr   ),
    .i_b_addr(i_mem_raddr   ),
    .i_a_data(r_y           ),
    .o_b_data(w_mem_y0      )
  );
  simple_dual_one_clock u_mem_y1(
    .clk     (clk           ),
    .i_a_en  (i_mem_y_wen[1]),
    .i_b_en  (i_mem_y_ren   ),
    .i_a_we  (i_mem_y_wen[1]),
    .i_a_addr(i_mem_waddr   ),
    .i_b_addr(i_mem_raddr   ),
    .i_a_data(r_y           ),
    .o_b_data(w_mem_y1      )
  );
  simple_dual_one_clock u_mem_y2(
    .clk     (clk           ),
    .i_a_en  (i_mem_y_wen[2]),
    .i_b_en  (i_mem_y_ren   ),
    .i_a_we  (i_mem_y_wen[2]),
    .i_a_addr(i_mem_waddr   ),
    .i_b_addr(i_mem_raddr   ),
    .i_a_data(r_y           ),
    .o_b_data(w_mem_y2      )
  );
  simple_dual_one_clock u_mem_y3(
    .clk     (clk           ),
    .i_a_en  (i_mem_y_wen[3]),
    .i_b_en  (i_mem_y_ren   ),
    .i_a_we  (i_mem_y_wen[3]),
    .i_a_addr(i_mem_waddr   ),
    .i_b_addr(i_mem_raddr   ),
    .i_a_data(r_y           ),
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
    .i_a_data(r_u           ),
    .o_b_data(w_mem_u0      )
  );
  simple_dual_one_clock u_mem_u1(
    .clk     (clk           ),
    .i_a_en  (i_mem_u_wen[1]),
    .i_b_en  (i_mem_u_ren[1]),
    .i_a_we  (i_mem_u_wen[1]),
    .i_a_addr(i_mem_waddr   ),
    .i_b_addr(i_mem_raddr   ),
    .i_a_data(r_u           ),
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
    .i_a_data(r_v           ),
    .o_b_data(w_mem_v0      )
  );
  simple_dual_one_clock u_mem_v1(
    .clk     (clk           ),
    .i_a_en  (i_mem_v_wen[1]),
    .i_b_en  (i_mem_v_ren[1]),
    .i_a_we  (i_mem_v_wen[1]),
    .i_a_addr(i_mem_waddr   ),
    .i_b_addr(i_mem_raddr   ),
    .i_a_data(r_v           ),
    .o_b_data(w_mem_v1      )
  );

  //=============================================================
  // Part 3. Data Align
  //=============================================================
  reg  [DATA_WIDTH-1:0] w_aln_y0;
  reg  [DATA_WIDTH-1:0] w_aln_y1;
  reg  [DATA_WIDTH-1:0] w_aln_y2;
  reg  [DATA_WIDTH-1:0] w_aln_y3;
  wire [DATA_WIDTH-1:0] r_aln_y4 = r_y;
  always @(*) begin
    case (1'b1)
      i_aln_ln_y[0]: begin
                       w_aln_y0 = w_mem_y0;
                       w_aln_y1 = w_mem_y1;
                       w_aln_y2 = w_mem_y2;
                       w_aln_y3 = w_mem_y3;
                     end
      i_aln_ln_y[1]: begin
                       w_aln_y0 = w_mem_y1;
                       w_aln_y1 = w_mem_y2;
                       w_aln_y2 = w_mem_y3;
                       w_aln_y3 = w_mem_y0;
                     end
      i_aln_ln_y[2]: begin
                       w_aln_y0 = w_mem_y2;
                       w_aln_y1 = w_mem_y3;
                       w_aln_y2 = w_mem_y0;
                       w_aln_y3 = w_mem_y1;
                     end
      i_aln_ln_y[3]: begin
                       w_aln_y0 = w_mem_y3;
                       w_aln_y1 = w_mem_y0;
                       w_aln_y2 = w_mem_y1;
                       w_aln_y3 = w_mem_y2;
                     end
      default:       begin
                       w_aln_y0 = w_mem_y0;
                       w_aln_y1 = w_mem_y1;
                       w_aln_y2 = w_mem_y2;
                       w_aln_y3 = w_mem_y3;
                     end
    endcase
  end

  //=============================================================
  // Part 4. Line Padding
  //=============================================================
  reg  [DATA_WIDTH-1:0] w_ln_pad_y0;
  reg  [DATA_WIDTH-1:0] w_ln_pad_y1;
  wire [DATA_WIDTH-1:0] w_ln_pad_y2 = w_aln_y2;
  reg  [DATA_WIDTH-1:0] w_ln_pad_y3;
  reg  [DATA_WIDTH-1:0] w_ln_pad_y4;

  always @(*) begin
    case(1'b1)
      i_pad_ln_y[0] : w_ln_pad_y0 = w_aln_y2;
      i_pad_ln_y[1] : w_ln_pad_y0 = w_aln_y1;
      default       : w_ln_pad_y0 = w_aln_y0;
    endcase
  end
  always @(*) begin
    case(1'b1)
      i_pad_ln_y[0] : w_ln_pad_y1 = w_aln_y2;
      default       : w_ln_pad_y1 = w_aln_y1;
    endcase
  end
  always @(*) begin
    case(1'b1)
      i_pad_ln_y[2] : w_ln_pad_y3 = w_aln_y2;
      default       : w_ln_pad_y3 = w_aln_y3;
    endcase
  end
  always @(*) begin
    case(1'b1)
      i_pad_ln_y[2] : w_ln_pad_y4 = w_aln_y2;
      i_pad_ln_y[3] : w_ln_pad_y4 = w_aln_y3;
      default       : w_ln_pad_y4 = r_aln_y4;
    endcase
  end

  //=============================================================
  // Part 5. DE Shift
  //=============================================================
  reg r_mem_de;
  always @(posedge clk, negedge rstn) begin
    if(!rstn) begin
      r_mem_de <= 1'b0;
      o_de     <= 1'b0;
    end
    else begin
      r_mem_de <= i_mem_de;
      o_de     <= r_mem_de;
    end
  end

  //=============================================================
  // Part 6. Pixel Padding
  //=============================================================
  reg  [DATA_WIDTH-1:0] r_px_pad_y00;
  reg  [DATA_WIDTH-1:0] r_px_pad_y01;
  reg  [DATA_WIDTH-1:0] r_px_pad_y02;
  reg  [DATA_WIDTH-1:0] r_px_pad_y03;
  wire [DATA_WIDTH-1:0] w_px_pad_y04 = w_ln_pad_y0;
  reg  [DATA_WIDTH-1:0] r_px_pad_y10;
  reg  [DATA_WIDTH-1:0] r_px_pad_y11;
  reg  [DATA_WIDTH-1:0] r_px_pad_y12;
  reg  [DATA_WIDTH-1:0] r_px_pad_y13;
  wire [DATA_WIDTH-1:0] w_px_pad_y14 = w_ln_pad_y1;
  reg  [DATA_WIDTH-1:0] r_px_pad_y20;
  reg  [DATA_WIDTH-1:0] r_px_pad_y21;
  reg  [DATA_WIDTH-1:0] r_px_pad_y22;
  reg  [DATA_WIDTH-1:0] r_px_pad_y23;
  wire [DATA_WIDTH-1:0] w_px_pad_y24 = w_ln_pad_y2;
  reg  [DATA_WIDTH-1:0] r_px_pad_y30;
  reg  [DATA_WIDTH-1:0] r_px_pad_y31;
  reg  [DATA_WIDTH-1:0] r_px_pad_y32;
  reg  [DATA_WIDTH-1:0] r_px_pad_y33;
  wire [DATA_WIDTH-1:0] w_px_pad_y34 = w_ln_pad_y3;
  reg  [DATA_WIDTH-1:0] r_px_pad_y40;
  reg  [DATA_WIDTH-1:0] r_px_pad_y41;
  reg  [DATA_WIDTH-1:0] r_px_pad_y42;
  reg  [DATA_WIDTH-1:0] r_px_pad_y43;
  wire [DATA_WIDTH-1:0] w_px_pad_y44 = w_ln_pad_y4;

  always @(posedge clk, negedge rstn) begin
    if(!rstn) begin
      r_px_pad_y01 <= 'b0;
      r_px_pad_y11 <= 'b0;
      r_px_pad_y21 <= 'b0;
      r_px_pad_y31 <= 'b0;
      r_px_pad_y41 <= 'b0;
    end
    else if(i_mem_de & (!r_mem_de | !o_de)) begin
      r_px_pad_y01 <= w_px_pad_y04;
      r_px_pad_y11 <= w_px_pad_y14;
      r_px_pad_y21 <= w_px_pad_y24;
      r_px_pad_y31 <= w_px_pad_y34;
      r_px_pad_y41 <= w_px_pad_y44;
    end
    else if(i_mem_de | r_mem_de) begin
      r_px_pad_y01 <= r_px_pad_y02;
      r_px_pad_y11 <= r_px_pad_y12;
      r_px_pad_y21 <= r_px_pad_y22;
      r_px_pad_y31 <= r_px_pad_y32;
      r_px_pad_y41 <= r_px_pad_y42;
    end
  end

  always @(posedge clk, negedge rstn) begin
    if(!rstn) begin
      r_px_pad_y00 <= 'b0;
      r_px_pad_y02 <= 'b0;
      r_px_pad_y03 <= 'b0;
      r_px_pad_y10 <= 'b0;
      r_px_pad_y12 <= 'b0;
      r_px_pad_y13 <= 'b0;
      r_px_pad_y20 <= 'b0;
      r_px_pad_y22 <= 'b0;
      r_px_pad_y23 <= 'b0;
      r_px_pad_y30 <= 'b0;
      r_px_pad_y32 <= 'b0;
      r_px_pad_y33 <= 'b0;
      r_px_pad_y40 <= 'b0;
      r_px_pad_y42 <= 'b0;
      r_px_pad_y43 <= 'b0;
    end
    else if(i_mem_de | r_mem_de) begin
      r_px_pad_y00 <= r_px_pad_y01;
      r_px_pad_y02 <= r_px_pad_y03;
      r_px_pad_y03 <= w_px_pad_y04;
      r_px_pad_y10 <= r_px_pad_y11;
      r_px_pad_y12 <= r_px_pad_y13;
      r_px_pad_y13 <= w_px_pad_y14;
      r_px_pad_y20 <= r_px_pad_y21;
      r_px_pad_y22 <= r_px_pad_y23;
      r_px_pad_y23 <= w_px_pad_y24;
      r_px_pad_y30 <= r_px_pad_y31;
      r_px_pad_y32 <= r_px_pad_y33;
      r_px_pad_y33 <= w_px_pad_y34;
      r_px_pad_y40 <= r_px_pad_y41;
      r_px_pad_y42 <= r_px_pad_y43;
      r_px_pad_y43 <= w_px_pad_y44;
    end
  end

  //=============================================================
  // Part 7. Output Mapping
  //=============================================================
  assign o_y00 = r_px_pad_y00;
  assign o_y01 = r_px_pad_y01;
  assign o_y02 = r_px_pad_y02;
  assign o_y03 = r_px_pad_y03;
  assign o_y04 = w_px_pad_y04;
  assign o_y10 = r_px_pad_y10;
  assign o_y11 = r_px_pad_y11;
  assign o_y12 = r_px_pad_y12;
  assign o_y13 = r_px_pad_y13;
  assign o_y14 = w_px_pad_y14;
  assign o_y20 = r_px_pad_y20;
  assign o_y21 = r_px_pad_y21;
  assign o_y22 = r_px_pad_y22;
  assign o_y23 = r_px_pad_y23;
  assign o_y24 = w_px_pad_y24;
  assign o_y30 = r_px_pad_y30;
  assign o_y31 = r_px_pad_y31;
  assign o_y32 = r_px_pad_y32;
  assign o_y33 = r_px_pad_y33;
  assign o_y34 = w_px_pad_y34;
  assign o_y40 = r_px_pad_y40;
  assign o_y41 = r_px_pad_y41;
  assign o_y42 = r_px_pad_y42;
  assign o_y43 = r_px_pad_y43;
  assign o_y44 = w_px_pad_y44;
endmodule
