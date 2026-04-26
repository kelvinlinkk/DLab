module an_ctrl (
    input sys_clk,
    input sys_rst_n,
    input[4:0]  in,
    output[7:0]      an_out,
    output[3:0]      out
);   
wire  rst_wire;  


cntr_4bit cntr_4bit_0 (
                   .sys_clk(sys_clk),
                   .sys_rst_n(sys_rst_n & (~rst_wire)),
                   .isUP(1'b1),
                   .CNT_1S_MAX(30'd10000),
                   .div_1s(),
                   .out(cnt_out)
                 );

reset_dtct reset_dtct_0(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .digit_in(cnt_out),
    .bdry(4'h8),
    .isReset(rst_wire)
);

assign an_out = ~(8'b00000001 << cnt_out);
assign out = (cnt_out==5'h0)?(in%5'ha):
                (cnt_out==5'h1&& in>5'h9)?(1):
                (4'hf);
endmodule
