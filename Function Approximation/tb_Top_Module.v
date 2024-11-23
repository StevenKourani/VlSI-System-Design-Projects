`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2024 08:40:05 PM
// Design Name: 
// Module Name: tb_Top_Module
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

module tb_Top_Module;

    parameter WI = 8;
    parameter WF = 8;

    reg clk;
    reg rst;
    reg [WI + WF - 1:0] x;
    wire [WI + WF - 1:0] y;

    TopModule #(
        .WI(WI),
        .WF(WF)
    ) uut (
        .clk(clk),
        .rst(rst),
        .x(x),
        .y(y)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end

    initial begin
        rst = 1;
        x = 0;

        #10;
        rst = 0;

        // test cases
        #10 x = 16'h0000;  // Test case 1: lower bound
        #10 x = 16'h0644;  // Test case 2: test within lower bounds
        #10 x = 16'h0C89;  // Test case 3: test within mid-range
        #10 x = 16'h10C4;  // Test case 4: test another mid-range value
        #10 x = 16'hFFFF;  // Test case 5: upper bound
        #10 x = 16'h0001;  // Test case 6: small positive value
        #10 x = 16'h1234;  // Test case 7: arbitrary value
        #10 x = 16'h8000;  // Test case 8: large negative value in fixed-point representation
        #10 x = 16'h7FFF;  // Test case 9: large positive value close to max
        #10 x = 16'h4000;  // Test case 10: mid-range positive value
        #10 x = 16'h3FFF;  // Test case 11: another mid-range positive value
        #10 x = 16'h8001;  // Test case 12: small negative value close to large negative bound
        #10 x = 16'h7FFE;  // Test case 13: positive value close to large positive bound

        #20;
        $finish;
    end

    initial begin
        $display("Time | x        | y");
        $monitor("%0d | %h | %h", $time, x, y);
    end

endmodule
