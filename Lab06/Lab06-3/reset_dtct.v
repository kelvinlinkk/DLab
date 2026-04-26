module reset_dtct (
    input           sys_clk,
    input           sys_rst_n,
    input [3:0]     digit_in,
    input [3:0]     bdry,

    output reg      isReset
);

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        isReset <= 1'b0;
    else if (digit_in == bdry)
        isReset <= 1'b1;
    else
        isReset <= 1'b0;  
end 

endmodule
