
// ./pkg_tx_sequencer.sv

class cls_sequencer;
  localparam CSC_COEF0      = 8'h00;
  localparam CSC_COEF1      = 8'h04;
  localparam CSC_COEF2      = 8'h08;
  localparam CSC_BIAS       = 8'h0C;
  localparam ICSC_COEF0     = 8'h10;
  localparam ICSC_COEF1     = 8'h14;
  localparam ICSC_COEF2     = 8'h18;
  localparam ICSC_BIAS      = 8'h1C;
  localparam FILTER1_COEF00 = 8'h20;
  localparam FILTER1_COEF03 = 8'h24;
  localparam FILTER1_COEF10 = 8'h28;
  localparam FILTER1_COEF13 = 8'h2C;
  localparam FILTER1_COEF20 = 8'h30;
  localparam FILTER1_COEF23 = 8'h34;
  localparam FILTER1_COEF30 = 8'h38;
  localparam FILTER1_COEF33 = 8'h3C;
  localparam FILTER1_COEF40 = 8'h40;
  localparam FILTER1_COEF43 = 8'h44;
  localparam FILTER2_COEF00 = 8'h48;
  localparam FILTER2_COEF03 = 8'h4C;
  localparam FILTER2_COEF10 = 8'h50;
  localparam FILTER2_COEF13 = 8'h54;
  localparam FILTER2_COEF20 = 8'h58;
  localparam FILTER2_COEF23 = 8'h5C;
  localparam FILTER2_COEF30 = 8'h60;
  localparam FILTER2_COEF33 = 8'h64;
  localparam FILTER2_COEF40 = 8'h68;
  localparam FILTER2_COEF43 = 8'h6C;
  localparam BYPASS         = 8'h70;

  virtual itf_data m_itf;

  function new(
    virtual itf_data i_itf
  );
    m_itf = i_itf;
    m_itf.i_vs = 0;
    m_itf.i_hs = 0;
    m_itf.i_de = 0;
    m_itf.i_r  = 0;
    m_itf.i_g  = 0;
    m_itf.i_b  = 0;
  endfunction

  task send_pixel();
    m_itf.i_de = 1;
    m_itf.i_r = m_itf.frame_r[m_itf.cnt_line][m_itf.cnt_ch];
    m_itf.i_g = m_itf.frame_g[m_itf.cnt_line][m_itf.cnt_ch];
    m_itf.i_b = m_itf.frame_b[m_itf.cnt_line][m_itf.cnt_ch];
    @(negedge m_itf.clk);
    m_itf.i_de = 0;
  endtask

  task send_pixel_dummy();
    m_itf.i_de = 0;
    m_itf.i_r = 0;
    m_itf.i_g = 0;
    m_itf.i_b = 0;
    @(negedge m_itf.clk);
  endtask

  task send_line(
    int i_hbp,
    int i_hfp,
		int i_hsy
  );
    -> m_itf.evt_hs;
		m_itf.i_hs = 1;
		repeat(i_hsy)
		  @(negedge m_itf.clk);
    m_itf.i_hs = 0;
    repeat(i_hbp)
      send_pixel_dummy();
    for(m_itf.cnt_ch=0; m_itf.cnt_ch<m_itf.WIDTH; ++m_itf.cnt_ch)
      send_pixel();
    repeat(i_hfp)
      send_pixel_dummy();
  endtask

  task send_line_dummy(
    int i_hbp,
    int i_hfp,
    int i_hsy
  );
    -> m_itf.evt_hs;
    m_itf.i_hs = 1;
    repeat(i_hsy)
      @(negedge m_itf.clk);
    m_itf.i_hs = 0;
    repeat(i_hbp)
      send_pixel_dummy();
    for(m_itf.cnt_ch=0; m_itf.cnt_ch<m_itf.WIDTH; ++m_itf.cnt_ch)
      send_pixel_dummy();
    repeat(i_hfp)
      send_pixel_dummy();
  endtask

  task send_frame(
    int i_vbp,
    int i_vfp,
		int i_vsy,
    int i_hbp,
    int i_hfp,
		int i_hsy
  );
    -> m_itf.evt_vs;
    m_itf.i_vs = 1;
    repeat(i_vsy)
      send_line_dummy(i_hbp, i_hfp, i_hsy);
    m_itf.i_vs = 0;
    
    repeat(i_vbp)
      send_line_dummy(i_hbp, i_hfp, i_hsy);
    for(m_itf.cnt_line=0; m_itf.cnt_line<m_itf.HEIGHT; ++m_itf.cnt_line)
      send_line(i_hbp, i_hfp, i_hsy);
    repeat(i_vfp)
      send_line_dummy(i_hbp, i_hfp, i_hsy);
  endtask


  task write_apb(
    int i_addr,
    int i_data
  );
    m_itf.i_apb_addr      = i_addr;
    m_itf.i_apb_data      = i_data;
    m_itf.i_apb_sel       = 1;
    m_itf.i_apb_write_trg = 1;
    m_itf.i_apb_wait      = 0;
    @(negedge m_itf.clk_apb);
    m_itf.i_apb_write_trg = 0;
    @(negedge m_itf.clk_apb);
    @(negedge m_itf.clk_apb);
    @(negedge m_itf.clk_apb);
    m_itf.i_apb_sel       = 0;
  endtask

  task write_apb_all();
    int addr;
    int data;
    for(int i=0;i<40;++i) begin
      addr = i*4;
      case(addr)
        CSC_COEF0      : data = {2'b0 , m_itf.csc_coef[0][2]    , m_itf.csc_coef[0][1]    , m_itf.csc_coef[0][0] };
        CSC_COEF1      : data = {2'b0 , m_itf.csc_coef[1][2]    , m_itf.csc_coef[1][1]    , m_itf.csc_coef[1][0] };
        CSC_COEF2      : data = {2'b0 , m_itf.csc_coef[2][2]    , m_itf.csc_coef[2][1]    , m_itf.csc_coef[2][0] };
        CSC_BIAS       : data = {8'b0 , m_itf.csc_bias[2]       , m_itf.csc_bias[1]       , m_itf.csc_bias[0]    };
        ICSC_COEF0     : data = {2'b0 , m_itf.icsc_coef[0][2]   , m_itf.icsc_coef[0][1]   , m_itf.icsc_coef[0][0]};
        ICSC_COEF1     : data = {2'b0 , m_itf.icsc_coef[1][2]   , m_itf.icsc_coef[1][1]   , m_itf.icsc_coef[1][0]};
        ICSC_COEF2     : data = {2'b0 , m_itf.icsc_coef[2][2]   , m_itf.icsc_coef[2][1]   , m_itf.icsc_coef[2][0]};
        ICSC_BIAS      : data = {8'b0 , m_itf.icsc_bias[2]      , m_itf.icsc_bias[1]      , m_itf.icsc_bias[0]   };
        FILTER1_COEF00 : data = {2'b0 , m_itf.filter1_coef[0][2], m_itf.filter1_coef[0][1], m_itf.filter1_coef[0][0]};
        FILTER1_COEF03 : data = {12'b0, m_itf.filter1_coef[0][4], m_itf.filter1_coef[0][3]};
        FILTER1_COEF10 : data = {2'b0 , m_itf.filter1_coef[1][2], m_itf.filter1_coef[1][1], m_itf.filter1_coef[1][0]};
        FILTER1_COEF13 : data = {12'b0, m_itf.filter1_coef[1][4], m_itf.filter1_coef[1][3]};
        FILTER1_COEF20 : data = {2'b0 , m_itf.filter1_coef[2][2], m_itf.filter1_coef[2][1], m_itf.filter1_coef[2][0]};
        FILTER1_COEF23 : data = {12'b0, m_itf.filter1_coef[2][4], m_itf.filter1_coef[2][3]};
        FILTER1_COEF30 : data = {2'b0 , m_itf.filter1_coef[3][2], m_itf.filter1_coef[3][1], m_itf.filter1_coef[3][0]};
        FILTER1_COEF33 : data = {12'b0, m_itf.filter1_coef[3][4], m_itf.filter1_coef[3][3]};
        FILTER1_COEF40 : data = {2'b0 , m_itf.filter1_coef[4][2], m_itf.filter1_coef[4][1], m_itf.filter1_coef[4][0]};
        FILTER1_COEF43 : data = {12'b0, m_itf.filter1_coef[4][4], m_itf.filter1_coef[4][3]};
        FILTER2_COEF00 : data = {2'b0 , m_itf.filter2_coef[0][2], m_itf.filter2_coef[0][1], m_itf.filter2_coef[0][0]};
        FILTER2_COEF03 : data = {12'b0, m_itf.filter2_coef[0][4], m_itf.filter2_coef[0][3]};
        FILTER2_COEF10 : data = {2'b0 , m_itf.filter2_coef[1][2], m_itf.filter2_coef[1][1], m_itf.filter2_coef[1][0]};
        FILTER2_COEF13 : data = {12'b0, m_itf.filter2_coef[1][4], m_itf.filter2_coef[1][3]};
        FILTER2_COEF20 : data = {2'b0 , m_itf.filter2_coef[2][2], m_itf.filter2_coef[2][1], m_itf.filter2_coef[2][0]};
        FILTER2_COEF23 : data = {12'b0, m_itf.filter2_coef[2][4], m_itf.filter2_coef[2][3]};
        FILTER2_COEF30 : data = {2'b0 , m_itf.filter2_coef[3][2], m_itf.filter2_coef[3][1], m_itf.filter2_coef[3][0]};
        FILTER2_COEF33 : data = {12'b0, m_itf.filter2_coef[3][4], m_itf.filter2_coef[3][3]};
        FILTER2_COEF40 : data = {2'b0 , m_itf.filter2_coef[4][2], m_itf.filter2_coef[4][1], m_itf.filter2_coef[4][0]};
        FILTER2_COEF43 : data = {12'b0, m_itf.filter2_coef[4][4], m_itf.filter2_coef[4][3]};
        BYPASS         : data = {28'b0, m_itf.icsc_bypass       , m_itf.filter2_bypass    , m_itf.filter1_bypass,     m_itf.csc_bypass};
        default        : data = 32'b0;
      endcase
      write_apb(addr, data);
    end

  endtask

endclass
