`timescale 1ns / 1ps

module tb_kpd_dtct_all_notes;

    // Inputs
    reg sys_clk;
    reg sys_rst_n;
    
    // Keypad Columns (Inputs to FPGA)
    reg E;
    reg F;
    reg G;

    // Outputs
    // Keypad Rows (Outputs from FPGA)
    wire A;
    wire B;
    wire C;
    wire D;
    
    // Speaker Output
    wire tone;

    // Instantiate the Top Module (Unit Under Test)
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
        .tone(tone)
    );

    // 100MHz System Clock Generation (10ns period)
    always #5 sys_clk = ~sys_clk;

    // Virtual Keyboard Register
    reg [3:0] key_to_press;

    // --- Physical Keypad Simulation Logic ---
    // This connects the active Row (A, B, C, D) to the correct Column (E, F, G)
    // based on which key we tell the testbench to press.
    always @(*) begin
        E = 1'b0; F = 1'b0; G = 1'b0; // Default: No connection
        
        if (key_to_press != 4'hf) begin
            case (key_to_press)
                // Top Row (Row D)
                4'h1: if (D) G = 1'b1;
                4'h2: if (D) F = 1'b1;
                4'h3: if (D) E = 1'b1;
                // Second Row (Row C)
                4'h4: if (C) G = 1'b1;
                4'h5: if (C) F = 1'b1;
                4'h6: if (C) E = 1'b1;
                // Third Row (Row B)
                4'h7: if (B) G = 1'b1;
                4'h8: if (B) F = 1'b1;
                4'h9: if (B) E = 1'b1;
                // Bottom Row (Row A)
                4'hc: if (A) G = 1'b1; // '*' key
                4'h0: if (A) F = 1'b1; // '0' key
                4'hb: if (A) E = 1'b1; // '#' key
                default: begin E=0; F=0; G=0; end
            endcase
        end
    end

    // Helper task to make pressing keys easier to read in the code
    task press_virtual_key(input [3:0] k);
        begin
            key_to_press = k;
            #15000000; // Hold the key down for 15ms so the tone plays
            key_to_press = 4'hf; // Release the key
            #5000000;  // Wait 5ms in silence before the next press
        end
    endtask

    initial begin
        // --- Initialization ---
        sys_clk = 0;
        sys_rst_n = 0;
        key_to_press = 4'hf; // 'f' means no key is pressed
        
        $display("Starting Full Keypad & Tone Simulation...");

        // Release reset
        #100;
        sys_rst_n = 1;
        #500000; 

        // --- Test All 12 Keys ---
        $display("[%0t] Pressing '1' (Note C4)", $time);
        press_virtual_key(4'h1);

        $display("[%0t] Pressing '2' (Note D4)", $time);
        press_virtual_key(4'h2);

        $display("[%0t] Pressing '3' (Note E4)", $time);
        press_virtual_key(4'h3);

        $display("[%0t] Pressing '4' (Note F4)", $time);
        press_virtual_key(4'h4);

        $display("[%0t] Pressing '5' (Note G4)", $time);
        press_virtual_key(4'h5);

        $display("[%0t] Pressing '6' (Note A4)", $time);
        press_virtual_key(4'h6);

        $display("[%0t] Pressing '7' (Note B4)", $time);
        press_virtual_key(4'h7);

        $display("[%0t] Pressing '8' (Note C5)", $time);
        press_virtual_key(4'h8);

        $display("[%0t] Pressing '9' (Note D5)", $time);
        press_virtual_key(4'h9);

        $display("[%0t] Pressing '*' (Note E5)", $time);
        press_virtual_key(4'hc);

        $display("[%0t] Pressing '0' (Note F5)", $time);
        press_virtual_key(4'h0);

        $display("[%0t] Pressing '#' (Note G5)", $time);
        press_virtual_key(4'hb);

        $display("[%0t] Simulation Finished.", $time);
        $finish;
    end

endmodule