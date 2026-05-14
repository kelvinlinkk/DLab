module traffic_light (
    input sys_clk,           // 100MHz clock from Pin E3
    input sys_rst_n,         // Reset required for cntr_4bit
    
    output reg LED16_R,        
    output reg LED16_G,        
    output reg LED16_B,        
    
    // 將原本的 [6:0] seg 替換為獨立的 CA 到 CG
    output reg CA,
    output reg CB,
    output reg CC,
    output reg CD,
    output reg CE,
    output reg CF,
    output reg CG,
    
    output reg [7:0] AN      
);

    // --- State Definitions ---
    localparam RED    = 2'd0;
    localparam YELLOW = 2'd1;
    localparam GREEN  = 2'd2;

    // --- Internal Registers & Wires ---
    reg [1:0] state;
    reg [3:0] timer;          
    
    wire clk_1hz;
    wire clk_1khz;
    reg clk_1hz_d;
    reg clk_1khz_d;
    
    reg digit_sel;
    reg [3:0] current_digit;

    // --- InstANtiate cntr_4bit for 1Hz Timer ---
    cntr_4bit #(
        .CNT_1S_MAX(30'd100_000_000)
    ) cntr_1hz_inst (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .isUP(1'b1),
        .div_1s(clk_1hz),
        .out() 
    );

    // --- InstANtiate cntr_4bit for 1kHz Refresh Timer ---
    cntr_4bit #(
        .CNT_1S_MAX(30'd100_000)
    ) cntr_1khz_inst (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .isUP(1'b1),
        .div_1s(clk_1khz),
        .out() // Not used
    );

    // --- Edge Detection for Generated Clocks ---
    wire tick_1hz = clk_1hz && !clk_1hz_d;
    wire tick_1khz = clk_1khz && !clk_1khz_d;

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            clk_1hz_d <= 1'b0;
            clk_1khz_d <= 1'b0;
        end else begin
            clk_1hz_d <= clk_1hz;
            clk_1khz_d <= clk_1khz;
        end
    end

    // --- Main Traffic Light State Machine (Triggered by 1Hz tick) ---
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            state <= RED;
            timer <= 4'd10;
        end else if (tick_1hz) begin
            if (timer == 4'd1) begin
                case (state)
                    RED: begin
                        state <= YELLOW;
                        timer <= 4'd5;
                    end
                    YELLOW: begin
                        state <= GREEN;
                        timer <= 4'd10;
                    end
                    GREEN: begin
                        state <= RED;
                        timer <= 4'd10;
                    end
                    default: begin
                        state <= RED;
                        timer <= 4'd10;
                    end
                endcase
            end else begin
                timer <= timer - 4'd1;
            end
        end
    end

    // --- Tri-color LED Combinational Logic ---
    always @(*) begin
        case (state)
            RED:    {LED16_R, LED16_G, LED16_B} = 3'b100;
            YELLOW: {LED16_R, LED16_G, LED16_B} = 3'b110; 
            GREEN:  {LED16_R, LED16_G, LED16_B} = 3'b010;
            default:{LED16_R, LED16_G, LED16_B} = 3'b000;
        endcase
    end

    // --- 7-Segment Display Multiplexer (Triggered by 1kHz tick) ---
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            digit_sel <= 1'b0;
        end else if (tick_1khz) begin
            digit_sel <= ~digit_sel; 
        end
    end

    // --- ANode ANd Digit Routing ---
    always @(*) begin
        AN = 8'b11111111; 
        current_digit = 4'd0;
        if (digit_sel == 1'b0) begin
            
            AN[0] = 1'b0; 
            current_digit = (timer == 4'd10) ? 4'd0 : timer;
        end else begin
            if (timer == 4'd10) begin
                AN[1] = 1'b0; 
                current_digit = 4'd1;
            end
        end
    end

    // --- 7-Segment Decoder (Active Low) ---
    always @(*) begin
        case (current_digit)
            4'd0: {CG, CF, CE, CD, CC, CB, CA} = 7'b1000000;
            4'd1: {CG, CF, CE, CD, CC, CB, CA} = 7'b1111001;
            4'd2: {CG, CF, CE, CD, CC, CB, CA} = 7'b0100100;
            4'd3: {CG, CF, CE, CD, CC, CB, CA} = 7'b0110000;
            4'd4: {CG, CF, CE, CD, CC, CB, CA} = 7'b0011001;
            4'd5: {CG, CF, CE, CD, CC, CB, CA} = 7'b0010010;
            4'd6: {CG, CF, CE, CD, CC, CB, CA} = 7'b0000010;
            4'd7: {CG, CF, CE, CD, CC, CB, CA} = 7'b1111000;
            4'd8: {CG, CF, CE, CD, CC, CB, CA} = 7'b0000000;
            4'd9: {CG, CF, CE, CD, CC, CB, CA} = 7'b0010000;
            default: {CG, CF, CE, CD, CC, CB, CA} = 7'b1111111;
        endcase
    end

endmodule