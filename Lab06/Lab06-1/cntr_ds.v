module cntr_ds (
    input sys_clk,
    input sys_rst_n,
    input dir,

    output          CA,
    output          CB,
    output          CC,
    output          CD,
    output          CE,
    output          CF,
    output          CG,
    output          DP,
    output  [7:0]   AN
  );

  wire [3:0]  cnt_out;
  wire [3:0]  out;
  wire [7:0] AN_in;
  wire [3:0] map;
  wire rst_wire;


an_ctrl an_ctrl_0(
            .sys_clk(sys_clk),
            .sys_rst_n(sys_rst_n),
            .dir(dir),
            .in(cnt_out),
            .an_out(AN_in),
            .out(out)
);

reset_dtct reset_dtct_0(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .digit_in(cnt_out),
    .bdry(4'h9),
    .isReset(rst_wire)
); 

cntr_4bit cntr_4bit_0 (
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n & (~rst_wire)),
    .isUP(1),
    .div_1s(),
    .out(cnt_out)
);  

  cvtr_4bit cvtr_4bit_0(
              .digit_in(out),
              .digit_out(map)
            );
  svn_dcdr svn_dcdr_0 (
             .in(map),
             .dp_in(1'b0),
             .AN_in(AN_in),
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
