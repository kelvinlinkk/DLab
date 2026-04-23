`timescale 1ns / 1ps

module tb_adder_4bit_all;
    reg  [3:0] a;
    reg  [3:0] b;
    wire [3:0] s;
    wire       cout;

    integer i, j;
    integer error_count;

    adder_4bit uut (
        .a(a),
        .b(b),
        .s(s),
        .cout(cout)
    );

    initial begin
        a = 4'b0000;
        b = 4'b0000;
        error_count = 0;


        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                
                a = i;
                b = j;
                
                #10; 

                $display("%0t\t| %b + %b |  %b   %b | (%d + %d = %d)", 
                         $time, a, b, cout, s, a, b, {cout, s});

                if ({cout, s} !== (a + b)) begin
                    $display(">>> [錯誤] 發生在 %0t: 預期 %d + %d = %d, 但得到 %d <<<", 
                             $time, a, b, (a + b), {cout, s});
                    error_count = error_count + 1;
                end
                
            end
        end

        $finish;
    end

endmodule