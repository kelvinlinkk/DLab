`timescale 1ns / 1ps

module traffic_light_tb;

reg sys_clk;
reg sys_rst_n;
wire LED16_R;
wire LED16_G;
wire LED16_B;
wire CA;
wire CB;
wire CC;
wire CD;
wire CE;
wire CF;
wire CG;
wire [7:0] AN;

traffic_light uut (
.sys_clk(sys_clk),
.sys_rst_n(sys_rst_n),
.LED16_R(LED16_R),
.LED16_G(LED16_G),
.LED16_B(LED16_B),
.CA(CA),
.CB(CB),
.CC(CC),
.CD(CD),
.CE(CE),
.CF(CF),
.CG(CG),
.AN(AN)
);

defparam uut.cntr_1hz_inst.CNT_1S_MAX = 100;
defparam uut.cntr_1khz_inst.CNT_1S_MAX = 10;

initial begin
sys_clk = 0;
forever #5 sys_clk = ~sys_clk;
end

initial begin
sys_rst_n = 0;
#100;
sys_rst_n = 1;

#30000;

$stop;
end

endmodule