`timescale 1ns / 1ps

module tb_cntr_ds;

    // Inputs
    reg sys_clk;
    reg sys_rst_n;
    reg dir;
    reg fq;
    reg pause_flow;
    reg pause_clk;

    // Outputs
    wire CA, CB, CC, CD, CE, CF, CG, DP;
    wire [7:0] AN;

    // Instantiate the Unit Under Test (UUT)
    cntr_ds uut (
        .sys_clk(sys_clk), 
        .sys_rst_n(sys_rst_n), 
        .dir(dir), 
        .fq(fq), 
        .pause_flow(pause_flow), 
        .pause_clk(pause_clk), 
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

    // 100MHz System Clock Generation (10ns period)
    always #5 sys_clk = ~sys_clk;

    initial begin
        // --- Initialization ---
        sys_clk = 0;
        sys_rst_n = 0;
        
        // Default states for testing
        dir = 1'b1;         // Start with MSB to LSB sliding (count UP)
        fq = 1'b0;          // Fast mode to quickly observe seconds/minutes changing
        pause_flow = 1'b0;  // Marquee is moving
        pause_clk = 1'b0;   // Clock is ticking
        
        $display("Starting Simulation...");

        // Wait 100 ns for global reset to finish, then release reset
        #100;
        sys_rst_n = 1;

        // --- Requirement III: High frequency testing ---
        // Setting fq = 0 makes cvtr_4bit tick every 10,000 cycles (100us in simulation)
        // This allows us to quickly see seconds and minutes roll over.
        $display("[%0t] Mode: Normal Flow (dir=1), Fast Clock (fq=0)", $time);
        #3000000; // Wait 3ms (simulated) to watch multiple seconds/minutes tick up.

        // --- Requirement II: Change marquee direction ---
        // Setting dir = 0 makes the cntr_5bit count DOWN, reversing the marquee.
        $display("[%0t] Mode: Reverse Flow (dir=0)", $time);
        dir = 1'b0; 
        #2000000; // Observe reverse scrolling

        // --- Requirement IV: Stop the movement of the marquee ---
        // Setting pause_flow = 1 freezes cntr_5bit. 
        // The clock still ticks, but the text stops sliding.
        $display("[%0t] Mode: Pause Marquee Flow (pause_flow=1)", $time);
        pause_flow = 1'b1;
        #1500000; 
        pause_flow = 1'b0; // Resume sliding
        $display("[%0t] Mode: Resume Marquee Flow (pause_flow=0)", $time);
        #1000000;

        // --- Requirement IV: Stop the clock from counting ---
        // Setting pause_clk = 1 freezes cvtr_4bit.
        // The text continues sliding, but time is frozen.
        $display("[%0t] Mode: Pause Digital Clock (pause_clk=1)", $time);
        pause_clk = 1'b1;
        #1500000;
        pause_clk = 1'b0; // Resume time
        $display("[%0t] Mode: Resume Digital Clock (pause_clk=0)", $time);
        #1000000;

        // --- Requirement III: Low frequency (Real-time mode) ---
        // Setting fq = 1 sets the divisor to 10,000,000 (slower tick)
        $display("[%0t] Mode: Slow Clock (fq=1)", $time);
        fq = 1'b1;
        #2000000;

        // End simulation
        $display("[%0t] Simulation Completed.", $time);
        $finish;
    end

endmodule