`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2024 08:30:07 PM
// Design Name: 
// Module Name: LUT_ROM
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


module LUT_ROM (
    input [5:0] address,              
    output reg [31:0] coeff_out       
);
    reg [31:0] coeffs [0:15]; 

    initial begin
        coeffs[0] = 32'h00000000; // Coefficient for segment 0
        coeffs[1] = 32'h0000644;  // Coefficient for segment 1
        coeffs[2] = 32'h0000C89;  // Coefficient for segment 2
        coeffs[3] = 32'h00010C4;  // Coefficient for segment 3
        coeffs[4] = 32'h00014E3;  // Coefficient for segment 4
        coeffs[5] = 32'h0001880;  // Coefficient for segment 5
        coeffs[6] = 32'h0001C3D;  // Coefficient for segment 6
        coeffs[7] = 32'h0001F40;  // Coefficient for segment 7
        coeffs[8] = 32'h0001FF2;  // Coefficient for segment 8
        coeffs[9] = 32'h0002294;  // Coefficient for segment 9
        coeffs[10] = 32'h00024D3; // Coefficient for segment 10
        coeffs[11] = 32'h00026F7; // Coefficient for segment 11
        coeffs[12] = 32'h00028B0; // Coefficient for segment 12
        coeffs[13] = 32'h0002A20; // Coefficient for segment 13
        coeffs[14] = 32'h0002B60; // Coefficient for segment 14
        coeffs[15] = 32'h0000FFFF; // Coefficient for segment 15 
    end

    always @(*) begin
        coeff_out = coeffs[address]; // Read the coefficient from ROM
    end
endmodule
