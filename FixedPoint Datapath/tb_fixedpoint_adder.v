`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2024 05:44:32 PM
// Design Name: 
// Module Name: tb_fixedpoint_adder
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


module tb_fixedpoint_adder;

  // Parameters for the input and output bit widths
  parameter WI1 = 4;   // Integer width of data_in1
  parameter WF1 = 5;   // Fractional width of data_in1
  parameter WI2 = 3;   // Integer width of data_in2
  parameter WF2 = 3;   // Fractional width of data_in2
  parameter WIO = 4;   // Integer width of data_out (result)
  parameter WFO = 5;   // Fractional width of data_out (result)

  // Testbench signals
  reg signed [WI1 + WF1 - 1 : 0] data_in1; // Input 1
  reg signed [WI2 + WF2 - 1 : 0] data_in2; // Input 2
  wire signed [WIO + WFO - 1 : 0] data_out; // Output
  wire OV; // Overflow flag

  // Instantiate the fixed-point adder
  fixedpoint_adder #(WI1, WI2, WF1, WF2, WIO, WFO) uut (
      .data_in1(data_in1),
      .data_in2(data_in2),
      .data_out(data_out),
      .OV(OV)
  );

  initial begin

    data_in1 = 0;
    data_in2 = 0;
    #20 



    data_in1 = 9'b0100_10101; // 4.10101 (4 + 0.625 = 4.625)
    data_in2 = 6'b011_101;    // 3.101 (3 + 0.625 = 3.625)

    #10;  // Wait for the result to stabilize
    

    // Finish simulation after checking one test case
    #100;
    $finish;
  end

  // Monitor the signals and print to the console
  initial begin
    $monitor("At time %t: data_in1=%b, data_in2=%b, data_out=%b, OV=%b",
              $time, data_in1, data_in2, data_out, OV);
  end

endmodule

