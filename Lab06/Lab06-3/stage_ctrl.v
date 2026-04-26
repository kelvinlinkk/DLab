module stage_ctrl (
    input sys_clk,
    input sys_rst_n,
    input btn_stage,
    input [3:0] map,
    output[3:0] reg_out_0,
    output[3:0] reg_out_1,
    output reg [3:0] stage
  );

  wire [3:0]  cnt_out; 
  reg [3:0]  reg_in_0; 
  reg [3:0]  reg_in_1;
  wire [3:0]  reg_out_2;  
  wire rst_wire;

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

reg_ckt reg_ckt_0 (
    .clk_in(sys_clk),
    .sys_rst_n(sys_rst_n),
    .reg_in(reg_in_0),
    .reg_out(reg_out_0)
);
reg_ckt reg_ckt_1 (
    .clk_in(sys_clk),
    .sys_rst_n(sys_rst_n),
    .reg_in(reg_in_1),
    .reg_out(reg_out_1)
);
reg_ckt reg_stage (
    .clk_in(sys_clk),
    .sys_rst_n(sys_rst_n),
    .reg_in(stage),
    .reg_out(reg_out_2)
);
always @(posedge btn_stage or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        reg_in_0<=4'hf;
        reg_in_1<=4'hf;
        stage<=4'h0;
    end else begin
        if (stage == 4'h0) begin
            reg_in_0 <= map; 
            reg_in_1<=4'hf;
            stage<=4'h1;
        end
        else if (stage == 4'h1)  begin
            reg_in_0 <= 4'hf; 
            reg_in_1<=map;
            stage<=4'h2;
        end
        else if (stage == 4'h2)  begin
            reg_in_0 <= 4'hf; 
            reg_in_1<=4'hf;
            stage<=4'h0;
        end
        else  begin
            reg_in_0 <= map; 
            reg_in_1<=4'hf;
            stage<=4'h1;
        end
    end
end


endmodule