`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2024 04:49:58 PM
// Design Name: 
// Module Name: tb_cordic
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


module tb_cordic;

    // Parameters
    parameter WI = 4; 
    parameter WF = 6;  
    parameter ANGLE_WIDTH = 16;
    parameter CLK_PERIOD = 10; 
    parameter ITERATIONS = 10; 
    parameter WL = WI + WF; 

  
    reg clk;
    reg rst;
    reg start;
    reg signed [ANGLE_WIDTH-1:0] angle;
    wire signed [2*WL-1:0] sine_cosine_out; 

    
    cordic #(
        .WI(WI),
        .WF(WF),
        .ANGLE_WIDTH(ANGLE_WIDTH),
        .ITERATIONS(ITERATIONS)
    ) uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .angle(angle),
        .sine_cosine_out(sine_cosine_out)
    );

    always #(CLK_PERIOD/2) clk = ~clk;

    integer file, i;

    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        angle = 0;

        file = $fopen("cordic_output.txt", "w");
        if (file == 0) begin
            $display("Error: Could not open file");
            $finish;
        end

        #(CLK_PERIOD*2);
        rst = 0;

        // Test for angles from 0 to 360 degrees in 10-degree increments
        for (i = 0; i <= 36; i = i + 1) begin
            angle = (i * 10 * (1 << ANGLE_WIDTH)) / 360; // Fixed-point conversion

            start = 1;
            #(CLK_PERIOD);
            start = 0;

            #(CLK_PERIOD * (ITERATIONS + 1));

            $fwrite(file, "%d,%d,%d\n", i*10, $signed(sine_cosine_out[WL + WF - 1:WF]), $signed(sine_cosine_out[WF - 1:0])); // Adjust indices for sine and cosine
        end

        $fclose(file);

        $finish;
    end

endmodule


