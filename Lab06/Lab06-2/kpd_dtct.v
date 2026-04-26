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
  reg  [3:0]  map;      
  wire [3:0]  reg_out; 
  wire rst_wire;
  wire  isclick;

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
assign isclick=E|F|G;
always @(posedge isclick or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        map <= 4'hf;
    end else begin
        if      ((cnt_out == 4'h0) && G) map <= 4'h1; 
        else if ((cnt_out == 4'h0) && F) map <= 4'h2; 
        else if ((cnt_out == 4'h0) && E) map <= 4'h3; 
        else if ((cnt_out == 4'h1) && G) map <= 4'h4; 
        else if ((cnt_out == 4'h1) && F) map <= 4'h5; 
        else if ((cnt_out == 4'h1) && E) map <= 4'h6; 
        else if ((cnt_out == 4'h2) && G) map <= 4'h7; 
        else if ((cnt_out == 4'h2) && F) map <= 4'h8; 
        else if ((cnt_out == 4'h2) && E) map <= 4'h9; 
        else if ((cnt_out == 4'h3) && G) map <= 4'hc; 
        else if ((cnt_out == 4'h3) && F) map <= 4'h0; 
        else if ((cnt_out == 4'h3) && E) map <= 4'hb; 
        else                             map <= 4'hf;
    end
end

endmodule