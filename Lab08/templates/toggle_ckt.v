module toggle_ckt (
    input       clk_in,
    input       sys_rst_n,
    input       toggle_in,

    output reg  toggle_out
);

always @(posedge clk_in or negedge sys_rst_n) begin
    if (!sys_rst_n)
        toggle_out <= 1'b0;
    else if (toggle_in)
        toggle_out <= ~toggle_out;
    else
        toggle_out <= toggle_out;
end

endmodule
