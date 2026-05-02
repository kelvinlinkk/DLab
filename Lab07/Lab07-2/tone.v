module tone (
    input   sys_clk,
    input   sys_rst_n,
    output  tone
);

parameter   PERIOD = 20'd227273;
parameter   DUTY   = PERIOD / 2;

reg [19:0]  cnt;
reg         tone_reg;

always @(posedge sys_clk or negedge sys_rst_n)
begin
    if (!sys_rst_n)
        cnt <= 20'd0;
    else if (cnt == (PERIOD - 20'd1))
        cnt <= 20'd0;
    else
        cnt <= cnt + 20'd1;
end

always @(posedge sys_clk or negedge sys_rst_n)
begin
    if (!sys_rst_n)
        tone_reg <= 1'b0;
    else if (cnt <= (DUTY - 20'd1))
        tone_reg <= 1'b1;
    else
        tone_reg <= 1'b0;
end

assign tone = tone_reg;

endmodule