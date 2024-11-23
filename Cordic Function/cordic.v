`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2024 04:47:25 PM
// Design Name: 
// Module Name: cordic
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

module cordic #(
    parameter WI = 4, 
    parameter WF = 6, 
    parameter ITERATIONS = 10, 
    parameter ANGLE_WIDTH = 16,
    parameter WL = WI + WF
)(
    input wire clk,
    input wire rst,
    input wire start,
    input wire signed [ANGLE_WIDTH-1:0] angle,
    output reg signed [2*WL - 1:0] sine_cosine_out  
);

    
    localparam CORDIC_GAIN = {1'b0, 4'b0100, 6'b110110}; // ~0.607253 in fixed-point (1.4.6 format)

    // Define CORDIC angle table (in fixed-point format)
    reg signed [ANGLE_WIDTH-1:0] atan_table [0:ITERATIONS-1];
    initial begin
        atan_table[0] = 16'b0011001001000011; // atan(2^0) = 45.000 degrees
        atan_table[1] = 16'b0001110110101100; // atan(2^-1) = 26.565 degrees
        atan_table[2] = 16'b0000111110101101; // atan(2^-2) = 14.036 degrees
        atan_table[3] = 16'b0000011111110101; // atan(2^-3) = 7.125 degrees
        atan_table[4] = 16'b0000001111111110; // atan(2^-4) = 3.576 degrees
        atan_table[5] = 16'b0000000111111111; // atan(2^-5) = 1.790 degrees
        atan_table[6] = 16'b0000000100000000; // atan(2^-6) = 0.895 degrees
        atan_table[7] = 16'b0000000010000000; // atan(2^-7) = 0.448 degrees
        atan_table[8] = 16'b0000000001000000; // atan(2^-8) = 0.224 degrees
        atan_table[9] = 16'b0000000000100000; // atan(2^-9) = 0.112 degrees
    end

    reg signed [WL:0] x, y, x_next, y_next; // Include sign bit
    reg signed [ANGLE_WIDTH-1:0] z, z_next;
    reg [3:0] iteration;
    reg calculating;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x <= CORDIC_GAIN;
            y <= 0;
            z <= 0;
            iteration <= 0;
            calculating <= 0;
            sine_cosine_out <= 0;
        end else if (start && !calculating) begin
            x <= CORDIC_GAIN; 
            y <= 0;
            z <= angle; 
            iteration <= 0;
            calculating <= 1;
        end else if (calculating) begin
            x <= x_next;
            y <= y_next;
            z <= z_next;
            iteration <= iteration + 1;
            if (iteration == ITERATIONS - 1) begin
                calculating <= 0;
                sine_cosine_out <= {y_next, x_next};  // Concatenate sine and cosine
            end
        end
    end

    always @(*) begin
        if (z[ANGLE_WIDTH-1] == 0) begin 
            x_next = x - (y >>> iteration);
            y_next = y + (x >>> iteration);
            z_next = z - atan_table[iteration];
        end else begin 
            x_next = x + (y >>> iteration);
            y_next = y - (x >>> iteration);
            z_next = z + atan_table[iteration];
        end
    end

endmodule
