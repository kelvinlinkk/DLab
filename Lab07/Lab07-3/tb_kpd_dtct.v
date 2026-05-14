`timescale 1ns / 1ps

module tb_kpd_dtct;

    // Inputs
    reg sys_clk;
    reg sys_rst_n;
    reg next;
    reg previous;

    // Outputs
    wire CA, CB, CC, CD, CE, CF, CG, DP;
    wire [7:0] AN;

    // Instantiate the Unit Under Test (UUT)
    kpd_dtct uut (
        .sys_clk(sys_clk), 
        .sys_rst_n(sys_rst_n), 
        .next(next), 
        .previous(previous), 
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

    // --- Virtual Button Press Tasks ---
    // These tasks simulate a human pressing a button. 
    // They hold the button high for 50 microseconds, then release it.
    task press_next;
        begin
            next = 1'b1;
            #50000; 
            next = 1'b0;
            #50000; 
        end
    endtask

    task press_previous;
        begin
            previous = 1'b1;
            #50000;
            previous = 1'b0;
            #50000;
        end
    endtask

    initial begin
        // --- Initialization ---
        sys_clk = 0;
        sys_rst_n = 0;
        next = 0;
        previous = 0;

        $display("Starting Up/Down Counter Simulation...");

        // Wait 100 ns for global reset to finish, then release
        #100;
        sys_rst_n = 1;
        #1000;

        // --- Test 1: Increment ---
        // Verify it counts up normally (0 -> 1 -> 2 -> 3)
        $display("[%0t] Testing Increment (Next button)", $time);
        press_next(); 
        press_next(); 
        press_next(); 

        // --- Test 2: Decrement ---
        // Verify it counts down normally (3 -> 2 -> 1)
        $display("[%0t] Testing Decrement (Previous button)", $time);
        press_previous(); 
        press_previous(); 

        // --- Test 3: Underflow Check ---
        // Verify 0 wraps backwards to 15 (0xF)
        $display("[%0t] Testing Underflow (0 -> 15)", $time);
        press_previous(); // 1 -> 0
        press_previous(); // 0 -> 15

        // --- Test 4: Overflow Check ---
        // Verify 15 wraps forwards to 0
        $display("[%0t] Testing Overflow (15 -> 0)", $time);
        press_next();     // 15 -> 0

        // Allow some time to observe final state
        #10000;
        
        $display("[%0t] Simulation Finished.", $time);
        $finish;
    end

endmodule