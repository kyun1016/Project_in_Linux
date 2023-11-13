
// ./pkg_tx_sequencer.sv

class cls_sequencer;
  virtual itf_data m_itf;

  function new(
    virtual itf_data i_itf
  );
    m_itf = i_itf;
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
    int i_hfp
  );
    -> m_itf.evt_hs;
    m_itf.i_hs = 1;
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
    int i_hfp
  );
    -> m_itf.evt_hs;
    m_itf.i_hs = 1;
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
    int i_hbp,
    int i_hfp
  );
    -> m_itf.evt_vs;
    m_itf.i_vs = 1;
    send_line_dummy(i_hbp, i_hfp);
    m_itf.i_vs = 0;
    
    repeat(i_vbp)
      send_line_dummy(i_hbp, i_hfp);
    for(m_itf.cnt_line=0; m_itf.cnt_line<m_itf.HEIGHT; ++m_itf.cnt_line)
      send_line(i_hbp, i_hfp);
    repeat(i_vfp)
      send_line_dummy(i_hbp, i_hfp);
  endtask


  task apb_write(
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



endclass
