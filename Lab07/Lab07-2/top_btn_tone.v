module tone_ply(
    input sys_clk,
    input sys_rst_n,
    input [3:0] in,
    output tone
);

reg tone_reg;

wire tone_w1;
wire tone_w2;
wire tone_w3;
wire tone_w4;
wire tone_w5;
wire tone_w6;
wire tone_w7;
wire tone_w8;
wire tone_w9;
wire tone_w10;
wire tone_w11;
wire tone_w12;

tone #( .PERIOD     (20'd381679 )
) t262  (
        .sys_clk    (sys_clk    ),
        .sys_rst_n  (sys_rst_n  ),
        .tone       (tone_w1    )
);
tone #( .PERIOD     (20'd340136 )
) t294  (
        .sys_clk    (sys_clk    ),
        .sys_rst_n  (sys_rst_n  ),
        .tone       (tone_w2    )
);
tone #( .PERIOD     (20'd303030 )
) t330  (
        .sys_clk    (sys_clk    ),
        .sys_rst_n  (sys_rst_n  ),
        .tone       (tone_w3    )
);
tone #( .PERIOD     (20'd286533 )
) t349  (
        .sys_clk    (sys_clk    ),
        .sys_rst_n  (sys_rst_n  ),
        .tone       (tone_w4    )
);
tone #( .PERIOD     (20'd251102 )
) t392  (
        .sys_clk    (sys_clk    ),
        .sys_rst_n  (sys_rst_n  ),
        .tone       (tone_w5    )
);
tone t440(
        .sys_clk    (sys_clk    ),
        .sys_rst_n  (sys_rst_n  ),
        .tone       (tone_w6    )
);

tone #( .PERIOD     (20'd202029 )
) t494  (
        .sys_clk    (sys_clk    ),
        .sys_rst_n  (sys_rst_n  ),
        .tone       (tone_w7    )
);

tone #( .PERIOD     (20'd191204 )
) t523  (
        .sys_clk    (sys_clk    ),
        .sys_rst_n  (sys_rst_n  ),
        .tone       (tone_w8    )
);
tone #( .PERIOD     (20'd170358 )
) t587  (
        .sys_clk    (sys_clk    ),
        .sys_rst_n  (sys_rst_n  ),
        .tone       (tone_w9    )
);

tone #( .PERIOD     (20'd151745 )
) t659  (
        .sys_clk    (sys_clk    ),
        .sys_rst_n  (sys_rst_n  ),
        .tone       (tone_w10    )
);

tone #( .PERIOD     (20'd143266 )
) t698  (
        .sys_clk    (sys_clk    ),
        .sys_rst_n  (sys_rst_n  ),
        .tone       (tone_w11    )
);

// Note G, 793 Hz
tone #( .PERIOD     (20'd127551 )
) t784  (
        .sys_clk    (sys_clk    ),
        .sys_rst_n  (sys_rst_n  ),
        .tone       (tone_w12    )
);

always @(posedge sys_clk or negedge sys_rst_n)
begin
    if (!sys_rst_n)
        tone_reg <= 1'b0;
    else
        case (in)
            4'h1:   tone_reg <= tone_w1;
            4'h2:   tone_reg <= tone_w2;
            4'h3:   tone_reg <= tone_w3;
            4'h4:   tone_reg <= tone_w4;
            4'h5:   tone_reg <= tone_w5;
            4'h6:   tone_reg <= tone_w6;
            4'h7:   tone_reg <= tone_w7;
            4'h8:   tone_reg <= tone_w8;
            4'h9:   tone_reg <= tone_w9;
            4'hc:   tone_reg <= tone_w10;
            4'h0:   tone_reg <= tone_w11;
            4'hb:   tone_reg <= tone_w12;
            default:    tone_reg <= 1'b0;
        endcase
end

assign tone = tone_reg;

endmodule