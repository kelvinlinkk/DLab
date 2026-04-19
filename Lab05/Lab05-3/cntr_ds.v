module cntr_ds (
    input           sys_clk,
    input sys_rst_n,

    output          CA,
    output          CB,
    output          CC,
    output          CD,
    output          CE,
    output          CF,
    output          CG,
    output          DP,
    output          div_1s_wire,

    output  [7:0]   AN
  );

  wire [3:0]  cnt_out;
  wire  [3:0]      map;

  cntr_4bit cntr_4bit_0 (
              .sys_clk(sys_clk),
              .sys_rst_n(sys_rst_n),
              .isUP(1),
              .div_1s(div_1s_wire),
              .out(cnt_out)
            );
  cvtr_4bit cvtr_4bit_0(
      .digit_in(cnt_out),
      .digit_out(map)
  );
  svn_dcdr svn_dcdr_0 (
             .in(map),
             .dp_in(1'b0),
             .AN_in(8'hFE),
             .CA(CA),
             .CB(CB),
             .CC(CC),
             .CD(CD),
             .CE(CE),
             .CF(CF),
             .CG(CG),
             .DP(DP),
             .AN(AN)
           );

endmodule
