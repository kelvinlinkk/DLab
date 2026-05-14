`timescale 1ns / 1ps

module tb_cntr_ds();

    // 宣告輸入訊號
    reg sys_clk;
    reg sys_rst_n;
    reg dir;

    // 宣告輸出訊號
    wire CA, CB, CC, CD, CE, CF, CG, DP;
    wire [7:0] AN;

    // 實例化待測模組 (DUT)
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
        .AN(AN)
    );

    // ===============================================================
    // ★ 加速模擬的關鍵：覆蓋計數器參數
    // ===============================================================
    // 這裡合法：因為 cntr_4bit_0 的 CNT_1S_MAX 是 parameter
    defparam uut.cntr_4bit_0.CNT_1S_MAX = 30'd100; 
    
    // 【已刪除】針對 cntr_rfsh_4bit_0 的 defparam，因為它是 input port
    // ===============================================================

    // 產生 100MHz 系統時脈 (週期 10ns)
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

    // 給定測資與模擬流程
    initial begin
        // 初始狀態設定
        sys_rst_n = 0;
        dir = 0;

        // 等待 100ns 後釋放重置訊號
        #100;
        sys_rst_n = 1;

        // 測試情境 1: dir = 0
        // rfsh_out 掃描計數器每 100us (100,000ns) 才會加 1
        // 為了觀察到完整的七段顯示器切換，我們將等待時間拉長到 500us (500,000ns)
        #500000;

        // 測試情境 2: 切換方向 dir = 1
        dir = 1;

        // 再等待 500us 觀察另一方向的跳動與七段顯示器的輸出變化
        #500000;

        // 結束模擬
        $finish;
    end

endmodule