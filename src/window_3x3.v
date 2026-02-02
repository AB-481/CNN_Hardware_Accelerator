`timescale 1ns / 1ps
module window_3x3 (
    input wire clk,
    input wire rst,
    input wire pixel_valid,

    input wire [7:0] row0,
    input wire [7:0] row1,
    input wire [7:0] row2,

    output reg [7:0] w00, w01, w02,
    output reg [7:0] w10, w11, w12,
    output reg [7:0] w20, w21, w22
);

    reg [7:0] row0_s1, row0_s2;
    reg [7:0] row1_s1, row1_s2;
    reg [7:0] row2_s1, row2_s2;

    always @(posedge clk) begin
        if (rst) begin
            row0_s1 <= 0; row0_s2 <= 0;
            row1_s1 <= 0; row1_s2 <= 0;
            row2_s1 <= 0; row2_s2 <= 0;

            w00 <= 0; w01 <= 0; w02 <= 0;
            w10 <= 0; w11 <= 0; w12 <= 0;
            w20 <= 0; w21 <= 0; w22 <= 0;
        end
        else if (pixel_valid) begin
            // horizontal shifts
            row0_s2 <= row0_s1;
            row0_s1 <= row0;

            row1_s2 <= row1_s1;
            row1_s1 <= row1;

            row2_s2 <= row2_s1;
            row2_s1 <= row2;

            // window outputs
            w22 <= row0;
            w21 <= row0_s1;
            w20 <= row0_s2;

            w12 <= row1;
            w11 <= row1_s1;
            w10 <= row1_s2;

            w02 <= row2;
            w01 <= row2_s1;
            w00 <= row2_s2;
        end
    end
endmodule
