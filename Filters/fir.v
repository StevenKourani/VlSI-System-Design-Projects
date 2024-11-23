`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2024 06:04:02 PM
// Design Name: 
// Module Name: fir
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

module fir(
	input clk,
	input rst,
	input wire signed [11:0] filter_in,
	output reg signed [31:0] filter_out
    );
	
	parameter word_width = 16;
	parameter order = 6;

	// define delay unit , input width is 16  , filter order is 6
	reg signed [word_width-1:0] delay[order-1:0];
	
	// define coef
	wire signed [word_width-1:0]  coef[order:0];
    assign coef[0] = 16'hd7ac;  // h[0]
    assign coef[1] = 16'he464;  // h[1]
    assign coef[2] = 16'hae68;  // h[2]
    assign coef[3] = 16'h5198;  // h[3]
    assign coef[4] = 16'h1b9c;  // h[4]
    assign coef[5] = 16'h2854;  // h[5]

	// define multipler
	reg signed [31:0]  product[order -1 :0];

	// define sum buffer
	reg signed [31:0]  sum_buf;	

	// define input data buffer
	reg signed [order-1:0] data_in_buf;

	// data buffer
	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			data_in_buf <= 0;
		end
		else begin
			data_in_buf <= filter_in;
		end
	end

	// delay units pipeline
	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			delay[0] <= 0 ;
			delay[1] <= 0 ;
			delay[2] <= 0 ;
			delay[3] <= 0 ;
			delay[4] <= 0 ;
			delay[5] <= 0 ;

		end 
		else begin
			delay[0] <= data_in_buf ;
			delay[1] <= delay[0] ;
			delay[2] <= delay[1] ;
			delay[3] <= delay[2] ;
			delay[4] <= delay[3] ;
			delay[5] <= delay[4] ;
			delay[6] <= delay[5] ;

		end
	end

	// implement product with coef 
	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			product[0] <= 0;
			product[1] <= 0;
			product[2] <= 0;
			product[3] <= 0;
			product[4] <= 0;
			product[5] <= 0;

		end
		else begin
			product[0] <= coef[0] * delay[0];
			product[1] <= coef[1] * delay[1];
			product[2] <= coef[2] * delay[2];
			product[3] <= coef[3] * delay[3];
			product[4] <= coef[4] * delay[4];
			product[5] <= coef[5] * delay[5];

		end
	end

	// accumulation
	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			sum_buf <= 0;
		end
		else begin
			sum_buf <= product[0] + product[1]+ product[2]+ product[3]+ product[4]+ product[5];
		end
	end

	always @(sum_buf) begin
		if (!rst) begin
			filter_out = 0;
		end
		else begin
			filter_out = sum_buf[11:0];
		end
	end

endmodule
