module an_ctrl (
    input sys_clk,
    input sys_rst_n,
    input[4:0]  in,
    output[7:0]      an_out,
    output[4:0]      out
);   
wire [2:0] rfsh_out;
wire  rst_wire;  
wire [5:0] sum; 


cntr_3bit cntr_3bit_0 (
                   .sys_clk(sys_clk),
                   .sys_rst_n(sys_rst_n & (~rst_wire)),
                   .isUP(1'b1),
                   .CNT_1S_MAX(30'd100000),
                   .div_1s(),
                   .out(rfsh_out)
                 );


assign an_out = ~(8'b00000001 << rfsh_out);

// 先計算總和
assign sum = {2'b00, rfsh_out} + {1'b0, in};

// 如果總和大於或等於 21，則減去 21；否則保持原樣
assign out = (sum >= 6'd21) ? (sum - 6'd21) : sum[4:0];

endmodule