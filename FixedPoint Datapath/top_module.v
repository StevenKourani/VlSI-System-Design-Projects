`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2024 08:05:20 PM
// Design Name: 
// Module Name: top_module
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


module top_module #(parameter WI1 = 8,    
                  parameter WI2 = 8,   
                  parameter WF1 = 8,    
                  parameter WF2 = 8,    
                  parameter WIO = 8,    
                  parameter WFO = 8    
)(  input CLK, RST, EN,                
    input signed [WI1 + WF1 - 1 : 0] x,  
    output signed [WIO + WFO - 1 : 0] y,  
    output OV                     
);
 
 wire [WIO + WFO - 1 : 0] x_squared;
 reg signed [WI1 + WF1 - 1 : 0] regx1;
 reg signed [WIO + WFO - 1 : 0] regx2;
 
  fixedpoint_multiplier #(WI1, WI1, WF1, WF1, WIO, WFO) M00 (
        .data_in1(x),
        .data_in2(x),
        .data_out(x_squared)
    );
    
    
    always@(posedge CLK) begin
        if(RST) begin
            regx1 <= 0;
            regx2 <= 0;
         end else if (EN) begin
             regx1 <= x;
             regx2 <= x_squared;
         end
    end
    
     fixedpoint_adder #(WI1, WI1, WF1, WF1, WIO, WFO) A00 (
      .data_in1(regx1),
      .data_in2(regx2),
      .data_out(y),
      .OV(OV)
  );
 



endmodule
