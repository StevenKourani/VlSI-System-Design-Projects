`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/15/2024 01:42:32 PM
// Design Name: 
// Module Name: tb_reference_design
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


module tb_reference_design;

    // Parameters
    parameter WL = 32; 

    // Inputs
    reg CLK;
    reg RST;
    reg EN;
    reg signed [WL-1:0] data_in;

    // Outputs
    wire signed [WL-1:0] data_out;

    reference_design #(.WL(WL)) uut (
        .CLK(CLK),
        .RST(RST),
        .EN(EN),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;  
    end

    // Test vectors
    initial begin
        // Initialize inputs
        RST = 1;  
        EN = 0;
        data_in = 0;

        #20;
        
        RST = 0;
        EN = 1;

        data_in = 32'd2;  // Input sample 1
        #10;
        data_in = 32'd3;  // Input sample 2
        #10;
        data_in = 32'd4;  // Input sample 3
        #10;
        data_in = 32'd5;  // Input sample 4
        #10
        data_in = 32'd6;  // Input sample 5
        #10;
        data_in = 32'd7;  // Input sample 6
        #10;
        data_in = 32'd8;  // Input sample 7
        #10
        data_in = 32'd9;  // Input sample 8
        #10;

        data_in = 0;
        EN = 0;
        #50;
        
        $finish;
    end

    initial begin
        $monitor("Time = %d, data_in = %d, data_out = %d", $time, data_in, data_out);
    end

endmodule
