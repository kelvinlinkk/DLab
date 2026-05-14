module kpd_decoder (
    input            isclick,
    input            sys_rst_n,
    input      [3:0] cnt_out,
    input            E,
    input            F,
    input            G,
    output reg [3:0] map
);

always @(posedge isclick or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        map <= 4'hf;
    end else begin
        if      ((cnt_out == 4'h0) && G) map <= 4'h1; 
        else if ((cnt_out == 4'h0) && F) map <= 4'h2; 
        else if ((cnt_out == 4'h0) && E) map <= 4'h3; 
        else if ((cnt_out == 4'h1) && G) map <= 4'h4; 
        else if ((cnt_out == 4'h1) && F) map <= 4'h5; 
        else if ((cnt_out == 4'h1) && E) map <= 4'h6; 
        else if ((cnt_out == 4'h2) && G) map <= 4'h7; 
        else if ((cnt_out == 4'h2) && F) map <= 4'h8; 
        else if ((cnt_out == 4'h2) && E) map <= 4'h9; 
        else if ((cnt_out == 4'h3) && G) map <= 4'hc; 
        else if ((cnt_out == 4'h3) && F) map <= 4'h0; 
        else if ((cnt_out == 4'h3) && E) map <= 4'hb; 
        else                             map <= 4'hf;
    end
end

endmodule