`include "butterfly.sv"

module fft4(

input [15:0] x0_re, x0_im, x1_re, x1_im, x2_re, x2_im, x3_re, x3_im,

output [15:0] y0_re, y0_im, y1_re, y1_im, y2_re, y2_im, y3_re, y3_im

);

wire [15:0] s0_re, s0_im, s1_re, s1_im, s2_re, s2_im, s3_re, s3_im;

wire [15:0] t0_re, t0_im, t1_re, t1_im, t2_re, t2_im, t3_re, t3_im;

// First stage

butterfly bf0(x0_re, x0_im, x2_re, x2_im, 16'h0001, 16'h0000, s0_re, s0_im, s1_re, s1_im);

butterfly bf1(x1_re, x1_im, x3_re, x3_im, 16'h0001, 16'h0000, s2_re, s2_im, s3_re, s3_im);

// Second stage

butterfly bf2(s0_re, s0_im, s2_re, s2_im, 16'h0001, 16'h0000, y0_re, y0_im, y2_re, y2_im);

butterfly bf3(s1_re, s1_im, s3_re, s3_im, 16'h0000, 16'hFFFF, y1_re, y1_im, y3_re, y3_im);

endmodule