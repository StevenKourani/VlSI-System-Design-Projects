`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2024 08:33:02 PM
// Design Name: 
// Module Name: TopModule
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

module TopModule #(
    parameter WI = 8,   
    parameter WF = 8   
)(
    input wire clk,                   
    input wire rst,                   
    input wire [WI+WF-1:0] x,        
    output reg [WI+WF-1:0] y           
);

    wire [5:0] segmentIndex;         
    reg [5:0] segmentIndex_reg;       
    wire [31:0] lutOutput;            
    reg [31:0] lutOutput_reg;         
    wire [WI+WF-1:0] mulOutput;
    reg [WI+WF-1:0] mulOutput_reg;  
    wire [WI+WF-1:0] addOutput;      

    segment_decoder #(
        .WI(WI),
        .WF(WF)
    ) seg_decoder (
        .x(x),
        .segmentIndex(segmentIndex)
    );

    // Register the output of the Segment Decoder
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            segmentIndex_reg <= 0;
        end else begin
            segmentIndex_reg <= segmentIndex;
        end
    end

    LUT_ROM lut_instance (
        .address(segmentIndex_reg),
        .coeff_out(lutOutput)
    );

    // Register the output of the LUT ROM
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lutOutput_reg <= 0;
        end else begin
            lutOutput_reg <= lutOutput;
        end
    end

    fixedpoint_mult #(
        .WI1(WI), .WF1(WF), .WI2(WI), .WF2(WF)
    ) multiplier (
        .data_in1(x),
        .data_in2(lutOutput_reg[15:0]),  // 16-bit lower part of LUT output
        .data_out(mulOutput)
    );

    // Register the output of the Multiplier
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mulOutput_reg <= 0;
        end else begin
            mulOutput_reg <= mulOutput;
        end
    end

    fixedpoint_adder #(
        .WI1(WI), .WF1(WF), .WI2(WI), .WF2(WF)
    ) adder (
        .data_in1(mulOutput_reg),
        .data_in2(lutOutput_reg[31:16]), // 16-bit upper part of LUT output
        .data_out(addOutput),
        .OV()  
    );

    // Register the final output
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 0;  
        end else begin
            y <= addOutput; 
        end
    end

endmodule