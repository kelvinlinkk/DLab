`timescale 1ns / 1ps

module tb_kpd_dtct;

    // Inputs
    reg sys_clk;
    reg sys_rst_n;
    reg E;
    reg F;
    reg G;

    // Outputs
    wire A;
    wire B;
    wire C;
    wire D;
    wire CA;
    wire CB;
    wire CC;
    wire CD;
    wire CE;
    wire CF;
    wire CG;
    wire DP;
    wire [7:0] AN;

    // Instantiate the Unit Under Test (UUT)
    kpd_dtct uut (
        .sys_clk(sys_clk), 
        .sys_rst_n(sys_rst_n), 
        .E(E), 
        .F(F), 
        .G(G), 
        .A(A), 
        .B(B), 
        .C(C), 
        .D(D), 
        .CA(CA), 
        .CB(CB), 
        .CC(CC), 
        .CD(CD), 
        .CE(CE), 
        .CF(CF), 
        .CG(CG), 
        .DP(DP), 
        .AN(AN)
    );

    // Clock generation (100MHz -> 10ns period)
    always #5 sys_clk = ~sys_clk;

    initial begin
        // Initialize Inputs
        sys_clk = 0;
        sys_rst_n = 0;
        E = 0;
        F = 0;
        G = 0;

        // Wait 100 ns for global reset to finish
        #100;
        sys_rst_n = 1; // Release reset
        
        // Wait for the counter to start scanning
        // Note: CNT_1S_MAX is 100,000, so each scan step takes 1ms in real time.
        // In simulation, we wait a sufficient amount of time to observe the scan lines changing.
        #2000000; 
        
        // Simulate a button press
        // Assuming we want to press the button at Row 0 (A is high), Column G
        // We must wait until A is active, but for a simple testbench, we can 
        // assert G for a duration long enough to overlap with the 'A' scan window.
        $display("Simulating button press on column G...");
        G = 1; 
        
        // Hold the button for 5ms to ensure it is caught by at least one full scan cycle
        #5000000; 
        G = 0; // Release button
        
        // Wait to observe the latched value on the 7-segment display outputs
        #2000000;
        
        // Simulate another button press (Column E)
        $display("Simulating button press on column E...");
        E = 1;
        #5000000;
        E = 0;
        
        #2000000;
        
        $display("Simulation complete.");
        $finish;
    end
      
endmodule