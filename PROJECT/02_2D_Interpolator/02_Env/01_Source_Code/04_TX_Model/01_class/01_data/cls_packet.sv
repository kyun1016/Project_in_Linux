//=============================================
// Designer : Park Seung Kyun
// E-mail : psg9710@naver.com
// Data : 2023-09-10
//=============================================

class cls_packet;
  virtual itf_data m_itf;

  function new(
    virtual itf_data i_itf
  )
  (
    m_itf = i_itf;
  );

  pure virtual task get_pattern();

  task send_pattern();
  begin
    for(int i=0; i<10; i=i+1) begin
      @(posedge m_itf.clk)
      m_itf.dp = m_itf.data_send[i];
      m_itf.dn = ~m_itf.data_send[i];
    end
  end
  endtask
endclass
