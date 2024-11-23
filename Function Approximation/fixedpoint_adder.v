`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2024 08:11:21 PM
// Design Name: 
// Module Name: fixedpoint_adder
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


module fixedpoint_adder#(
    parameter WI1 = 8,    
    parameter WI2 = 8,   
    parameter WF1 = 8,   
    parameter WF2 = 8,    
    parameter WIO = 8,    
    parameter WFO = 8    
)(                     
    input signed [WI1 + WF1 - 1 : 0] data_in1,  
    input signed [WI2 + WF2 - 1 : 0] data_in2,  
    output signed [WIO + WFO - 1 : 0] data_out, 
    output OV                     
);

    wire signed [WIO + WFO - 1 : 0] extended_data_in1;
    wire signed [WIO + WFO - 1 : 0] extended_data_in2;
    wire signed [WIO + WFO : 0] sum;  

    assign extended_data_in1[WFO - 1 : 0] = (WF1 < WFO) ? {data_in1[WF1 - 1 : 0], {WFO - WF1{1'b0}}} : data_in1[WF1 + WFO - 1 : 0];
    assign extended_data_in2[WFO - 1 : 0] = (WF2 < WFO) ? {data_in2[WF2 - 1 : 0], {WFO - WF2{1'b0}}} : data_in2[WF2 + WFO - 1 : 0];

    assign extended_data_in1[WIO + WFO - 1 : WFO] = (WI1 < WIO) ? { {WIO - WI1{data_in1[WI1 + WF1 - 1]}}, data_in1[WI1 + WF1 - 1 : WF1] } : data_in1[WIO + WFO - 1 : WF1];
    assign extended_data_in2[WIO + WFO - 1 : WFO] = (WI2 < WIO) ? { {WIO - WI2{data_in2[WI2 + WF2 - 1]}}, data_in2[WI2 + WF2 - 1 : WF2] } : data_in2[WIO + WFO - 1 : WF2];

    assign  sum = extended_data_in1 + extended_data_in2;

    assign data_out = sum[WIO + WFO - 1 : 0];

    assign OV = (sum[WIO + WFO] != 0);

endmodule

