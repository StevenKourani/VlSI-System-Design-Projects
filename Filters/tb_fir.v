`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2024 06:16:38 PM
// Design Name: 
// Module Name: tb_fir
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

module tb_fir;

    // Inputs
    reg clk;
    reg rst;
    reg signed [11:0] filter_in;

    // Outputs
    wire signed [31:0] filter_out;

    fir_filter uut (
        .clk(clk), 
        .rst(rst), 
        .x_in(filter_in), 
        .y_out(filter_out)
    );

    // Define reset time
    initial begin
        rst = 0;
        #15;
        rst = 1;
    end

    // Define clock
    initial begin
        clk = 0;
        forever #10 clk = ~clk;    
    end

    // Define RAM to store input signal, should be large enough for 4000 entries
    reg signed[11:0] mem[3999:0]; // Adjusted size to 4000 (0-3999)

    // Read data from disk
    initial begin
        $readmemb("C:/Users/steve/Downloads/Neural_Signal_Sample.txt", mem);
    end

    // Send data to filter
    integer i = 0;
    initial begin
        #15; // Wait for reset
        for (i = 0; i < 4000; i = i + 1) begin
            filter_in = mem[i];
            #20; // Wait for a clock cycle to allow filtering
        end    
    end

    // Write data to txt File
    integer file;
    integer cnt = 0;

    initial begin
        file = $fopen("C:/Users/steve/Downloads/dataout2.txt", "w");
    end

    // Write filtered data to txt file
    always @(posedge clk) begin
        if (cnt < 4000) begin // Only write if we have not reached 4000 outputs
            $fdisplay(file, filter_out);
            $display("data out (%d)------> : %d", cnt, filter_out);
            cnt = cnt + 1; // Increment output count
        end else if (cnt == 4000) begin
            $fclose(file); // Close the file when done
            #20 rst = 0; // Optionally reset the system
            #20 $stop; // Stop the simulation
        end
    end
    
endmodule
