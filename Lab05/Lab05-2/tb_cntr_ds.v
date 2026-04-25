`timescale 1ns / 1ps

module tb_cntr_ds();

    reg sys_clk;
    reg sys_rst_n;
    reg dir;

    wire CA, CB, CC, CD, CE, CF, CG, DP;
    wire [7:0] AN;
    wire isBrdy_check;

    
    cntr_ds uut (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .dir(dir),
        .CA(CA),
        .CB(CB),
        .CC(CC),
        .CD(CD),
        .CE(CE),
        .CF(CF),
        .CG(CG),
        .DP(DP),
        .AN(AN),
        .isBrdy_check(isBrdy_check)
    );

    defparam uut.cntr_4bit_0.CNT_1S_MAX = 30'd10;

    
    always #5 sys_clk = ~sys_clk;

    initial begin
        sys_clk = 0;
        sys_rst_n = 0;
        dir = 1; 
        
        
        #20;
        sys_rst_n = 1;
        #600;
        
        dir = 0;

        #600;

        $finish;
    end

endmodule