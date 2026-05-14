module cntr_5bit(
    input sys_clk,
    input sys_rst_n,
    input isUP, 
    input [29:0] CNT_1S_MAX,

    output div_1s,
    output [4:0] out
);


reg [29:0]  cnt_1s;
reg         div_1s_reg;
reg [4:0]   out_reg;

always @(posedge sys_clk or negedge sys_rst_n)
begin
    if (!sys_rst_n)
        cnt_1s <= 30'd0;
    else if (cnt_1s == CNT_1S_MAX - 30'd1)
        cnt_1s <= 30'd0;
    else
        cnt_1s <= cnt_1s + 30'd1;
end

always @(posedge sys_clk or negedge sys_rst_n)
begin
    if (!sys_rst_n)
        div_1s_reg <= 1'b0;
    else if (cnt_1s <= CNT_1S_MAX/2 - 30'd1)
        div_1s_reg <= 1'b1;
    else
        div_1s_reg <= 1'b0;
end

always @(posedge sys_clk or negedge sys_rst_n)
begin
    if (!sys_rst_n)
        out_reg <= 5'd0;
    else if (isUP)
    begin
        // 修改處 1：當上數到 20 (或以上) 時，歸零
        if ((cnt_1s == CNT_1S_MAX - 30'd1) && (out_reg >= 5'd20))
            out_reg <= 5'd0;
        else if (cnt_1s == CNT_1S_MAX - 30'd1)
            out_reg <= out_reg + 5'd1;
        else
            out_reg <= out_reg;
    end
    else
    begin
        // 修改處 2：當下數到 0 時，回到 20
        if ((cnt_1s == CNT_1S_MAX - 30'd1) && (out_reg == 5'd0))
            out_reg <= 5'd20;
        else if (cnt_1s == CNT_1S_MAX - 30'd1)
            out_reg <= out_reg - 5'd1;
        else
            out_reg <= out_reg;
    end
end

assign div_1s = div_1s_reg;
assign out = out_reg;

endmodule