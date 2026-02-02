`timescale 1ns / 1ps
module conv_mac_3x3 (
    input wire clk,
    input wire rst,
    input wire pixel_valid,

    input wire [7:0] w00, w01, w02,
    input wire [7:0] w10, w11, w12,
    input wire [7:0] w20, w21, w22,

    input wire signed [7:0] k00, k01, k02,
    input wire signed [7:0] k10, k11, k12,
    input wire signed [7:0] k20, k21, k22,

    output reg signed [19:0] conv_out,
    output reg conv_valid
);

    reg signed [15:0] p00,p01,p02,p10,p11,p12,p20,p21,p22;
    reg signed [19:0] sum;

    always @(posedge clk) begin
        if (rst) begin
            conv_out <= 0;
            conv_valid <= 0;
        end
        else if (pixel_valid) begin
            p00 <= $signed({1'b0,w00}) * k00;
            p01 <= $signed({1'b0,w01}) * k01;
            p02 <= $signed({1'b0,w02}) * k02;

            p10 <= $signed({1'b0,w10}) * k10;
            p11 <= $signed({1'b0,w11}) * k11;
            p12 <= $signed({1'b0,w12}) * k12;

            p20 <= $signed({1'b0,w20}) * k20;
            p21 <= $signed({1'b0,w21}) * k21;
            p22 <= $signed({1'b0,w22}) * k22;

            sum <= p00 + p01 + p02 + p10 + p11 + p12 + p20 + p21 + p22;

            conv_out <= sum;
            conv_valid <= 1'b1;
        end
        else begin
            conv_valid <= 1'b0;
        end
    end
endmodule
