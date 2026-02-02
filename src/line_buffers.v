`timescale 1ns / 1ps
module line_buffers #(
    parameter W = 5
)(
    input  wire clk,
    input  wire rst,
    input  wire [7:0] pixel_in,
    input  wire pixel_valid,

    output reg [7:0] row0,
    output reg [7:0] row1,
    output reg [7:0] row2
);

    reg [7:0] line1 [0:W-1];
    reg [7:0] line2 [0:W-1];

    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for(i=0;i<W;i=i+1) begin
                line1[i] <= 0;
                line2[i] <= 0;
            end
            row0 <= 0;
            row1 <= 0;
            row2 <= 0;
        end 
        else if (pixel_valid) begin
            
            for(i=W-1;i>0;i=i-1)
                line2[i] <= line2[i-1];
            line2[0] <= line1[W-1];

            for(i=W-1;i>0;i=i-1)
                line1[i] <= line1[i-1];
            line1[0] <= pixel_in;

            row0 <= pixel_in;
            row1 <= line1[W-1];
            row2 <= line2[W-1];
        end
    end
endmodule
