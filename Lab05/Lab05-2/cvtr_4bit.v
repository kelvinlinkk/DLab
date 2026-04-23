module cvtr_4bit (
    input [3:0]     digit_in,
    input dir,
    output reg [3:0]  digit_out
);   
always @(*) 
begin
    if(dir)
        digit_out <=digit_in;
    else
        digit_out <=4'd9 - digit_in;
end
endmodule