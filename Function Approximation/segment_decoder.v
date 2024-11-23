`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2024 08:13:33 PM
// Design Name: 
// Module Name: segment_decoder
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


module segment_decoder #(
    parameter WI = 8,
    parameter WF = 8
)(
    input [WI + WF -1:0] x,
    output reg [5:0] segmentIndex
);

    reg [15:0] segmentBounds [0:15];

    initial begin
        segmentBounds[0] = 16'h0000; 
        segmentBounds[1] = 16'h0644; 
        segmentBounds[2] = 16'h0C89; 
        segmentBounds[3] = 16'h10C4; 
        segmentBounds[4] = 16'h14E3; 
        segmentBounds[5] = 16'h1880; 
        segmentBounds[6] = 16'h1C3D; 
        segmentBounds[7] = 16'h1F40; 
        segmentBounds[8] = 16'h1FF2; 
        segmentBounds[9] = 16'h2294; 
        segmentBounds[10] = 16'h24D3; 
        segmentBounds[11] = 16'h26F7; 
        segmentBounds[12] = 16'h28B0; 
        segmentBounds[13] = 16'h2A20; 
        segmentBounds[14] = 16'h2B60; 
        segmentBounds[15] = 16'hFFFF; // Boundaries in fixed-point representation
    end

    integer i;

    always @(*) begin
        segmentIndex = 6'b0; 
        for (i = 0; i < 16; i = i + 1) begin
            if (x <= segmentBounds[i]) begin
                segmentIndex = i;  // Set segment index
            end
        end
    end
endmodule