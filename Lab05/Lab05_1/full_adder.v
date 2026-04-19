// include half_adder
module full_adder(
    input   a,
    input   b,
    input   cin,
    output  sum,
    output  cout
);

wire s1;    // 1st stage HA sum
wire c1;    // 1st stage HA carry
wire c2;    // 2nd stage HA carry

half_adder ha1(
    .a      (a),
    .b      (b),
    .sum    (s1),
    .cout   (c1)
);

half_adder ha2(
    .a      (s1),
    .b      (cin),
    .sum    (sum),
    .cout   (c2)
);

or g1(cout, c1, c2);

endmodule