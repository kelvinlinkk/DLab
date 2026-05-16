module sequence_detector (
    input sys_clk,          // 100MHz clock from Pin E3
    input sys_rst_n,        // System reset (Active Low)

    // Pmod Inputs
    input pmod_data,        // Data input from AD2 Pattern Generator
    input pmod_clk,         // Clock input from AD2 Pattern Generator

    // LED Outputs
    output [7:0] led_data,  // 8 LEDs to display the currently captured data
    output led_detected     // 1 LED to indicate the sequence is detected
);

    // 目標序列: 10101101
    localparam TARGET_SEQ = 8'b10101101;

    // --- 跨時脈域同步器 (Synchronizer) ---
    // 將 AD2 的非同步訊號同步至 100MHz 的 sys_clk
    reg [2:0] pmod_clk_sync;
    reg [1:0] pmod_data_sync;

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            pmod_clk_sync <= 3'b000;
            pmod_data_sync <= 2'b00;
        end else begin
            // 移位暫存器同步
            pmod_clk_sync <= {pmod_clk_sync[1:0], pmod_clk};
            pmod_data_sync <= {pmod_data_sync[0], pmod_data};
        end
    end

    // --- 邊緣偵測 (Edge Detection) ---
    // 偵測 AD2 時脈的正緣 (Rising Edge) 作為資料取樣的觸發點
    wire pmod_clk_rising_edge = (pmod_clk_sync[2:1] == 2'b01);

    // --- 8位元移位暫存器 (Shift Register) ---
    reg [7:0] shift_reg;

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            shift_reg <= 8'b00000000;
        end else if (pmod_clk_rising_edge) begin
            // 當偵測到 AD2 clock 正緣時，將資料向左移位，並將新資料放入 LSB
            shift_reg <= {shift_reg[6:0], pmod_data_sync[1]};
        end
    end

    // --- 輸出邏輯 (Combinational Output) ---
    // 8 顆 LED 顯示目前擷取到的資料
    assign led_data = shift_reg;
    
    // 當移位暫存器內的資料完全等於目標序列時，點亮指示燈
    assign led_detected = (shift_reg == TARGET_SEQ) ? 1'b1 : 1'b0;

endmodule