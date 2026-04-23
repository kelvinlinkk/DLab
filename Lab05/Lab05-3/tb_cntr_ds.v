`timescale 1ns / 1ps

module tb_cntr_ds;

    reg sys_clk;
    reg sys_rst_n;

    wire CA, CB, CC, CD, CE, CF, CG, DP;
    wire div_1s_wire;
    wire [7:0] AN;

    cntr_ds uut (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .CA(CA),
        .CB(CB),
        .CC(CC),
        .CD(CD),
        .CE(CE),
        .CF(CF),
        .CG(CG),
        .DP(DP),
        .div_1s_wire(div_1s_wire),
        .AN(AN)
    );
    
    defparam uut.cntr_4bit_0.CNT_1S_MAX = 30'd10;
    initial begin
        sys_clk = 0;
        forever #1 sys_clk = ~sys_clk;
    end

    initial begin
        sys_rst_n = 1;
        #15;
        sys_rst_n = 0;
        #50;
        sys_rst_n = 1;
        #2000; 
        
        $finish; 
    end

endmodule