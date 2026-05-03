`timescale 1ns / 1ps

module tb_kpd_dtct();

    // 輸入訊號 (暫存器型態)
    reg sys_clk;
    reg sys_rst_n;
    reg btn_stage;
    reg E;
    reg F;
    reg G;

    // 輸出訊號 (線路型態)
    wire A;
    wire B;
    wire C;
    wire D;
    wire CA, CB, CC, CD, CE, CF, CG, DP;
    wire [7:0] AN;

    // 實例化待測物 (Unit Under Test, UUT)
    kpd_dtct uut (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .btn_stage(btn_stage),
        .E(E),
        .F(F),
        .G(G),
        .A(A),
        .B(B),
        .C(C),
        .D(D),
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

    // 產生時脈訊號 (100MHz，週期 10ns)
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk; 
    end

    // 模擬情境
    initial begin
        // 1. 初始化輸入
        sys_rst_n = 0;
        btn_stage = 0;
        E = 0; F = 0; G = 0;

        // 2. 解除系統重置
        #100;
        sys_rst_n = 1;

        // 等待一段時間讓內部計數器穩定
        #1000;

        // 3. 模擬第一次按鍵輸入 (假設掃描到對應狀態時，G 收到訊號)
        G = 1;
        #500; // 按壓維持一段時間
        G = 0;

        // 4. 切換到下一個狀態 (按下 btn_stage)
        #500;
        btn_stage = 1;
        #200;
        btn_stage = 0;

        // 5. 模擬第二次按鍵輸入 (假設 F 收到訊號)
        #1000;
        F = 1;
        #500;
        F = 0;

        // 6. 切換到加法結果顯示狀態
        #500;
        btn_stage = 1;
        #200;
        btn_stage = 0;

        // 觀察一段時間後結束模擬
        #2000;
        $finish;
    end

endmodule