`timescale 1ns/1ns
module reference_design #(parameter WL = 32, L = 8)
                         (input CLK, RST, EN,
                          input signed [WL - 1 : 0] data_in,
                          output signed [WL - 1 : 0] data_out);

    reg signed [WL - 1 : 0] window [0:L-1];
    reg signed [WL - 1 : 0] sum;
    integer i;
    
    always @(posedge CLK) begin
        if (RST) begin
            sum <= 0;
            // Reset all values in the window to 0
            for (i = 0; i < L; i = i + 1)
                window[i] <= 0;
        end
        else if (EN) begin
            // Update the sum: subtract the oldest value from the 
            // current sum and add the new one
            sum <= sum - window[L-1] + data_in;

            // Shift values in the window
            for (i = L-1; i > 0; i = i - 1)
                window[i] <= window[i-1];
            
            // Insert the new value to the LSB 
            window[0] <= data_in;
        end
    end

    assign data_out = sum / L;

endmodule