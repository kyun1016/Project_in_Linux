// ./list_testbench.f

module tb_top;
  reg clk;
  reg rst_n;
  itf_data m_itf(
    .clk  (clk  ),
    .rst_n(rst_n)
  );

  initial begin : clk_reset_control
    clk   = 0;
    rst_n = 1;
    fork
      forever #1 clk = ~clk;
      begin
        #10   rst_n = 0;
        #1000 rst_n = 1;
      end
    join
  end

  initial begin : fsdb_control
    $fsdbDumpfile("./03_fsdb/waveform.fsdb");
    $fsdbDumpvars(0,tb_top);
  end

  initial begin : main
    @(posedge rst_n);
    m_itf.i_en      = 1;
    m_itf.i_x       = 24;
    m_itf.i_weight0 = 104;
    m_itf.i_weight1 = 235;
    m_itf.i_weight2 = 293;
    m_itf.i_weight3 = 439;
    m_itf.i_weight4 = 595;
    m_itf.i_weight5 = 662;
    m_itf.i_weight6 = 691;
    m_itf.i_weight7 = 694;

    repeat(100) 
      @(posedge clk);
    $finish;
  end


  rtl_top u_rtl_top(
    .clk      (m_itf.clk      ),
    .rst_n    (m_itf.rst_n    ),
    .i_en     (m_itf.i_en     ),
    .i_x      (m_itf.i_x      ),
    .i_weight0(m_itf.i_weight0),
    .i_weight1(m_itf.i_weight1),
    .i_weight2(m_itf.i_weight2),
    .i_weight3(m_itf.i_weight3),
    .i_weight4(m_itf.i_weight4),
    .i_weight5(m_itf.i_weight5),
    .i_weight6(m_itf.i_weight6),
    .i_weight7(m_itf.i_weight7),
    .o_y      (m_itf.o_y      )
  );

endmodule

