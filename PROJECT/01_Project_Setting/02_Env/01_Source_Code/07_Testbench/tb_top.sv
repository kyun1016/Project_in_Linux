// ./list_testbench.f

module tb_top;
  reg clk;
  reg rstn;

  initial begin : clk_reset_control
    clk = 0;
    rstn = 1;
    fork
      forever #1 clk = ~clk;
      begin
        #10 rstn=0;
        #1000 rstn=1;
      end
    join
  end

  initial begin : fsdb_control
    $fsdbDumpfile("./03_fsdb/waveform.fsdb");
    $fsdbDumpvars(0,tb_top);
  end

  initial begin : main
    @(posedge rstn);
    for(int i=0;i<100;i++) begin
      @(posedge clk);
      m_itf.x = i[7:0];
    end
    repeat(100) 
      @(posedge clk);
    $finish;
  end

  itf_data m_itf(
    .clk  (clk ),
    .rstn (rstn)
  );

  rx_top u_rx_top(
    .clk (m_itf.clk ),
    .rstn(m_itf.rstn),

    .i_x (m_itf.x   ),
    .o_y (m_itf.y   )
  );

endmodule

