module reg_ckt (
    input       clk_in,
    input       sys_rst_n,
    input[3:0]       reg_in,

    output reg [3:0]  reg_out
);

always @(posedge clk_in or negedge sys_rst_n) begin
    if (!sys_rst_n)
        reg_out <= 4'hf;
    else if (reg_in!=4'hf)
        reg_out <= reg_in;
    else
        reg_out <= reg_out;
end

endmodule
