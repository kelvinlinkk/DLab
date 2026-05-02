module kpd_dtct (
    input sys_clk,
    input sys_rst_n,
    input E,
    input F,
    input G,
    output A,
    output B,
    output C,
    output D,
    output tone
);

  wire [3:0]  cnt_out;
  wire [3:0]  map;
  wire rst_wire;
  wire isclick;

cntr_4bit cntr_4bit_0 (
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n & (~rst_wire)),
    .CNT_1S_MAX(30'd100_000),
    .isUP(1'b1),
    .div_1s(),
    .out(cnt_out)
);  

reset_dtct reset_dtct_0(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .digit_in(cnt_out),
    .bdry(4'h4),
    .isReset(rst_wire)
);
 tone_ply tone_ply_0(
    .sys_clk(sys_clk),
     .sys_rst_n(sys_rst_n),
    .in(map),
    .tone(tone)
);

assign {A,B,C,D} =
           (cnt_out==4'h0)?(4'h1):
           (cnt_out==4'h1)?(4'h2):
           (cnt_out==4'h2)?(4'h4):
           (cnt_out==4'h3)?(4'h8):
           (4'd8);

assign isclick = E | F | G;

kpd_decoder kpd_decoder_0 (
    .isclick(isclick),
    .sys_rst_n(sys_rst_n),
    .cnt_out(cnt_out),
    .E(E),
    .F(F),
    .G(G),
    .map(map)
);

endmodule