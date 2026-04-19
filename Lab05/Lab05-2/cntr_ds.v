module bounce_sequence (
    input           sys_clk,
    input           sys_rst_n,

    output          CA,
    output          CB,
    output          CC,
    output          CD,
    output          CE,
    output          CF,
    output          CG,
    output          DP,

    output  [7:0]   AN,
    output          isBrdy_check
);

wire [3:0]  cnt_out;
wire        isReset_wire;
wire        div_1s_wire;
wire        cntr_rst_n; 

assign cntr_rst_n = sys_rst_n & (~isReset_wire); 
assign isBrdy_check = isReset_wire;

cntr_4bit cntr_4bit_0 (
    .sys_clk(sys_clk),
    .sys_rst_n(cntr_rst_n), 
    .isUP(1),          
    .div_1s(div_1s_wire),     
    .out(cnt_out)
);

reset_dtct reset_dtct_0 (
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .digit_in(cnt_out),        
    .isReset(isReset_wire)
);

svn_dcdr svn_dcdr_0 (
    .in(cnt_out),      
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