module cvtr_4bit (
    input [3:0]     digit_in,
    output[3:0]      digit_out
);   
assign digit_out =(digit_in == 4'h0) ? (4'h1):
                (digit_in == 4'h1) ? (4'h1):
                (digit_in == 4'h2) ? (4'h4):
                (digit_in == 4'h3) ? (4'h5):
                (digit_in == 4'h4) ? (4'h1):
                (digit_in == 4'h5) ? (4'h1):
                (digit_in == 4'h6) ? (4'h0):
                (digit_in == 4'h7) ? (4'h0):
                (digit_in == 4'h8) ? (4'h4):
                (digit_in == 4'h9) ? (4'h0):
                (digit_in == 4'ha) ? (4'h9):
                (digit_in == 4'hb) ? (4'h1):
                (digit_in == 4'hc) ? (4'h9):
                (digit_in == 4'hd) ? (4'hf):
                (digit_in == 4'he) ? (4'h5):
                (digit_in == 4'hf) ? (4'h5):
                            (4'hf);
endmodule
