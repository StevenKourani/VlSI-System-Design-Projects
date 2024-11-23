`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2024 06:24:26 PM
// Design Name: 
// Module Name: fixedpoint_mult
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


module fixedpoint_mult#(parameter WI1 = 8, WI2 = 8, WF1 = 8, WF2 = 8, WIO = WI1 + WI2, WFO = WF1 + WF2)
                              (input signed [WI1 + WF1 - 1 : 0] data_in1,
                              input signed [WI2 + WF2 - 1 : 0] data_in2,
                              output signed [WIO + WFO - 1 : 0] data_out);
                              
    
    wire signed [WI1 + WI2 + WF1 + WF2 - 1 : 0] product;

    assign product = data_in1 * data_in2;

    assign data_out = product[WI1 + WI2 + WF1 + WF2 - 1 - (WF1 + WF2 - WFO) : WF1 + WF2 - WFO];

endmodule


