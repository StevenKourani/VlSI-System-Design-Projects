`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2024 06:44:14 PM
// Design Name: 
// Module Name: tb_fixedpoint_mult
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


module tb_fixedpoint_mult;

    parameter WI1 = 4, WF1 = 5; 
    parameter WI2 = 3, WF2 = 3; 
    parameter WIO = WI1 + WI2;
    parameter WFO = WF1 + WF2;
    reg signed [WI1 + WF1 - 1:0] data_in1;
    reg signed [WI2 + WF2 - 1:0] data_in2;
    wire signed [WIO + WFO - 1:0] data_out; 

    fixedpoint_multiplier #(WI1, WI2, WF1, WF2, WIO, WFO) uut (
        .data_in1(data_in1),
        .data_in2(data_in2),
        .data_out(data_out)
    );


    initial begin

        data_in1 = 0;
        data_in2 = 0;

        #10 


        data_in1 = 9'b0100_10101;  // 4.625 in fixed-point (4.5 format)
        data_in2 = 6'b011_101;     // 3.625 in fixed-point (3.3 format)

        #20 

        $display("Output: %b (%f)", data_out, $signed(data_out) * 1.0 / (1 << WFO));
    $finish; 
    end

endmodule
