module kpd_dtct (
    input sys_clk,
    input sys_rst_n,
    input btn_stage,
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
  reg  [3:0]  map;      
  wire [3:0] stage;    
  wire [7:0] an_wire;  
  wire [4:0] svn_ds;
  wire [3:0]  d0;
  wire [3:0]  d1;
  wire rst_wire;
  wire  isclick;
stage_ctrl stage_ctrl_0(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .btn_stage(btn_stage),
    .map(map),
    .reg_out_0(d0),
    .reg_out_1(d1),
    .stage(stage)
  );
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
    .in(out),
    .dp_in(1'b0),
    .AN_in(an_wire),
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
 an_ctrl an_ctrl_0(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .in(svn_ds),
    .an_out(an_wire),
    .out(out)
); 
assign svn_ds=  (stage == 4'h0)?({4'b0,map}):
                (stage == 4'h1)?({4'b0,map}):
                (stage == 4'h2)?({4'b0,d0}+{4'b0,d1}):
                ({4'b0,map});
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