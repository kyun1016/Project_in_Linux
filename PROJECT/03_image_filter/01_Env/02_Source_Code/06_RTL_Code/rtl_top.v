// ./list_rtl.f

module rtl_top
#(
  parameter SEL_WIDTH       = 4 , 
  parameter APB_ADDR_WIDTH  = 10, // maximum width 32 bits
  parameter APB_DATA_WIDTH  = 32, // 8/16/32 bits wide
  parameter DATA_WIDTH      = 8 , // R/G/B
  parameter COEF_WIDTH      = 10, 
  parameter BIAS_WIDTH      = 8 ,

  parameter CSC_RL          = 9 ,
  parameter ICSC_RL         = 9 ,
  parameter FILTER1_RL      = 9 ,
  parameter FILTER2_RL      = 9 
)
(
  input                       clk             ,
  input                       rstn            ,
  input                       clk_apb         ,
  input                       rstn_apb        ,

  input  [APB_ADDR_WIDTH-1:0] i_apb_paddr     , // APB address bus
  input                       i_apb_psel      , // Select
  input                       i_apb_penable   , // Enable
  input                       i_apb_pwrite    , // Direction
  input  [APB_DATA_WIDTH-1:0] i_apb_pwdata    , // Write data (PWRITE is HIGH)
  output                      o_apb_pready    , // used to extend an APB transfer by the Completer
  output [APB_DATA_WIDTH-1:0] o_apb_prdata    , // Write data (PWRITE is HIGH)

  input                       i_vs            ,
  input                       i_hs            ,
  input                       i_de            ,
  input  [DATA_WIDTH-1:0]     i_r             ,
  input  [DATA_WIDTH-1:0]     i_g             ,
  input  [DATA_WIDTH-1:0]     i_b             ,
  output                      o_vs            ,
  output                      o_hs            ,
  output                      o_de            ,
  output [DATA_WIDTH-1:0]     o_r             ,
  output [DATA_WIDTH-1:0]     o_g             ,
  output [DATA_WIDTH-1:0]     o_b              
);
  wire [9:0] w_csc_coef00    ;
  wire [9:0] w_csc_coef01    ;
  wire [9:0] w_csc_coef02    ;
  wire [9:0] w_csc_coef10    ;
  wire [9:0] w_csc_coef11    ;
  wire [9:0] w_csc_coef12    ;
  wire [9:0] w_csc_coef20    ;
  wire [9:0] w_csc_coef21    ;
  wire [9:0] w_csc_coef22    ;
  wire [7:0] w_csc_bias0     ;
  wire [7:0] w_csc_bias1     ;
  wire [7:0] w_csc_bias2     ;
  wire [9:0] w_icsc_coef00   ;
  wire [9:0] w_icsc_coef01   ;
  wire [9:0] w_icsc_coef02   ;
  wire [9:0] w_icsc_coef10   ;
  wire [9:0] w_icsc_coef11   ;
  wire [9:0] w_icsc_coef12   ;
  wire [9:0] w_icsc_coef20   ;
  wire [9:0] w_icsc_coef21   ;
  wire [9:0] w_icsc_coef22   ;
  wire [7:0] w_icsc_bias0    ;
  wire [7:0] w_icsc_bias1    ;
  wire [7:0] w_icsc_bias2    ;
  wire [9:0] w_filter1_coef00;
  wire [9:0] w_filter1_coef01;
  wire [9:0] w_filter1_coef02;
  wire [9:0] w_filter1_coef03;
  wire [9:0] w_filter1_coef04;
  wire [9:0] w_filter1_coef10;
  wire [9:0] w_filter1_coef11;
  wire [9:0] w_filter1_coef12;
  wire [9:0] w_filter1_coef13;
  wire [9:0] w_filter1_coef14;
  wire [9:0] w_filter1_coef20;
  wire [9:0] w_filter1_coef21;
  wire [9:0] w_filter1_coef22;
  wire [9:0] w_filter1_coef23;
  wire [9:0] w_filter1_coef24;
  wire [9:0] w_filter1_coef30;
  wire [9:0] w_filter1_coef31;
  wire [9:0] w_filter1_coef32;
  wire [9:0] w_filter1_coef33;
  wire [9:0] w_filter1_coef34;
  wire [9:0] w_filter1_coef40;
  wire [9:0] w_filter1_coef41;
  wire [9:0] w_filter1_coef42;
  wire [9:0] w_filter1_coef43;
  wire [9:0] w_filter1_coef44;
  wire [9:0] w_filter2_coef00;
  wire [9:0] w_filter2_coef01;
  wire [9:0] w_filter2_coef02;
  wire [9:0] w_filter2_coef03;
  wire [9:0] w_filter2_coef04;
  wire [9:0] w_filter2_coef10;
  wire [9:0] w_filter2_coef11;
  wire [9:0] w_filter2_coef12;
  wire [9:0] w_filter2_coef13;
  wire [9:0] w_filter2_coef14;
  wire [9:0] w_filter2_coef20;
  wire [9:0] w_filter2_coef21;
  wire [9:0] w_filter2_coef22;
  wire [9:0] w_filter2_coef23;
  wire [9:0] w_filter2_coef24;
  wire [9:0] w_filter2_coef30;
  wire [9:0] w_filter2_coef31;
  wire [9:0] w_filter2_coef32;
  wire [9:0] w_filter2_coef33;
  wire [9:0] w_filter2_coef34;
  wire [9:0] w_filter2_coef40;
  wire [9:0] w_filter2_coef41;
  wire [9:0] w_filter2_coef42;
  wire [9:0] w_filter2_coef43;
  wire [9:0] w_filter2_coef44;
  wire       w_csc_bypass    ;
  wire       w_filter1_bypass;
  wire       w_filter2_bypass;
  wire       w_icsc_bypass   ;
  apb_slave u_reg_weight
  (
    .clk             (clk_apb         ), //                  
    .rstn            (rstn_apb        ), //                  
    .i_PADDR         (i_apb_paddr     ), // [ADDR_WIDTH-1:0] 
    .i_PSEL          (i_apb_psel      ), //                  
    .i_PENABLE       (i_apb_penable   ), //                  
    .i_PWRITE        (i_apb_pwrite    ), //                  
    .i_PWDATA        (i_apb_pwdata    ), // [31:0]           
    .o_PREADY        (o_apb_pready    ), //                  
    .o_PRDATA        (o_apb_prdata    ), // [31:0]           
    .o_csc_coef00    (w_csc_coef00    ), // [9:0]            
    .o_csc_coef01    (w_csc_coef01    ), // [9:0]            
    .o_csc_coef02    (w_csc_coef02    ), // [9:0]            
    .o_csc_coef10    (w_csc_coef10    ), // [9:0]            
    .o_csc_coef11    (w_csc_coef11    ), // [9:0]            
    .o_csc_coef12    (w_csc_coef12    ), // [9:0]            
    .o_csc_coef20    (w_csc_coef20    ), // [9:0]            
    .o_csc_coef21    (w_csc_coef21    ), // [9:0]            
    .o_csc_coef22    (w_csc_coef22    ), // [9:0]            
    .o_csc_bias0     (w_csc_bias0     ), // [7:0]            
    .o_csc_bias1     (w_csc_bias1     ), // [7:0]            
    .o_csc_bias2     (w_csc_bias2     ), // [7:0]            
    .o_icsc_coef00   (w_icsc_coef00   ), // [9:0]            
    .o_icsc_coef01   (w_icsc_coef01   ), // [9:0]            
    .o_icsc_coef02   (w_icsc_coef02   ), // [9:0]            
    .o_icsc_coef10   (w_icsc_coef10   ), // [9:0]            
    .o_icsc_coef11   (w_icsc_coef11   ), // [9:0]            
    .o_icsc_coef12   (w_icsc_coef12   ), // [9:0]            
    .o_icsc_coef20   (w_icsc_coef20   ), // [9:0]            
    .o_icsc_coef21   (w_icsc_coef21   ), // [9:0]            
    .o_icsc_coef22   (w_icsc_coef22   ), // [9:0]            
    .o_icsc_bias0    (w_icsc_bias0    ), // [7:0]            
    .o_icsc_bias1    (w_icsc_bias1    ), // [7:0]            
    .o_icsc_bias2    (w_icsc_bias2    ), // [7:0]            
    .o_filter1_coef00(w_filter1_coef00), // [9:0]            
    .o_filter1_coef01(w_filter1_coef01), // [9:0]            
    .o_filter1_coef02(w_filter1_coef02), // [9:0]            
    .o_filter1_coef03(w_filter1_coef03), // [9:0]            
    .o_filter1_coef04(w_filter1_coef04), // [9:0]            
    .o_filter1_coef10(w_filter1_coef10), // [9:0]            
    .o_filter1_coef11(w_filter1_coef11), // [9:0]            
    .o_filter1_coef12(w_filter1_coef12), // [9:0]            
    .o_filter1_coef13(w_filter1_coef13), // [9:0]            
    .o_filter1_coef14(w_filter1_coef14), // [9:0]            
    .o_filter1_coef20(w_filter1_coef20), // [9:0]            
    .o_filter1_coef21(w_filter1_coef21), // [9:0]            
    .o_filter1_coef22(w_filter1_coef22), // [9:0]            
    .o_filter1_coef23(w_filter1_coef23), // [9:0]            
    .o_filter1_coef24(w_filter1_coef24), // [9:0]            
    .o_filter1_coef30(w_filter1_coef30), // [9:0]            
    .o_filter1_coef31(w_filter1_coef31), // [9:0]            
    .o_filter1_coef32(w_filter1_coef32), // [9:0]            
    .o_filter1_coef33(w_filter1_coef33), // [9:0]            
    .o_filter1_coef34(w_filter1_coef34), // [9:0]            
    .o_filter1_coef40(w_filter1_coef40), // [9:0]            
    .o_filter1_coef41(w_filter1_coef41), // [9:0]            
    .o_filter1_coef42(w_filter1_coef42), // [9:0]            
    .o_filter1_coef43(w_filter1_coef43), // [9:0]            
    .o_filter1_coef44(w_filter1_coef44), // [9:0]            
    .o_filter2_coef00(w_filter2_coef00), // [9:0]            
    .o_filter2_coef01(w_filter2_coef01), // [9:0]            
    .o_filter2_coef02(w_filter2_coef02), // [9:0]            
    .o_filter2_coef03(w_filter2_coef03), // [9:0]            
    .o_filter2_coef04(w_filter2_coef04), // [9:0]            
    .o_filter2_coef10(w_filter2_coef10), // [9:0]            
    .o_filter2_coef11(w_filter2_coef11), // [9:0]            
    .o_filter2_coef12(w_filter2_coef12), // [9:0]            
    .o_filter2_coef13(w_filter2_coef13), // [9:0]            
    .o_filter2_coef14(w_filter2_coef14), // [9:0]            
    .o_filter2_coef20(w_filter2_coef20), // [9:0]            
    .o_filter2_coef21(w_filter2_coef21), // [9:0]            
    .o_filter2_coef22(w_filter2_coef22), // [9:0]            
    .o_filter2_coef23(w_filter2_coef23), // [9:0]            
    .o_filter2_coef24(w_filter2_coef24), // [9:0]            
    .o_filter2_coef30(w_filter2_coef30), // [9:0]            
    .o_filter2_coef31(w_filter2_coef31), // [9:0]            
    .o_filter2_coef32(w_filter2_coef32), // [9:0]            
    .o_filter2_coef33(w_filter2_coef33), // [9:0]            
    .o_filter2_coef34(w_filter2_coef34), // [9:0]            
    .o_filter2_coef40(w_filter2_coef40), // [9:0]            
    .o_filter2_coef41(w_filter2_coef41), // [9:0]            
    .o_filter2_coef42(w_filter2_coef42), // [9:0]            
    .o_filter2_coef43(w_filter2_coef43), // [9:0]            
    .o_filter2_coef44(w_filter2_coef44), // [9:0]            
    .o_csc_bypass    (w_csc_bypass    ),
    .o_filter1_bypass(w_filter1_bypass),
    .o_filter2_bypass(w_filter2_bypass),
    .o_icsc_bypass   (w_icsc_bypass   ) 
  );

  wire       w_csc_vs;
  wire       w_csc_hs;
  wire       w_csc_de;
  wire [7:0] w_csc_y;
  wire [7:0] w_csc_u;
  wire [7:0] w_csc_v;
  csc_mat_mul_3x3 
  #(
    .DATA_WIDTH(DATA_WIDTH),
    .COEF_WIDTH(COEF_WIDTH),
    .BIAS_WIDTH(BIAS_WIDTH),
    .RL        (CSC_RL    )
  )
  u_rgb2yuv
  (
    .clk      (clk         ),
    .rstn     (rstn        ),
                        
    .i_bypass (w_csc_bypass),
    .i_coef00 (w_csc_coef00),
    .i_coef01 (w_csc_coef01),
    .i_coef02 (w_csc_coef02),
    .i_coef10 (w_csc_coef10),
    .i_coef11 (w_csc_coef11),
    .i_coef12 (w_csc_coef12),
    .i_coef20 (w_csc_coef20),
    .i_coef21 (w_csc_coef21),
    .i_coef22 (w_csc_coef22),
    .i_bias0  (w_csc_bias0 ),
    .i_bias1  (w_csc_bias1 ),
    .i_bias2  (w_csc_bias2 ),
    .i_vs     (i_vs        ),
    .i_hs     (i_hs        ),
    .i_de     (i_de        ),
    .i_x0     (i_r         ),
    .i_x1     (i_g         ),
    .i_x2     (i_b         ),
    .o_vs     (w_csc_vs    ),
    .o_hs     (w_csc_hs    ),
    .o_de     (w_csc_de    ),
    .o_y0     (w_csc_y     ),
    .o_y1     (w_csc_u     ),
    .o_y2     (w_csc_v     )
  );

  wire       w_filter1_vs;
  wire       w_filter1_hs;
  wire       w_filter1_de;
  wire [7:0] w_filter1_y;
  wire [7:0] w_filter1_u;
  wire [7:0] w_filter1_v;
  filter_top_5x5 
  #(
    .DATA_WIDTH(DATA_WIDTH),
    .COEF_WIDTH(COEF_WIDTH),
    .RL        (FILTER1_RL)
  )
  u_denoise_filter
  (
    .clk      (clk             ),
    .rstn     (rstn            ),
                        
    .i_bypass (w_filter1_bypass),
    .i_coef00 (w_filter1_coef00), // [COEF_WIDTH-1:0] 
    .i_coef01 (w_filter1_coef01), // [COEF_WIDTH-1:0] 
    .i_coef02 (w_filter1_coef02), // [COEF_WIDTH-1:0] 
    .i_coef03 (w_filter1_coef03), // [COEF_WIDTH-1:0] 
    .i_coef04 (w_filter1_coef04), // [COEF_WIDTH-1:0] 
    .i_coef10 (w_filter1_coef10), // [COEF_WIDTH-1:0] 
    .i_coef11 (w_filter1_coef11), // [COEF_WIDTH-1:0] 
    .i_coef12 (w_filter1_coef12), // [COEF_WIDTH-1:0] 
    .i_coef13 (w_filter1_coef13), // [COEF_WIDTH-1:0] 
    .i_coef14 (w_filter1_coef14), // [COEF_WIDTH-1:0] 
    .i_coef20 (w_filter1_coef20), // [COEF_WIDTH-1:0] 
    .i_coef21 (w_filter1_coef21), // [COEF_WIDTH-1:0] 
    .i_coef22 (w_filter1_coef22), // [COEF_WIDTH-1:0] 
    .i_coef23 (w_filter1_coef23), // [COEF_WIDTH-1:0] 
    .i_coef24 (w_filter1_coef24), // [COEF_WIDTH-1:0] 
    .i_coef30 (w_filter1_coef30), // [COEF_WIDTH-1:0] 
    .i_coef31 (w_filter1_coef31), // [COEF_WIDTH-1:0] 
    .i_coef32 (w_filter1_coef32), // [COEF_WIDTH-1:0] 
    .i_coef33 (w_filter1_coef33), // [COEF_WIDTH-1:0] 
    .i_coef34 (w_filter1_coef34), // [COEF_WIDTH-1:0] 
    .i_coef40 (w_filter1_coef40), // [COEF_WIDTH-1:0] 
    .i_coef41 (w_filter1_coef41), // [COEF_WIDTH-1:0] 
    .i_coef42 (w_filter1_coef42), // [COEF_WIDTH-1:0] 
    .i_coef43 (w_filter1_coef43), // [COEF_WIDTH-1:0] 
    .i_coef44 (w_filter1_coef44), // [COEF_WIDTH-1:0] 
    .i_vs     (w_csc_vs        ), //                  
    .i_hs     (w_csc_hs        ), //                  
    .i_de     (w_csc_de        ), //                  
    .i_y      (w_csc_y         ), // [DATA_WIDTH-1:0] 
    .i_u      (w_csc_u         ), // [DATA_WIDTH-1:0] 
    .i_v      (w_csc_v         ), // [DATA_WIDTH-1:0] 
    .o_vs     (w_filter1_vs    ), //                  
    .o_hs     (w_filter1_hs    ), //                  
    .o_de     (w_filter1_de    ), //                  
    .o_y      (w_filter1_y     ), // [DATA_WIDTH-1:0] 
    .o_u      (w_filter1_u     ), // [DATA_WIDTH-1:0] 
    .o_v      (w_filter1_v     )  // [DATA_WIDTH-1:0] 
  );
  filter_top_5x5_new
  #(
    .DATA_WIDTH(DATA_WIDTH),
    .COEF_WIDTH(COEF_WIDTH),
    .RL        (FILTER1_RL)
  )
  u_denoise_filter2
  (
    .clk      (clk             ),
    .rstn     (rstn            ),
                        
    .i_bypass (w_filter1_bypass),
    .i_coef00 (w_filter1_coef00), // [COEF_WIDTH-1:0] 
    .i_coef01 (w_filter1_coef01), // [COEF_WIDTH-1:0] 
    .i_coef02 (w_filter1_coef02), // [COEF_WIDTH-1:0] 
    .i_coef03 (w_filter1_coef03), // [COEF_WIDTH-1:0] 
    .i_coef04 (w_filter1_coef04), // [COEF_WIDTH-1:0] 
    .i_coef10 (w_filter1_coef10), // [COEF_WIDTH-1:0] 
    .i_coef11 (w_filter1_coef11), // [COEF_WIDTH-1:0] 
    .i_coef12 (w_filter1_coef12), // [COEF_WIDTH-1:0] 
    .i_coef13 (w_filter1_coef13), // [COEF_WIDTH-1:0] 
    .i_coef14 (w_filter1_coef14), // [COEF_WIDTH-1:0] 
    .i_coef20 (w_filter1_coef20), // [COEF_WIDTH-1:0] 
    .i_coef21 (w_filter1_coef21), // [COEF_WIDTH-1:0] 
    .i_coef22 (w_filter1_coef22), // [COEF_WIDTH-1:0] 
    .i_coef23 (w_filter1_coef23), // [COEF_WIDTH-1:0] 
    .i_coef24 (w_filter1_coef24), // [COEF_WIDTH-1:0] 
    .i_coef30 (w_filter1_coef30), // [COEF_WIDTH-1:0] 
    .i_coef31 (w_filter1_coef31), // [COEF_WIDTH-1:0] 
    .i_coef32 (w_filter1_coef32), // [COEF_WIDTH-1:0] 
    .i_coef33 (w_filter1_coef33), // [COEF_WIDTH-1:0] 
    .i_coef34 (w_filter1_coef34), // [COEF_WIDTH-1:0] 
    .i_coef40 (w_filter1_coef40), // [COEF_WIDTH-1:0] 
    .i_coef41 (w_filter1_coef41), // [COEF_WIDTH-1:0] 
    .i_coef42 (w_filter1_coef42), // [COEF_WIDTH-1:0] 
    .i_coef43 (w_filter1_coef43), // [COEF_WIDTH-1:0] 
    .i_coef44 (w_filter1_coef44), // [COEF_WIDTH-1:0] 
    .i_vs     (w_csc_vs        ), //                  
    .i_hs     (w_csc_hs        ), //                  
    .i_de     (w_csc_de        ), //                  
    .i_y      (w_csc_y         ), // [DATA_WIDTH-1:0] 
    .i_u      (w_csc_u         ), // [DATA_WIDTH-1:0] 
    .i_v      (w_csc_v         )  // [DATA_WIDTH-1:0] 
  );

  wire       w_filter2_vs;
  wire       w_filter2_hs;
  wire       w_filter2_de;
  wire [7:0] w_filter2_y;
  wire [7:0] w_filter2_u;
  wire [7:0] w_filter2_v;
  filter_top_5x5 u_sharpness_filter
  (
    .clk      (clk             ),
    .rstn     (rstn            ),

    .i_bypass (w_filter2_bypass),
    .i_coef00 (w_filter2_coef00), // [COEF_WIDTH-1:0] 
    .i_coef01 (w_filter2_coef01), // [COEF_WIDTH-1:0] 
    .i_coef02 (w_filter2_coef02), // [COEF_WIDTH-1:0] 
    .i_coef03 (w_filter2_coef03), // [COEF_WIDTH-1:0] 
    .i_coef04 (w_filter2_coef04), // [COEF_WIDTH-1:0] 
    .i_coef10 (w_filter2_coef10), // [COEF_WIDTH-1:0] 
    .i_coef11 (w_filter2_coef11), // [COEF_WIDTH-1:0] 
    .i_coef12 (w_filter2_coef12), // [COEF_WIDTH-1:0] 
    .i_coef13 (w_filter2_coef13), // [COEF_WIDTH-1:0] 
    .i_coef14 (w_filter2_coef14), // [COEF_WIDTH-1:0] 
    .i_coef20 (w_filter2_coef20), // [COEF_WIDTH-1:0] 
    .i_coef21 (w_filter2_coef21), // [COEF_WIDTH-1:0] 
    .i_coef22 (w_filter2_coef22), // [COEF_WIDTH-1:0] 
    .i_coef23 (w_filter2_coef23), // [COEF_WIDTH-1:0] 
    .i_coef24 (w_filter2_coef24), // [COEF_WIDTH-1:0] 
    .i_coef30 (w_filter2_coef30), // [COEF_WIDTH-1:0] 
    .i_coef31 (w_filter2_coef31), // [COEF_WIDTH-1:0] 
    .i_coef32 (w_filter2_coef32), // [COEF_WIDTH-1:0] 
    .i_coef33 (w_filter2_coef33), // [COEF_WIDTH-1:0] 
    .i_coef34 (w_filter2_coef34), // [COEF_WIDTH-1:0] 
    .i_coef40 (w_filter2_coef40), // [COEF_WIDTH-1:0] 
    .i_coef41 (w_filter2_coef41), // [COEF_WIDTH-1:0] 
    .i_coef42 (w_filter2_coef42), // [COEF_WIDTH-1:0] 
    .i_coef43 (w_filter2_coef43), // [COEF_WIDTH-1:0] 
    .i_coef44 (w_filter2_coef44), // [COEF_WIDTH-1:0] 
    .i_vs     (w_filter1_vs    ), //                  
    .i_hs     (w_filter1_hs    ), //                  
    .i_de     (w_filter1_de    ), //                  
    .i_y      (w_filter1_y     ), // [DATA_WIDTH-1:0] 
    .i_u      (w_filter1_u     ), // [DATA_WIDTH-1:0] 
    .i_v      (w_filter1_v     ), // [DATA_WIDTH-1:0] 
    .o_vs     (w_filter2_vs    ), //                  
    .o_hs     (w_filter2_hs    ), //                  
    .o_de     (w_filter2_de    ), //                  
    .o_y      (w_filter2_y     ), // [DATA_WIDTH-1:0] 
    .o_u      (w_filter2_u     ), // [DATA_WIDTH-1:0] 
    .o_v      (w_filter2_v     )  // [DATA_WIDTH-1:0] 
  );

  icsc_mat_mul_3x3 u_yuv2rgb
  (
    .clk      (clk         ),
    .rstn     (rstn        ),
                        
    .i_bypass (w_icsc_bypass),
    .i_coef00 (w_icsc_coef00),
    .i_coef01 (w_icsc_coef01),
    .i_coef02 (w_icsc_coef02),
    .i_coef10 (w_icsc_coef10),
    .i_coef11 (w_icsc_coef11),
    .i_coef12 (w_icsc_coef12),
    .i_coef20 (w_icsc_coef20),
    .i_coef21 (w_icsc_coef21),
    .i_coef22 (w_icsc_coef22),
    .i_bias0  (w_icsc_bias0 ),
    .i_bias1  (w_icsc_bias1 ),
    .i_bias2  (w_icsc_bias2 ),
    .i_vs     (w_filter2_vs ),
    .i_hs     (w_filter2_hs ),
    .i_de     (w_filter2_de ),
    .i_x0     (w_filter2_y  ),
    .i_x1     (w_filter2_u  ),
    .i_x2     (w_filter2_v  ),
    .o_vs     (o_vs         ),
    .o_hs     (o_hs         ),
    .o_de     (o_de         ),
    .o_y0     (o_r          ),
    .o_y1     (o_g          ),
    .o_y2     (o_b          )
  );
endmodule
