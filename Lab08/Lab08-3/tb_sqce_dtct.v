`timescale 1ns / 1ps

module sequence_detector_tb;

reg sys_clk;
reg sys_rst_n;
reg pmod_data;
reg pmod_clk;

wire [7:0] led_data;
wire led_detected;

sequence_detector uut (
.sys_clk(sys_clk),
.sys_rst_n(sys_rst_n),
.pmod_data(pmod_data),
.pmod_clk(pmod_clk),
.led_data(led_data),
.led_detected(led_detected)
);

initial begin
sys_clk = 0;
forever #5 sys_clk = ~sys_clk;
end

initial begin
pmod_clk = 0;
forever #50 pmod_clk = ~pmod_clk;
end

task send_bit;
input bit_val;
begin
@(negedge pmod_clk);
pmod_data = bit_val;
end
endtask

initial begin
sys_rst_n = 0;
pmod_data = 0;
#100;
sys_rst_n = 1;

#200;

send_bit(1);
send_bit(0);
send_bit(1);
send_bit(0);
send_bit(1);
send_bit(1);
send_bit(0);
send_bit(1);

send_bit(0);
send_bit(0);

#500;
$stop;
end

endmodule