module kpd_dtct (
    input sys_clk,
    input sys_rst_n,
    input next,
    input previous,
    output          CA,
    output          CB,
    output          CC,
    output          CD,
    output          CE,
    output          CF,
    output          CG,
    output          DP,
    output  [7:0]   AN
);

    // 1. 宣告按鈕邊緣偵測用的暫存器
    reg next_d0, next_d1;
    reg prev_d0, prev_d1;
    
    // 宣告單一脈衝訊號
    wire next_pulse;
    wire prev_pulse;

    // 2. 宣告儲存當前數值的暫存器
    reg [3:0] cnt_reg;

    // ==========================================================
    // 區塊 A：按鈕邊緣偵測 (Edge Detection)
    // 功能：將外部按鈕同步到系統時脈，並產生剛按下瞬間的 1 個 Clock 寬度的脈衝
    // ==========================================================
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            next_d0 <= 1'b0;
            next_d1 <= 1'b0;
            prev_d0 <= 1'b0;
            prev_d1 <= 1'b0;
        end else begin
            // 兩級暫存器同步，防止亞穩態 (Metastability)
            next_d0 <= next;
            next_d1 <= next_d0;
            
            prev_d0 <= previous;
            prev_d1 <= prev_d0;
        end
    end

    // 當前狀態 (d0) 為 1，且前一個 Clock 狀態 (d1) 為 0 時，代表正處於上升緣
    assign next_pulse = next_d0 & (~next_d1);
    assign prev_pulse = prev_d0 & (~prev_d1);

    // ==========================================================
    // 區塊 B：同步計數器邏輯
    // 功能：接收到脈衝時，數值加 1 或減 1
    // ==========================================================
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            cnt_reg <= 4'd0;
        end else if (next_pulse) begin
            // 按下 Next，數值 +1 (4-bit 自動在 15 溢位回 0)
            cnt_reg <= cnt_reg + 1'b1;
        end else if (prev_pulse) begin
            // 按下 Previous，數值 -1 (4-bit 自動在 0 退回 15)
            cnt_reg <= cnt_reg - 1'b1;
        end
    end

    // ==========================================================
    // 區塊 C：七段顯示解碼
    // 功能：將暫存器的數值推向顯示器
    // ==========================================================
    svn_dcdr svn_dcdr_0 (
        .in(cnt_reg),
        .dp_in(1'b0),
        .AN_in(8'b11111110), // 只亮最右邊第一顆 (第 0 位)
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

endmodule