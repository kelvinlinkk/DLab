`timescale 1ns / 1ps

module tb_adder_4bit_custom;
    reg  [3:0] a;
    reg  [3:0] b;
    wire [3:0] s;
    wire       cout;

    adder_4bit uut (
        .a(a),
        .b(b),
        .s(s),
        .cout(cout)
    );

    initial begin
        // Monitor the outputs whenever inputs change
        $monitor("Time=%0t | a=%b b=%b | cout=%b s=%b", $time, a, b, cout, s);

        // Test 1+1
        a = 4'b0001; b = 4'b0001; #10;
        
        // Test 2+2
        a = 4'b0010; b = 4'b0010; #10;
        
        // Test 4+4
        a = 4'b0100; b = 4'b0100; #10;
        
        // Test 8+8
        a = 4'b1000; b = 4'b1000; #10;

        // Test 1111+1
        a = 4'b1111; b = 4'b0001; #10;
        
        // Test 1111+2
        a = 4'b1111; b = 4'b0010; #10;
        
        // Test 1111+4
        a = 4'b1111; b = 4'b0100; #10;
        
        // Test 1111+8
        a = 4'b1111; b = 4'b1000; #10;

        $finish;
    end

endmodule