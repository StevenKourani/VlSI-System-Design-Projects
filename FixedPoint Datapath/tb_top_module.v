`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2024 08:23:24 PM
// Design Name: 
// Module Name: tb_top_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_top_module;

    // Parameters for the top module
    parameter WI1 = 8;    
    parameter WF1 = 8;    
    parameter WIO = 8;    
    parameter WFO = 8;    

    // Inputs
    reg CLK;                
    reg RST;                
    reg EN;                
    reg signed [WI1 + WF1 - 1 : 0] x;  
    
    // Outputs
    wire signed [WIO + WFO - 1 : 0] y;  
    wire OV;                     

    // Instantiate the top module
    top_module #(WI1, WI1, WF1, WF1, WIO, WFO) uut (
        .CLK(CLK),
        .RST(RST),
        .EN(EN),
        .x(x),
        .y(y),
        .OV(OV)
    );

    // Clock generation
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;  // 10 ns clock period
    end

    // Test sequence
    initial begin
        // Initialize inputs
        RST = 1;   // Assert reset
        EN = 0;    // Disable processing
        x = 0;

        // Wait for a clock cycle
        #10; 
        
        // Release reset
        RST = 0;  
        
        // Set input x to 4.5 (binary: 0100.1000)
        x = 8'b01001000;  // 4.5 in fixed-point representation
        
        // Enable processing
        EN = 1;

        // Wait for a couple of clock cycles to observe the output
        #20;  
        
        // Disable processing
        EN = 0;

        // Wait some time to finish the simulation
        #20;  
        
        // Finish simulation
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %0t | x: %b | y: %b | OV: %b", $time, x, y, OV);
    end

endmodule

