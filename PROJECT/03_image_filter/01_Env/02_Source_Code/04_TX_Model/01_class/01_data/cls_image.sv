//=============================================
// Designer : Park Seung Kyun
// E-mail : psg9710@naver.com
// Data : 2023-09-10
//=============================================

class cls_image;
  localparam BLACK        = 0 ;
  localparam RED          = 1 ;
  localparam GREEN        = 2 ;
  localparam YELLOW       = 3 ;
  localparam BLUE         = 4 ;
  localparam MAGENTA      = 5 ;
  localparam CYAN         = 6 ;
  localparam WHITE        = 7 ;
  localparam H_RAMP       = 8 ;
  localparam H_RAMP_PIXEL = 9 ;
  localparam V_RAMP       = 10;
  localparam V_RAMP_PIXEL = 11;
  localparam ONE_DOT      = 12;

  virtual itf_data m_itf;

  function new(
    virtual itf_data i_itf
  );
  begin
    m_itf = i_itf;
  end
  endfunction

  function void get_pixel(
  );
    integer maxValue;

    maxValue = (1 << m_itf.image_bit_depth) - 1;
    case(m_itf.image_type)
      BLACK: begin
        m_itf.r = 0;
        m_itf.g = 0;
        m_itf.b = 0;
      end
      RED: begin
        m_itf.r = maxValue;
        m_itf.g = 0;
        m_itf.b = 0;
      end 
      GREEN: begin
        m_itf.r = 0;
        m_itf.g = maxValue;
        m_itf.b = 0;
      end
      YELLOW: begin
        m_itf.r = maxValue;
        m_itf.g = maxValue;
        m_itf.b = 0;
      end
      BLUE: begin
        m_itf.r = 0;
        m_itf.g = 0;
        m_itf.b = maxValue;
      end
      MAGENTA: begin
        m_itf.r = maxValue;
        m_itf.g = 0;
        m_itf.b = maxValue;
      end
      CYAN: begin
        m_itf.r = 0;
        m_itf.g = maxValue;
        m_itf.b = maxValue;
      end
      WHITE: begin
        m_itf.r = maxValue;
        m_itf.g = maxValue;
        m_itf.b = maxValue;
      end
      H_RAMP: begin
        m_itf.r = (m_itf.cnt_ch / m_itf.max_cnt_ch) * maxValue;
        m_itf.g = (m_itf.cnt_ch / m_itf.max_cnt_ch) * maxValue;
        m_itf.b = (m_itf.cnt_ch / m_itf.max_cnt_ch) * maxValue;
      end 
      H_RAMP_PIXEL: begin
        m_itf.r = (m_itf.cnt_ch     + m_itf.cnt_frame + m_itf.cnt_line) % maxValue;
        m_itf.g = (m_itf.cnt_ch + 1 + m_itf.cnt_frame + m_itf.cnt_line) % maxValue;
        m_itf.b = (m_itf.cnt_ch + 2 + m_itf.cnt_frame + m_itf.cnt_line) % maxValue;
      end
      V_RAMP: begin
        m_itf.r = (m_itf.cnt_line / m_itf.max_cnt_line) * maxValue;
        m_itf.g = (m_itf.cnt_line / m_itf.max_cnt_line) * maxValue;
        m_itf.b = (m_itf.cnt_line / m_itf.max_cnt_line) * maxValue;
      end
      V_RAMP_PIXEL: begin
        m_itf.r = (m_itf.cnt_line) % maxValue;
        m_itf.g = (m_itf.cnt_line) % maxValue;
        m_itf.b = (m_itf.cnt_line) % maxValue;
      end
      ONE_DOT: begin
        if ((m_itf.cnt_ch+m_itf.cnt_line) % 2) begin
          m_itf.r = 0;
          m_itf.g = 0;
          m_itf.b = 0;
        end
        else begin
          m_itf.r = maxValue;
          m_itf.g = maxValue;
          m_itf.b = maxValue;
        end
      end
      default: begin
        m_itf.r = maxValue;
        m_itf.g = maxValue;
        m_itf.b = maxValue;
      end
    endcase
  endfunction
endclass
