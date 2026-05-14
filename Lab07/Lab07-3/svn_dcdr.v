/* 
//  A seven-segment display decoder
//  Design method: behavior
//  Displays decimal numbers from 0 to 9, including the decimal point
//  Inputs from 1010 to 1111 will turn off the display (go dark)
//  Common anode type: set LOW to illuminate the LED segment
*/

/*  7 segment display pinout
//    |--CA--|
//    CF     CB
//    |--CG--|
//    CE     CC
//    |--CD--|  DP
*/

/*
//  set AN to LOW to enable the digit
*/

module svn_dcdr (
    input   [3:0]   in,     // MSB->LSB in[3],in[2],in[1],in[0]
    input           dp_in,  // active high
    input   [7:0]   AN_in,
    output          CA,
    output          CB,
    output          CC,
    output          CD,
    output          CE,
    output          CF,
    output          CG,
    output          DP,

    output  [7:0]   AN        
);

//  invoke every digit
    assign AN = AN_in;

//  "ternary operator": <expression 1> ? <expression 2> : <expression 3>
//  Example: https://www.chipverify.com/verilog/verilog-conditional-statements

//  The underscore character _ is ignored. This feature can be used to break up long numbers for readability purposes.
    assign {CA, CB, CC, CD, CE, CF, CG} =   (in == 4'h0) ? (7'b0_00_0_00_1):
                                            (in == 4'h1) ? (7'b1_00_1_11_1):
                                            (in == 4'h2) ? (7'b0_01_0_01_0):
                                            (in == 4'h3) ? (7'b0_00_0_11_0):
                                            (in == 4'h4) ? (7'b1_00_1_10_0):
                                            (in == 4'h5) ? (7'b0_10_0_10_0):
                                            (in == 4'h6) ? (7'b0_10_0_00_0):
                                            (in == 4'h7) ? (7'b0_00_1_11_1):
                                            (in == 4'h8) ? (7'b0_00_0_00_0):
                                            (in == 4'h9) ? (7'b0_00_0_10_0):
                                            (in == 4'ha) ? (7'b1_11_0_01_0):
                                            (in == 4'hb) ? (7'b1_10_0_11_0):
                                            (in == 4'hc) ? (7'b1_01_1_10_0):
                                            (in == 4'hd) ? (7'b0_11_0_10_0):
                                            (in == 4'he) ? (7'b1_11_0_00_0):
                                                           (7'b1_11_1_11_1);
    assign DP = ~dp_in;
endmodule
