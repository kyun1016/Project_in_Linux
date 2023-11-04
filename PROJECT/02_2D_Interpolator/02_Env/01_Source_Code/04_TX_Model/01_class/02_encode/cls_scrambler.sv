//=============================================
// Designer : Park Seung Kyun
// E-mail : psg9710@naver.com
// Data : 2023-09-10
//=============================================

class cls_scrambler 
#(
  parameter LFSR_SIZE = 10
);
  virtual itf_tx m_itf;

  function new(
    virtual itf_tx i_itf_tx,
    logic [LFSR_SIZE-1:0] i_reset_value,
    logic [LFSR_SIZE-1:0] i_xor_pos
  );
  begin
    m_itf = i_itf_tx;
    m_itf.lfsr_reset_value = i_reset_value;
    m_itf.lfsr = i_reset_value;
    m_itf.lfsr_xor_pos = i_xor_pos;
  end
  endfunction

  task reset();
  begin
    m_itf.lfsr = m_itf.lfsr_reset_value;
  end
  endtask

  task oper();
  begin
    logic [LFSR_SIZE-1:0] n_lfsr;

    // Step 1. XOR Operation
    n_lfsr[0] = 0;
    for (int i=0;i<LFSR_SIZE;i=i+1) begin
      if(m_itf.lfsr_xor_pos[i])
        n_lfsr[0] = n_lfsr[0] ^ m_itf.lfsr[i];
    end
    
    // Step 2. Shift Operation
    for (int i=1;i<LFSR_SIZE;i=i+1) begin
      n_lfsr[i] = m_itf.lfsr[i-1];
    end

    // Step 3. 
    m_itf.lfsr = n_lfsr;
  end
  endtask

endclass
