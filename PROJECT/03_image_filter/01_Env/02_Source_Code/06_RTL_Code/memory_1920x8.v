// ./list_rtl.f

module memory_1920x8 
(
  input                 clk      ,
  input                 rstn     ,

  input                 i_en     ,
  input      [11:0]     i_addr   ,
  input      [7:0]      i_data   ,

  output reg [7:0]      o_data
);

  reg [8-1:0] r_mem [0:1920-1];

  always @ (posedge clk, negedge rstn) begin
    if(!rstn) begin
      for(int i=0;i<1920;++i)
        r_mem[i] <= 0;
    end
    else if(i_en)
      for(int i=0;i<1920;++i)
        if(i == i_addr)
          r_mem[i] <= i_data;
  end

  reg [8-1:0] r_out;
  always @ (*) begin
    for(int i=0;i<1920;++i)
      if(i == i_addr)
        r_out = r_mem[i];
  end

  assign o_data = r_out;

endmodule
