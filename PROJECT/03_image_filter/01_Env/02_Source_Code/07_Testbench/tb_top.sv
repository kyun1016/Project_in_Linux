// ./list_testbench.f

// ../04_TX_Model/01_class/01_data/pkg_tx_data.sv
// ../04_TX_Model/01_class/01_data/cls_link.sv
import pkg_tx_data::cls_read_ppm;
// ../04_TX_Model/01_class/03_sequencer/pkg_tx_sequencer.sv
// ../04_TX_Model/01_class/03_sequencer/cls_sequencer.sv
import pkg_tx_sequencer::cls_sequencer;

module tb_top
#(
  parameter SEL_WIDTH       = 4   , 
  parameter ADDR_WIDTH      = 10  , // maximum width 32 bits
  parameter DATA_WIDTH      = 8     // 8/16/32 bits wide
)();
  localparam
    VBP        = 3,
    VFP        = 3,
    HBP        = 3,
    HFP        = 3;
  reg clk;
  reg rstn;
  reg clk_apb;
  reg rstn_apb;

  itf_data m_itf(
    .clk      (clk     ),
    .rstn     (rstn    ),
    .clk_apb  (clk_apb ),
    .rstn_apb (rstn_apb)
  );

  cls_read_ppm r_ppm = new(m_itf);
  cls_sequencer sequencer = new(m_itf);

  initial begin : clk_reset_control
    clk  = 0;
    rstn = 1;
    clk_apb = 0;
    rstn_apb = 1;
    fork
      forever #5 clk = ~clk;
      forever #8 clk_apb = ~clk_apb;
      begin
        #10   rstn = 0;
        #1000 rstn = 1;
      end
      begin
        #10   rstn_apb = 0;
        #1000 rstn_apb = 1;
      end
    join
  end

  initial begin : fsdb_control
    $fsdbDumpfile("./03_fsdb/waveform.fsdb");
    $fsdbDumpvars(0,tb_top);
  end

  initial begin : main
    r_ppm.set_fp("/home/park/Project_in_Linux/PROJECT/03_image_filter/01_Env/02_Source_Code/08_Stimulus/02_ppm/H_RAMP_PIXEL.ppm");
    r_ppm.set_frame();

    @(posedge rstn_apb);

    sequencer.apb_write(
      .i_addr(0),
      .i_data(10)
    );

    repeat(1)
      sequencer.send_frame(
        .i_vbp(VBP),
        .i_vfp(VFP),
        .i_hbp(HBP),
        .i_hfp(HFP)
      );

    repeat(1000)
      @(posedge clk);
    $finish;
  end

  apb_master u_apb_master
  (
    .clk            (m_itf.clk_apb        ), // clock signal. 
    .rstn           (m_itf.rstn_apb       ),
    .i_addr         (m_itf.i_apb_addr     ),
    .i_data         (m_itf.i_apb_data     ),
    .i_wait         (m_itf.i_apb_wait     ),
    .i_write_trg    (m_itf.i_apb_write_trg),
    .i_read_trg     (m_itf.i_apb_read_trg ),
    .i_sel          (m_itf.i_apb_sel      ),
    .o_PADDR        (m_itf.o_apb_PADDR    ), // APB address bus
    .o_PSEL         (m_itf.o_apb_PSEL     ), // Select
    .o_PENABLE      (m_itf.o_apb_PENABLE  ), // Enable
    .o_PWRITE       (m_itf.o_apb_PWRITE   ), // Direction
    .o_PWDATA       (m_itf.o_apb_PWDATA   )  // Write data (PWRITE is HIGH)
  );

  rtl_top u_rtl_top
  (
    .clk            (m_itf.clk          ),
    .rstn           (m_itf.rstn         ),
    .clk_apb        (m_itf.clk_apb      ),
    .rstn_apb       (m_itf.rstn_apb     ),
    .i_apb_paddr    (m_itf.o_apb_PADDR  ), // [ADDR_WIDTH-1:0] 
    .i_apb_psel     (m_itf.o_apb_PSEL   ), //                  
    .i_apb_penable  (m_itf.o_apb_PENABLE), //                  
    .i_apb_pwrite   (m_itf.o_apb_PWRITE ), //                  
    .i_apb_pwdata   (m_itf.o_apb_PWDATA ), // [31:0]           
    .i_vs           (m_itf.i_vs         ), //                  
    .i_hs           (m_itf.i_hs         ), //                  
    .i_de           (m_itf.i_de         ), //                  
    .i_r            (m_itf.i_r          ), // [DATA_WIDTH-1:0] 
    .i_g            (m_itf.i_g          ), // [DATA_WIDTH-1:0] 
    .i_b            (m_itf.i_b          ), // [DATA_WIDTH-1:0] 
    .o_vs           (m_itf.o_vs         ), //                  
    .o_hs           (m_itf.o_hs         ), //                  
    .o_de           (m_itf.o_de         ), //                  
    .o_r            (m_itf.o_r          ), // [DATA_WIDTH-1:0] 
    .o_g            (m_itf.o_g          ), // [DATA_WIDTH-1:0] 
    .o_b            (m_itf.o_b          )  // [DATA_WIDTH-1:0] 
  );

endmodule

