`timescale 1ns / 1ps
module cnn_top #(
    parameter W = 5
)(
    input wire clk,
    input wire rst,
    input wire [7:0] pixel_in,
    input wire pixel_valid,

    output reg [7:0] pixel_out,
    output reg pixel_out_valid
);

    wire [7:0] row0,row1,row2;
    wire [7:0] w00,w01,w02,w10,w11,w12,w20,w21,w22;
    wire signed [19:0] conv_out;
    wire conv_valid;

    //kernel
    wire signed [7:0] k00 = 0, k01 = -1, k02 = 0;
    wire signed [7:0] k10 = -1,k11 = 4, k12 = -1;
    wire signed [7:0] k20 = 0, k21 = -1, k22 = 0;

    // position counters
    reg [15:0] col_cnt;
    reg [15:0] row_cnt;

    line_buffers #(.W(W)) LB (
        .clk(clk), .rst(rst),
        .pixel_in(pixel_in),
        .pixel_valid(pixel_valid),
        .row0(row0), .row1(row1), .row2(row2)
    );

    window_3x3 WG (
        .clk(clk), .rst(rst),
        .pixel_valid(pixel_valid),
        .row0(row0), .row1(row1), .row2(row2),
        .w00(w00), .w01(w01), .w02(w02),
        .w10(w10), .w11(w11), .w12(w12),
        .w20(w20), .w21(w21), .w22(w22)
    );

    conv_mac_3x3 MAC (
        .clk(clk), .rst(rst),
        .pixel_valid(pixel_valid),
        .w00(w00), .w01(w01), .w02(w02),
        .w10(w10), .w11(w11), .w12(w12),
        .w20(w20), .w21(w21), .w22(w22),
        .k00(k00), .k01(k01), .k02(k02),
        .k10(k10), .k11(k11), .k12(k12),
        .k20(k20), .k21(k21), .k22(k22),
        .conv_out(conv_out),
        .conv_valid(conv_valid)
    );

    // Row/Column counters
    always @(posedge clk) begin
        if (rst) begin
            col_cnt <= 0;
            row_cnt <= 0;
        end
        else if (pixel_valid) begin
            if (col_cnt == W-1) begin
                col_cnt <= 0;
                row_cnt <= row_cnt + 1;
            end
            else
                col_cnt <= col_cnt + 1;
        end
    end

    // Output stage with border handling and clamp
    always @(posedge clk) begin
        if (rst) begin
            pixel_out <= 0;
            pixel_out_valid <= 0;
        end
        else if (conv_valid) begin
            if (row_cnt >= 2 && col_cnt >= 2) begin
                if (conv_out < 0)
                    pixel_out <= 0;
                else if (conv_out > 255)
                    pixel_out <= 8'hFF;
                else
                    pixel_out <= conv_out[7:0];

                pixel_out_valid <= 1'b1;
            end
            else begin
                pixel_out_valid <= 1'b0;
            end
        end
    end

endmodule
