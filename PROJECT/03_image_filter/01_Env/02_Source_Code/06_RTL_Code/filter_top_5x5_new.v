// ./list_rtl.f

module filter_top_5x5_new
#(
  parameter DATA_WIDTH     = 8 ,
  parameter COEF_WIDTH     = 10,
  parameter MEM_Y_WIDTH    = 4 ,
  parameter MEM_U_WIDTH    = 2 ,
  parameter MEM_V_WIDTH    = 2 ,
  parameter MEM_ADDR_WIDTH = 11,
  parameter RL             = 8
)
(
  input                    clk      ,
  input                    rstn     ,

  input                    i_bypass ,
  input   [COEF_WIDTH-1:0] i_coef00 ,
  input   [COEF_WIDTH-1:0] i_coef01 ,
  input   [COEF_WIDTH-1:0] i_coef02 ,
  input   [COEF_WIDTH-1:0] i_coef03 ,
  input   [COEF_WIDTH-1:0] i_coef04 ,
  input   [COEF_WIDTH-1:0] i_coef10 ,
  input   [COEF_WIDTH-1:0] i_coef11 ,
  input   [COEF_WIDTH-1:0] i_coef12 ,
  input   [COEF_WIDTH-1:0] i_coef13 ,
  input   [COEF_WIDTH-1:0] i_coef14 ,
  input   [COEF_WIDTH-1:0] i_coef20 ,
  input   [COEF_WIDTH-1:0] i_coef21 ,
  input   [COEF_WIDTH-1:0] i_coef22 ,
  input   [COEF_WIDTH-1:0] i_coef23 ,
  input   [COEF_WIDTH-1:0] i_coef24 ,
  input   [COEF_WIDTH-1:0] i_coef30 ,
  input   [COEF_WIDTH-1:0] i_coef31 ,
  input   [COEF_WIDTH-1:0] i_coef32 ,
  input   [COEF_WIDTH-1:0] i_coef33 ,
  input   [COEF_WIDTH-1:0] i_coef34 ,
  input   [COEF_WIDTH-1:0] i_coef40 ,
  input   [COEF_WIDTH-1:0] i_coef41 ,
  input   [COEF_WIDTH-1:0] i_coef42 ,
  input   [COEF_WIDTH-1:0] i_coef43 ,
  input   [COEF_WIDTH-1:0] i_coef44 ,
  input                    i_vs     ,
  input                    i_hs     ,
  input                    i_de     ,
  input   [DATA_WIDTH-1:0] i_y      ,
  input   [DATA_WIDTH-1:0] i_u      ,
  input   [DATA_WIDTH-1:0] i_v      ,
  output                   o_vs     ,
  output                   o_hs     ,
  output                   o_de     ,
  output  [DATA_WIDTH-1:0] o_y      ,
  output  [DATA_WIDTH-1:0] o_u      ,
  output  [DATA_WIDTH-1:0] o_v      
);

  wire                      w_mem_ren  ;
  wire [1:0]                w_mem_sel  ;
  wire [MEM_ADDR_WIDTH-1:0] w_mem_waddr;
  wire [MEM_ADDR_WIDTH-1:0] w_mem_raddr;
  wire [3:0]                w_pad_y    ;
  filter_control
  #(
    .MEM_ADDR_WIDTH(MEM_ADDR_WIDTH),
    .PAD_SIZE      (2             )
  )
  u_control
  (
    .clk          (clk          ),
    .rstn         (rstn         ),
    .i_vs         (i_vs         ),
    .i_hs         (i_hs         ),
    .o_mem_ren    (w_mem_ren    ),
    .o_mem_sel    (w_mem_sel    ),
    .o_mem_waddr  (w_mem_waddr  ),
    .o_mem_raddr  (w_mem_raddr  ),
    .o_pad_y      (w_pad_y      ),
    .o_vs         (o_vs         ),
    .o_hs         (o_hs         ) 
  );

  wire                         w_aln_de;
  wire signed [DATA_WIDTH-1:0] w_y00;
  wire signed [DATA_WIDTH-1:0] w_y01;
  wire signed [DATA_WIDTH-1:0] w_y02;
  wire signed [DATA_WIDTH-1:0] w_y03;
  wire signed [DATA_WIDTH-1:0] w_y04;
  wire signed [DATA_WIDTH-1:0] w_y10;
  wire signed [DATA_WIDTH-1:0] w_y11;
  wire signed [DATA_WIDTH-1:0] w_y12;
  wire signed [DATA_WIDTH-1:0] w_y13;
  wire signed [DATA_WIDTH-1:0] w_y14;
  wire signed [DATA_WIDTH-1:0] w_y20;
  wire signed [DATA_WIDTH-1:0] w_y21;
  wire signed [DATA_WIDTH-1:0] w_y22;
  wire signed [DATA_WIDTH-1:0] w_y23;
  wire signed [DATA_WIDTH-1:0] w_y24;
  wire signed [DATA_WIDTH-1:0] w_y30;
  wire signed [DATA_WIDTH-1:0] w_y31;
  wire signed [DATA_WIDTH-1:0] w_y32;
  wire signed [DATA_WIDTH-1:0] w_y33;
  wire signed [DATA_WIDTH-1:0] w_y34;
  wire signed [DATA_WIDTH-1:0] w_y40;
  wire signed [DATA_WIDTH-1:0] w_y41;
  wire signed [DATA_WIDTH-1:0] w_y42;
  wire signed [DATA_WIDTH-1:0] w_y43;
  wire signed [DATA_WIDTH-1:0] w_y44;
  filter_data_align_5x5_new 
  #(
    .DATA_WIDTH    (DATA_WIDTH    ),
    .MEM_ADDR_WIDTH(MEM_ADDR_WIDTH)
  )
  u_data_align
  (
    .clk          (clk          ),
    .rstn         (rstn         ),
    .i_de         (i_de         ),
    .i_y          (i_y          ),
    .i_u          (i_u          ),
    .i_v          (i_v          ),
    .i_mem_ren    (w_mem_ren    ),
    .i_mem_sel    (w_mem_sel    ),
    .i_mem_waddr  (w_mem_waddr  ),
    .i_mem_raddr  (w_mem_raddr  ),
    .i_pad_y      (w_pad_y      ),
    .o_de         (w_aln_de     ),
    .o_y00        (w_y00        ),
    .o_y01        (w_y01        ),
    .o_y02        (w_y02        ),
    .o_y03        (w_y03        ),
    .o_y04        (w_y04        ),
    .o_y10        (w_y10        ),
    .o_y11        (w_y11        ),
    .o_y12        (w_y12        ),
    .o_y13        (w_y13        ),
    .o_y14        (w_y14        ),
    .o_y20        (w_y20        ),
    .o_y21        (w_y21        ),
    .o_y22        (w_y22        ),
    .o_y23        (w_y23        ),
    .o_y24        (w_y24        ),
    .o_y30        (w_y30        ),
    .o_y31        (w_y31        ),
    .o_y32        (w_y32        ),
    .o_y33        (w_y33        ),
    .o_y34        (w_y34        ),
    .o_y40        (w_y40        ),
    .o_y41        (w_y41        ),
    .o_y42        (w_y42        ),
    .o_y43        (w_y43        ),
    .o_y44        (w_y44        ),
    .o_u          (o_u          ),
    .o_v          (o_v          )
  );
  filter_conv_5x5 u_conv (
    .clk     (clk      ),
    .rstn    (rstn     ),
    .i_coef00(i_coef00 ),
    .i_coef01(i_coef01 ),
    .i_coef02(i_coef02 ),
    .i_coef03(i_coef03 ),
    .i_coef04(i_coef04 ),
    .i_coef10(i_coef10 ),
    .i_coef11(i_coef11 ),
    .i_coef12(i_coef12 ),
    .i_coef13(i_coef13 ),
    .i_coef14(i_coef14 ),
    .i_coef20(i_coef20 ),
    .i_coef21(i_coef21 ),
    .i_coef22(i_coef22 ),
    .i_coef23(i_coef23 ),
    .i_coef24(i_coef24 ),
    .i_coef30(i_coef30 ),
    .i_coef31(i_coef31 ),
    .i_coef32(i_coef32 ),
    .i_coef33(i_coef33 ),
    .i_coef34(i_coef34 ),
    .i_coef40(i_coef40 ),
    .i_coef41(i_coef41 ),
    .i_coef42(i_coef42 ),
    .i_coef43(i_coef43 ),
    .i_coef44(i_coef44 ),
    .i_de    (w_aln_de ),
    .i_x00   (w_y00    ),
    .i_x01   (w_y01    ),
    .i_x02   (w_y02    ),
    .i_x03   (w_y03    ),
    .i_x04   (w_y04    ),
    .i_x10   (w_y10    ),
    .i_x11   (w_y11    ),
    .i_x12   (w_y12    ),
    .i_x13   (w_y13    ),
    .i_x14   (w_y14    ),
    .i_x20   (w_y20    ),
    .i_x21   (w_y21    ),
    .i_x22   (w_y22    ),
    .i_x23   (w_y23    ),
    .i_x24   (w_y24    ),
    .i_x30   (w_y30    ),
    .i_x31   (w_y31    ),
    .i_x32   (w_y32    ),
    .i_x33   (w_y33    ),
    .i_x34   (w_y34    ),
    .i_x40   (w_y40    ),
    .i_x41   (w_y41    ),
    .i_x42   (w_y42    ),
    .i_x43   (w_y43    ),
    .i_x44   (w_y44    ),
    .o_de    (o_de     ),
    .o_y     (o_y      ) 
  );

endmodule
