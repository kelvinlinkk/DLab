`timescale 1ns / 1ps

module tb_Lab801_Top();

    // 1. 宣告輸入與輸出訊號
    reg sys_clk;
    reg sys_rst_n;

    wire RGB_R;
    wire RGB_G;
    wire RGB_B;

    // 2. 實例化待測模組 (UUT)
    Lab801_Top uut (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .RGB_R(RGB_R),
        .RGB_G(RGB_G),
        .RGB_B(RGB_B)
    );

    // 3. 產生時脈訊號：週期 10ns (100MHz)
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

    // =========================================================================
    // 【加速模擬 (Fast-Forward) 機制】
    // 原本的計數器極大：pwm 數到 1,000 (10us) / grad 數到 5,000,000 (50ms)
    // 這裡我們直接在 Testbench 產生加速版的 tick，並強制覆寫進 uut 內部。
    // =========================================================================
    reg fast_pwm_tick;
    reg fast_grad_tick;

    // A. 產生加速版 pwm_tick (縮短為每 100ns 觸發一次)
    initial begin
        fast_pwm_tick = 0;
        #100; // 等待重置
        forever begin
            #90; fast_pwm_tick = 1;
            #10; fast_pwm_tick = 0;
        end
    end

    // B. 產生加速版 grad_tick (縮短為每 10us 觸發一次)
    // 這樣每 10us (恰好是一個加速後的完整 PWM 週期) 就會改變一次顏色佔空比。
    initial begin
        fast_grad_tick = 0;
        #100; // 等待重置
        forever begin
            #9990; fast_grad_tick = 1;
            #10;   fast_grad_tick = 0;
        end
    end

    // C. 使用 force 將加速 tick 強制灌入 UUT 內部的 wire
    initial begin
        force uut.pwm_tick = fast_pwm_tick;
        force uut.grad_tick = fast_grad_tick;
    end
    // =========================================================================

    // 4. 模擬流程控制
    initial begin
        // 產生波形檔，因為有加速過，這份檔案會非常小且好讀
        $dumpfile("tb_Lab801_Top.vcd");
        $dumpvars(0, tb_Lab801_Top);

        // 系統重置
        sys_rst_n = 0;
        #100;
        sys_rst_n = 1;

        // 【時間計算】：
        // - 每個 state 有 50 個 duty 變化階層 (因為條件是 50)
        // - 總共有 6 個狀態 (state 0 ~ 5) => 完整一圈需要 300 次 grad_tick
        // - 我們加速後的 grad_tick 週期是 10 us
        // - 走完一圈總共只需要：300 * 10 us = 3,000 us (即 3 毫秒)
        //
        // 設定模擬時間為 3.5 毫秒，足以走完完整顏色 cycle，又絕對不會讓記憶體爆掉！
        #3500000;

        $display("Simulation finished. (Completed 1 full color cycle successfully with fast-forward!)");
        $finish;
    end

endmodule