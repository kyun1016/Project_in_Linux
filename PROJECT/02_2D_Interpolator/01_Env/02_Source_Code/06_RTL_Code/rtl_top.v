// ./list_rtl.f

module rtl_top
#(
  parameter SEL_WIDTH       = 4   , 
  parameter ADDR_WIDTH      = 10  , // maximum width 32 bits
  parameter DATA_WIDTH      = 8   , // 8/16/32 bits wide
  parameter USER_REQ_WIDTH  = 4   , // maximum width of 128 bits
  parameter USER_DATA_WIDTH = 4   , // maximum width of DATA_WIDTH/2
  parameter USER_RESP_WIDTH = 4     // maximum width of 16 bits
)
(
  input                   clk             ,
  input                   rstn            ,
  input                   clk_apb         ,
  input                   rstn_apb        ,

  input  [ADDR_WIDTH-1:0] i_apb_addr      ,
  input  [DATA_WIDTH-1:0] i_apb_data      ,
  input                   i_apb_wait      ,
  input                   i_apb_write_trg ,
  input                   i_apb_read_trg  ,
  input  [SEL_WIDTH-1:0]  i_apb_sel       ,
  input  [7:0]            i_x             ,
  output [9:0]            o_y             
);
  wire [ADDR_WIDTH-1:0]      w_PADDR   ; // APB address bus
  wire [2:0]                 w_PPROT   ; // Protection type (normal, privileged, secure)
  wire                       w_PNSE    ; // Extension to protection type
  wire [SEL_WIDTH-1:0]       w_PSEL    ; // Select
  wire                       w_PENABLE ; // Enable
  wire                       w_PWRITE  ; // Direction
  wire [DATA_WIDTH-1:0]      w_PWDATA  ; // Write data (PWRITE is HIGH)
  wire [DATA_WIDTH/8:0]      w_PSTRB   ; // indicateds which byte lanes to update during a write transfer
  wire                       w_PSLAVERR; // (option) can be asserted HIGH by the Completer
  wire                       w_PWAKEUP ; // indicateds any activvity associated with an APB interface
  wire                       w_PREADY  ; // used to extend an APB transfer by the Completer
  wire [DATA_WIDTH-1:0]      w_PRDATA  ; // Read data (PWRITE is LOW)
  wire [USER_REQ_WIDTH-1:0]  w_PAUSER  ; // User request attribute
  wire [USER_DATA_WIDTH-1:0] w_PWUSER  ; // User write data attribute
  wire [USER_DATA_WIDTH-1:0] w_PRUSER  ; // User read data attribute
  wire [USER_RESP_WIDTH-1:0] w_PBUSER  ; // User response attribute
  apb_master u_apb_master
  (
    .clk        (clk_apb        ), // clock signal. 
    .rstn       (rstn_apb       ),
    .i_addr     (i_apb_addr     ),
    .i_data     (i_apb_data     ),
    .i_wait     (i_apb_wait     ),
    .i_write_trg(i_apb_write_trg),
    .i_read_trg (i_apb_read_trg ),
    .i_sel      (i_apb_sel      ),
                            
    .o_PADDR    (w_PADDR        ), // APB address bus
    .o_PPROT    (w_PPROT        ), // Protection type (normal, privileged, secure)
    .o_PNSE     (w_PNSE         ), // Extension to protection type
    .o_PSEL     (w_PSEL         ), // Select
    .o_PENABLE  (w_PENABLE      ), // Enable
    .o_PWRITE   (w_PWRITE       ), // Direction
    .o_PWDATA   (w_PWDATA       ), // Write data (PWRITE is HIGH)
    .o_PSTRB    (w_PSTRB        ), // indicateds which byte lanes to update during a write transfer
    .o_PSLAVERR (w_PSLAVERR     ), // (option) can be asserted HIGH by the Completer
    .o_PWAKEUP  (w_PWAKEUP      ), // indicateds any activvity associated with an APB interface
    .o_PREADY   (w_PREADY       ), // used to extend an APB transfer by the Completer
    .o_PRDATA   (w_PRDATA       ), // Read data (PWRITE is LOW)
    .o_PAUSER   (w_PAUSER       ), // User request attribute
    .o_PWUSER   (w_PWUSER       ), // User write data attribute
    .o_PRUSER   (w_PRUSER       ), // User read data attribute
    .o_PBUSER   (w_PBUSER       )  // User response attribute
  );

  wire [9:0] w_weight0;
  wire [9:0] w_weight1;
  wire [9:0] w_weight2;
  wire [9:0] w_weight3;
  wire [9:0] w_weight4;
  wire [9:0] w_weight5;
  wire [9:0] w_weight6;
  wire [9:0] w_weight7;
  apb_slave u_reg_weight
  (
    .clk      (clk_apb  ), // clock signal. 
    .rstn     (rstn_apb ),
    .i_PADDR  (w_PADDR  ), // APB address bus
    .i_PSEL   (w_PSEL   ), // Select
    .i_PENABLE(w_PENABLE), // Enable
    .i_PWRITE (w_PWRITE ), // Direction
    .i_PWDATA (w_PWDATA ), // Write data (PWRITE is HIGH)
    .i_PREADY (w_PREADY ), // used to extend an APB transfer by the Completer
    .o_PRDATA (w_PRDATA ), // Write data (PWRITE is HIGH)
    .o_weight0(w_weight0),
    .o_weight1(w_weight1),
    .o_weight2(w_weight2),
    .o_weight3(w_weight3),
    .o_weight4(w_weight4),
    .o_weight5(w_weight5),
    .o_weight6(w_weight6),
    .o_weight7(w_weight7) 
  );
  linear_interpolator_2d u_linear_interpolator_2d
  (
    .clk      (clk      ),
    .rstn     (rstn     ),
                        
    .i_en     (i_en     ),
    .i_x      (i_x      ),
    .i_weight0(w_weight0),
    .i_weight1(w_weight1),
    .i_weight2(w_weight2),
    .i_weight3(w_weight3),
    .i_weight4(w_weight4),
    .i_weight5(w_weight5),
    .i_weight6(w_weight6),
    .i_weight7(w_weight7),
                        
    .o_y      (o_y      )
  );

endmodule
