
// ./pkg_tx_data.sv

class cls_read_ppm;
  virtual itf_data m_itf;
  integer fp, count;

  function new(
    virtual itf_data i_itf
  );
    m_itf = i_itf;
  endfunction

  function void set_fp(
    string file_name
  );
    string dummy;
    int dummy1;

    $fclose(fp);
    fp = $fopen(file_name, "r");
    count = $fscanf(fp, "%s\n", dummy);
    count = $fscanf(fp, "%d %d\n", m_itf.WIDTH, m_itf.HEIGHT);
    count = $fscanf(fp, "%d\n", dummy1);
  endfunction

  function void set_pixel();
    count = $fscanf(fp, "%d %d %d\n", m_itf.i_r, m_itf.i_g, m_itf.i_b);
  endfunction

  function void set_line();
    for(int i=0; i<m_itf.WIDTH; ++i)
      count = $fscanf(fp, "%d %d %d\n", m_itf.line_r[i], m_itf.line_g[i], m_itf.line_b[i]);
  endfunction

  function void set_frame();
    for(int i=0; i<m_itf.HEIGHT; ++i)
      for(int j=0; j<m_itf.WIDTH; ++j) begin
        count = $fscanf(fp, "%d %d %d\n", m_itf.frame_r[i][j], m_itf.frame_g[i][j], m_itf.frame_b[i][j]);
        // $display("[%d] %d %d %d", count, m_itf.frame_r[i][j], m_itf.frame_g[i][j], m_itf.frame_b[i][j]);
      end
  endfunction
endclass
