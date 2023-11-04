// ./list_testbench.f

module tb_top;
  reg clk;
  reg rstn;
  reg clk_apb;
  reg rstn_apb;

  itf_data m_itf(
    .clk      (clk     ),
    .rstn     (rstn    ),
    .clk_apb  (clk_apb ),
    .rstn_apb (rstn_apb)
  );

  initial begin : clk_reset_control
    clk   = 0;
    rstn = 1;
    fork
      forever #1 clk = ~clk;
      begin
        #10   rstn = 0;
        #1000 rstn = 1;
      end
    join
  end

  initial begin : fsdb_control
    $fsdbDumpfile("./03_fsdb/waveform.fsdb");
    $fsdbDumpvars(0,tb_top);
  end

  initial begin : main
    @(posedge rstn);
    m_itf.i_x       = 24;

    repeat(100) 
      @(posedge clk);
    $finish;
  end


  rtl_top u_rtl_top(
    .clk            (m_itf.clk            ),
    .rstn           (m_itf.rstn           ),
    .clk_apb        (m_itf.clk_apb        ),
    .rstn_apb       (m_itf.rstn_apb       ),
    .i_apb_addr     (m_itf.i_apb_addr     ),
    .i_apb_data     (m_itf.i_apb_data     ),
    .i_apb_wait     (m_itf.i_apb_wait     ),
    .i_apb_write_trg(m_itf.i_apb_write_trg),
    .i_apb_read_trg (m_itf.i_apb_read_trg ),
    .i_apb_sel      (m_itf.i_apb_sel      ),
    .i_x            (m_itf.i_x            ),
    .o_y            (m_itf.o_y            )
  );

endmodule

