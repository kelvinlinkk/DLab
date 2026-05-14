module cvtr_4bit (
    input sys_clk,
    input sys_rst_n,
    input pause_clk,
    input fq,
    input [4:0]      digit_in,
    output[3:0]      digit_out
  );

  reg [1:0] hr_10;
  reg [3:0] hr_0;
  reg [2:0] min_10;
  reg [3:0] min_0;
  reg [2:0] sec_10;
  reg [3:0] sec_0;

  reg [26:0] cnt_1hz;
  wire tick_1sec;
  assign tick_1sec= fq?(cnt_1hz == 27'd10000000):(cnt_1hz == 27'd10000);

  always @(posedge (sys_clk|pause_clk) or negedge sys_rst_n)
  begin
    if (!sys_rst_n)
      cnt_1hz <= 27'd0;
    else if (tick_1sec)
      cnt_1hz <= 27'd0;
    else
      cnt_1hz <= cnt_1hz + 1'b1;
  end

  // --- BCD 時鐘處理 ---
  always @(posedge (sys_clk|pause_clk) or negedge sys_rst_n)
  begin
    if (!sys_rst_n)
    begin
      // 重置時，所有 BCD 計數器歸零
      sec_0  <= 4'd0; // 秒的個位 (0~9)
      sec_10 <= 3'd0; // 秒的十位 (0~5)
      min_0  <= 4'd0; // 分的個位 (0~9)
      min_10 <= 3'd0; // 分的十位 (0~5)
      hr_0   <= 4'd0; // 時的個位 (0~9，最高到 3)
      hr_10  <= 2'd0; // 時的十位 (0~2)
    end
    else if (tick_1sec)
    begin
      // --- 秒鐘處理 ---
      if (sec_0 == 4'd9)
      begin
        sec_0 <= 4'd0;
        if (sec_10 == 3'd5)
        begin
          sec_10 <= 3'd0;

          // --- 分鐘處理 ---
          if (min_0 == 4'd9)
          begin
            min_0 <= 4'd0;
            if (min_10 == 3'd5)
            begin
              min_10 <= 3'd0;

              // --- 時鐘處理 ---
              if (hr_10 == 2'd2 && hr_0 == 4'd3)
              begin
                hr_0  <= 4'd0;
                hr_10 <= 2'd0;
              end
              else if (hr_0 == 4'd9)
              begin
                hr_0  <= 4'd0;
                hr_10 <= hr_10 + 1'b1;
              end
              else
              begin
                hr_0 <= hr_0 + 1'b1;
              end
            end
            else
            begin
              min_10 <= min_10 + 1'b1;
            end
          end
          else
          begin
            min_0 <= min_0 + 1'b1;
          end
        end
        else
        begin
          sec_10 <= sec_10 + 1'b1;
        end
      end
      else
      begin
        sec_0 <= sec_0 + 1'b1;
      end
    end
  end


  assign digit_out = (digit_in == 5'd0)  ? (4'hf):
         (digit_in == 5'd1)  ? (4'ha):
         (digit_in == 5'd2)  ? (sec_0):          // S (個位)
         (digit_in == 5'd3)  ? ({1'b0, sec_10}): // S (十位)
         (digit_in == 5'd4)  ? (4'ha):
         (digit_in == 5'd5)  ? (min_0):          // M (個位)
         (digit_in == 5'd6)  ? ({1'b0, min_10}): // M (十位)
         (digit_in == 5'd7)  ? (4'ha):
         (digit_in == 5'd8)  ? (hr_0):           // H (個位)
         (digit_in == 5'd9)  ? ({2'b00, hr_10}): // H (十位)
         (digit_in == 5'd10) ? (4'ha):
         (digit_in == 5'd11) ? (4'h7):
         (digit_in == 5'd12) ? (4'h0):
         (digit_in == 5'd13) ? (4'ha):
         (digit_in == 5'd14) ? (4'h5):
         (digit_in == 5'd15) ? (4'h0):
         (digit_in == 5'd16) ? (4'ha):
         (digit_in == 5'd17) ? (4'h6):
         (digit_in == 5'd18) ? (4'h2):
         (digit_in == 5'd19) ? (4'h0):
         (digit_in == 5'd20) ? (4'h2):
         (4'hf);
endmodule
