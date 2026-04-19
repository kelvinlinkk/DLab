module inv_ckt(
    input   in0,
    output  out0
);

/* 
Instantiate the primitive logic gates that are provided as
built-in components in the Vivado development environment.
*/

not g1(out0, in0);

endmodule