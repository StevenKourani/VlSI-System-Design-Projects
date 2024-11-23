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
    // Parameters for the moving average filter
    parameter IN_WIDTH = 12;       // Input width (Q2.10)
    parameter OUT_WIDTH = 32;      // Output width (Q2.30)
    parameter WINDOW_SIZE = 4;     // Number of samples for moving average

    // Inputs
    reg clk;
    reg reset;                    
    reg en;
    reg signed [IN_WIDTH-1:0] filter_in;

    // Outputs
    wire signed [OUT_WIDTH-1:0] filter_out;

    reference_design uut (
        .data_in(filter_in), 
        .EN(en), 
        .CLK(clk), 
        .RST(reset), 
        .data_out(filter_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 100 MHz clock
    end

    // Reset generation
    initial begin
        filter_in = 0;  // Initialize input
        reset = 1;      // Active high reset
        en = 0;
        #100;          // Hold in reset longer
        reset = 0;     // Release reset
        #20;           // Wait before enabling
        en = 1;        // Enable the moving average filter
    end

    // Read data from file
    reg signed [IN_WIDTH-1:0] mem[0:3999];  // Array for 4000 samples
    initial begin
        $readmemb("C:/Users/steve/Downloads/Neural_Signal_Sample.txt", mem);
    end

    // Send data to the filter
    integer i;
    initial begin
        #150;  // Wait for reset and enable sequence to complete
        for (i = 0; i < 4000; i = i + 1) begin
            @(posedge clk);  // Wait for positive clock edge
            filter_in = mem[i];
            #20;  // Wait full clock cycle before next value
        end
        #100;  // Wait for final processing
        en = 0;
    end

    // Write output to file
    integer file;
    initial begin
        file = $fopen("dataout3.txt", "w");
        if (file == 0) begin
            $display("Error: Could not open output file");
            $finish;
        end
    end

    // Write filtered data to the output file
    always @(posedge clk) begin
        if (en && !reset) begin  // Only write when enabled and not in reset
            #5;  // Small delay to allow output to stabilize
            $fwrite(file, "%0d\n", filter_out);
        end
    end

    integer cnt = 0;
    always @(posedge clk) begin
        if (en && !reset) begin
            #5;  
            $display("Time: %0dns | Input: %0d | Output: %0d", $time, filter_in, filter_out);
            cnt = cnt + 1;
            if (cnt == 4000) begin
                #20 $fclose(file);
                $finish;
            end
        end
    end
endmodule