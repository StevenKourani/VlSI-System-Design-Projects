`timescale 1ns/1ns
module reference_design (
    input wire CLK,
    input wire RST,
    input wire EN,
    input wire signed [WLI + WLF - 1:0] data_in,  // Q2.10 format (12 bits)
    output reg signed [WOI + WOF - 1:0] data_out   // Q2.30 format (32 bits)
);

    // Parameters for Q format
    localparam WLI = 2;
    localparam WLF = 10;
    localparam WOI = 2;
    localparam WOF = 30;
    localparam L = 4;
    
    reg signed [WLI + WLF - 1:0] window [0:L-1];
    reg signed [WOI + WOF - 1:0] sum;  
    integer i;


    always @(posedge CLK) begin
        if (RST) begin
            sum <= 0;
            // Reset all values in the window to 0
            for (i = 0; i < L; i = i + 1)
                window[i] <= 0;
            data_out <= 0;
        end
        else if (EN) begin
            // Update sum: subtract oldest value and add new  input
            sum <= sum - window[L-1] + data_in;
            
            // Shift values in the window
            for (i = L-1; i > 0; i = i - 1)
                window[i] <= window[i-1];
            
            window[0] <= data_in;
            
            // Compute moving average
            data_out <= sum / L;  
        end
    end

endmodule



