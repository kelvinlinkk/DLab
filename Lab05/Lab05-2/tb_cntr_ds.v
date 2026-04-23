`timescale 1ns / 1ps

module tb_cntr_ds();

    // Inputs
    reg sys_clk;
    reg sys_rst_n;
    reg dir;

    // Outputs
    wire CA, CB, CC, CD, CE, CF, CG, DP;
    wire [7:0] AN;
    wire isBrdy_check;

    // Instantiate the Unit Under Test (UUT)
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

    defparam uut.cntr_4bit_0.CNT_1S_MAX = 5;

    // 產生 Clock (100MHz -> 週期 10ns)
    always #5 sys_clk = ~sys_clk;

    initial begin
        // 初始化輸入訊號
        sys_clk = 0;
        sys_rst_n = 0;
        dir = 1; 
        
        $monitor("Time: %0t ns | rst_n: %b | dir: %b | cnt_out: %d | cvtr_out (to svn_dcdr): %d | Segments (CA-CG): %b%b%b%b%b%b%b",
                 $time, sys_rst_n, dir, uut.cnt_out, uut.cvtr_out, CA, CB, CC, CD, CE, CF, CG);

        // 解除 Reset
        #20;
        sys_rst_n = 1;
        #600;
        
        dir = 0;

        #600;

        $finish;
    end

endmodule