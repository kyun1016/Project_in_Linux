
// ./pkg_tx_data.sv

class cls_apb;
  virtual itf_data m_itf;

  function new(
    virtual itf_data i_itf
  );
    m_itf = i_itf;
  endfunction

  function void read_csc_coef(
    string file_name
  );
    integer fp, count;

    fp = $fopen(file_name, "r");
    count = $fscanf(fp, "%d %d %d\n", m_itf.csc_coef[0][0], m_itf.csc_coef[0][1], m_itf.csc_coef[0][2]);
    count = $fscanf(fp, "%d %d %d\n", m_itf.csc_coef[1][0], m_itf.csc_coef[1][1], m_itf.csc_coef[1][2]);
    count = $fscanf(fp, "%d %d %d\n", m_itf.csc_coef[2][0], m_itf.csc_coef[2][1], m_itf.csc_coef[2][2]);
    $fclose(fp);
  endfunction
  function void read_icsc_coef(
    string file_name
  );
    integer fp, count;

    fp = $fopen(file_name, "r");
    count = $fscanf(fp, "%d %d %d\n", m_itf.icsc_coef[0][0], m_itf.icsc_coef[0][1], m_itf.icsc_coef[0][2]);
    count = $fscanf(fp, "%d %d %d\n", m_itf.icsc_coef[1][0], m_itf.icsc_coef[1][1], m_itf.icsc_coef[1][2]);
    count = $fscanf(fp, "%d %d %d\n", m_itf.icsc_coef[2][0], m_itf.icsc_coef[2][1], m_itf.icsc_coef[2][2]);
    $fclose(fp);
  endfunction
  function void read_filter1_coef(
    string file_name
  );
    integer fp, count;

    fp = $fopen(file_name, "r");
    count = $fscanf(fp, "%d %d %d %d %d\n", m_itf.filter1_coef[0][0], m_itf.filter1_coef[0][1], m_itf.filter1_coef[0][2], m_itf.filter1_coef[0][3], m_itf.filter1_coef[0][4]);
    count = $fscanf(fp, "%d %d %d %d %d\n", m_itf.filter1_coef[0][0], m_itf.filter1_coef[1][1], m_itf.filter1_coef[1][2], m_itf.filter1_coef[1][3], m_itf.filter1_coef[1][4]);
    count = $fscanf(fp, "%d %d %d %d %d\n", m_itf.filter1_coef[0][0], m_itf.filter1_coef[2][1], m_itf.filter1_coef[2][2], m_itf.filter1_coef[2][3], m_itf.filter1_coef[2][4]);
    count = $fscanf(fp, "%d %d %d %d %d\n", m_itf.filter1_coef[0][0], m_itf.filter1_coef[3][1], m_itf.filter1_coef[3][2], m_itf.filter1_coef[3][3], m_itf.filter1_coef[3][4]);
    count = $fscanf(fp, "%d %d %d %d %d\n", m_itf.filter1_coef[0][0], m_itf.filter1_coef[4][1], m_itf.filter1_coef[4][2], m_itf.filter1_coef[4][3], m_itf.filter1_coef[4][4]);
    $fclose(fp);
  endfunction

  function void read_filter2_coef(
    string file_name
  );
    integer fp, count;

    fp = $fopen(file_name, "r");
    count = $fscanf(fp, "%d %d %d %d %d\n", m_itf.filter2_coef[0][0], m_itf.filter2_coef[0][1], m_itf.filter2_coef[0][2], m_itf.filter2_coef[0][3], m_itf.filter2_coef[0][4]);
    count = $fscanf(fp, "%d %d %d %d %d\n", m_itf.filter2_coef[0][0], m_itf.filter2_coef[1][1], m_itf.filter2_coef[1][2], m_itf.filter2_coef[1][3], m_itf.filter2_coef[1][4]);
    count = $fscanf(fp, "%d %d %d %d %d\n", m_itf.filter2_coef[0][0], m_itf.filter2_coef[2][1], m_itf.filter2_coef[2][2], m_itf.filter2_coef[2][3], m_itf.filter2_coef[2][4]);
    count = $fscanf(fp, "%d %d %d %d %d\n", m_itf.filter2_coef[0][0], m_itf.filter2_coef[3][1], m_itf.filter2_coef[3][2], m_itf.filter2_coef[3][3], m_itf.filter2_coef[3][4]);
    count = $fscanf(fp, "%d %d %d %d %d\n", m_itf.filter2_coef[0][0], m_itf.filter2_coef[4][1], m_itf.filter2_coef[4][2], m_itf.filter2_coef[4][3], m_itf.filter2_coef[4][4]);
    $fclose(fp);
  endfunction
endclass
