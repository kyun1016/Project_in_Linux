//=============================================
// Designer : Park Seung Kyun
// E-mail : psg9710@naver.com
// Data : 2023-09-10
//=============================================

class cls_k_symbol;
  virtual itf_data m_itf;

  function new(
    virtual itf_data i_itf
  );
  begin
    m_itf = i_itf;
  end
  endfunction

endclass
