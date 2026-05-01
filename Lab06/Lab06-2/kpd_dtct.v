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
  wire [7:0]  AN_in;    
  wire [3:0]  map;       // ★ 注意：這裡因為要接外部模組的輸出，已改為 wire
  wire [3:0]  reg_out; 
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

svn_dcdr svn_dcdr_0 (
    .in(reg_out),
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

reg_ckt reg_ckt_0 (
    .clk_in(sys_clk),
    .sys_rst_n(sys_rst_n),
    .reg_in(map),
    .reg_out(reg_out)
);

assign {A,B,C,D} =
           (cnt_out==4'h0)?(4'h1):
           (cnt_out==4'h1)?(4'h2):
           (cnt_out==4'h2)?(4'h4):
           (cnt_out==4'h3)?(4'h8):
           (4'd8);

assign isclick = E | F | G;

// ★ 實例化鍵盤解碼模組，取代原本的 always block
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