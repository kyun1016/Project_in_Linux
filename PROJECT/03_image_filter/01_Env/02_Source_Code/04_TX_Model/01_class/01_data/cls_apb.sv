
// ./pkg_tx_data.sv

class cls_apb;
  virtual itf_data m_itf;

  function new(
    virtual itf_data i_itf
  );
    m_itf = i_itf;
  endfunction

endclass
