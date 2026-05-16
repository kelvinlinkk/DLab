set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { sys_clk }];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { sys_clk }];
set_property -dict { PACKAGE_PIN C12   IOSTANDARD LVCMOS33 } [get_ports { sys_rst_n }];

set_property -dict { PACKAGE_PIN N16   IOSTANDARD LVCMOS33 } [get_ports { RGB_R }]; # LD17_Red
set_property -dict { PACKAGE_PIN R11   IOSTANDARD LVCMOS33 } [get_ports { RGB_G }]; # LD17_Green
set_property -dict { PACKAGE_PIN G14   IOSTANDARD LVCMOS33 } [get_ports { RGB_B }]; # LD17_Blue