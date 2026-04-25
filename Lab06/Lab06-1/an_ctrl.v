module an_ctrl (
    input sys_clk,
    input sys_rst_n,
    input dir,
    input[3:0]  in,
    output[7:0]      an_out,
    output[3:0]      out
);   
wire [3:0] rfsh_out;
wire  rst_wire;  


cntr_rfsh_4bit cntr_rfsh_4bit_0 (
                   .sys_clk(sys_clk),
                   .sys_rst_n(sys_rst_n & (~rst_wire)),
                   .isUP(1'b1),
                   .CNT_1S_MAX(30'd10000),
                   .div_1s(),
                   .out(rfsh_out)
                 );

reset_dtct reset_dtct_0(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .digit_in(rfsh_out),
    .bdry(4'h8),
    .isReset(rst_wire)
);

assign an_out = ~(8'b00000001 << rfsh_out);
assign out = dir ? ((rfsh_out + 20 - in) % 10) : (({1'b0, rfsh_out} + in) % 10);
//assign out = dir?((rfsh_out - in) % 10):((rfsh_out + in) % 10);

endmodule
