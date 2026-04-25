module half_adder(
    input   a,
    input   b,
    output  sum,
    output  cout
);

xor g1(sum, a, b);
and g2(cout, a, b);

endmodule