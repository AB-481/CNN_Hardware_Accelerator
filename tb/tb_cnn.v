`timescale 1ns / 1ps
module tb_cnn;

    reg clk;
    reg rst;
    reg [7:0] pixel_in;
    reg pixel_valid;

    wire [7:0] pixel_out;
    wire pixel_out_valid;

    cnn_top #(.W(5)) DUT (
        .clk(clk),
        .rst(rst),
        .pixel_in(pixel_in),
        .pixel_valid(pixel_valid),
        .pixel_out(pixel_out),
        .pixel_out_valid(pixel_out_valid)
    );

    always #5 clk = ~clk;

    reg [7:0] image [0:24];
    integer i;

    initial begin
        image[0]=10; image[1]=10; image[2]=10; image[3]=10; image[4]=10;
        image[5]=10; image[6]=50; image[7]=50; image[8]=50; image[9]=10;
        image[10]=10; image[11]=50; image[12]=100; image[13]=50; image[14]=10;
        image[15]=10; image[16]=50; image[17]=50; image[18]=50; image[19]=10;
        image[20]=10; image[21]=10; image[22]=10; image[23]=10; image[24]=10;

        clk = 0;
        rst = 1;
        pixel_in = 0;
        pixel_valid = 0;

        #20;
        rst = 0;

        #10;
        pixel_valid = 1;

        for (i = 0; i < 25; i = i + 1) begin
            pixel_in = image[i];
            #10;
        end

        pixel_valid = 0;
        #400;
        $finish;
    end

    always @(posedge clk) begin
        if (pixel_out_valid) begin
            $display("Time=%0t  Output Pixel = %d", $time, pixel_out);
        end
    end

endmodule
