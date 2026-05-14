module Lab801_Top(
    input sys_clk,        
    input sys_rst_n,     
    
    output RGB_R,
    output RGB_G,
    output RGB_B
);

    reg [19:0] pwm_div = 0;
    reg [23:0] grad_div = 0; 
    
    wire pwm_tick = (pwm_div == 1_000 - 1); 
    
    wire grad_tick = (grad_div == 5_000_000 - 1); 

    always @(posedge sys_clk) begin
        pwm_div <= pwm_tick ? 0 : pwm_div + 1;
        grad_div <= grad_tick ? 0 : grad_div + 1;
    end

    reg [6:0] pwm_cnt = 0;
    always @(posedge sys_clk) begin
        if (pwm_tick) begin
            pwm_cnt <= (pwm_cnt >= 99) ? 0 : pwm_cnt + 1;
        end
    end

    reg [2:0] state = 0;
    reg [5:0] duty_r = 50; 
    reg [5:0] duty_g = 0;
    reg [5:0] duty_b = 0;

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            state <= 0;
            duty_r <= 50; 
            duty_g <= 0; 
            duty_b <= 0;
        end else if (grad_tick) begin
            case(state)
                3'd0: begin 
                    if (duty_g < 50) duty_g <= duty_g + 1;
                    else state <= 3'd1;
                end
                3'd1: begin 
                    if (duty_r > 0) duty_r <= duty_r - 1;
                    else state <= 3'd2;
                end
                3'd2: begin 
                    if (duty_b < 50) duty_b <= duty_b + 1;
                    else state <= 3'd3;
                end
                3'd3: begin 
                    if (duty_g > 0) duty_g <= duty_g - 1;
                    else state <= 3'd4;
                end
                3'd4: begin 
                    if (duty_r < 50) duty_r <= duty_r + 1;
                    else state <= 3'd5;
                end
                3'd5: begin 
                    if (duty_b > 0) duty_b <= duty_b - 1;
                    else state <= 3'd0;
                end
                default: state <= 0;
            endcase
        end
    end

    assign RGB_R = (pwm_cnt < duty_r);
    assign RGB_G = (pwm_cnt < duty_g);
    assign RGB_B = (pwm_cnt < duty_b);

endmodule