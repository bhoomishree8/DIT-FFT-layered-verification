// Interface definition

interface FFT4If;

logic [15:0] x0_re, x0_im, x1_re, x1_im, x2_re, x2_im, x3_re, x3_im;

logic [15:0] y0_re, y0_im, y1_re, y1_im, y2_re, y2_im, y3_re, y3_im;

logic clk; // Clock signal

endinterface


// Driver Class

class FFT4Driver;

virtual FFT4If vif;


function new(virtual FFT4If vif);

this.vif = vif;

endfunction


task drive(

input [15:0] x0_re, x0_im, x1_re, x1_im,

input [15:0] x2_re, x2_im, x3_re, x3_im

);

vif.x0_re <= x0_re;

vif.x0_im <= x0_im;

vif.x1_re <= x1_re;

vif.x1_im <= x1_im;

vif.x2_re <= x2_re;

vif.x2_im <= x2_im;

vif.x3_re <= x3_re;

vif.x3_im <= x3_im;

@(posedge vif.clk); // Wait for one clock cycle

endtask

endclass


// Monitor Class

class FFT4Monitor;

virtual FFT4If vif;

event monitor_event;


function new(virtual FFT4If vif);

this.vif = vif;

endfunction


task monitor;

forever begin

@(posedge vif.clk);

-> monitor_event; // Notify the scoreboard

end

endtask

endclass

// Scoreboard Class

class FFT4Scoreboard;

virtual FFT4If vif;


function new(virtual FFT4If vif);

this.vif = vif;

endfunction


task check(

input [15:0] expected_y0_re, expected_y0_im, expected_y1_re, expected_y1_im,

input [15:0] expected_y2_re, expected_y2_im, expected_y3_re, expected_y3_im

);

if (vif.y0_re !== expected_y0_re || vif.y0_im !== expected_y0_im ||

vif.y1_re !== expected_y1_re || vif.y1_im !== expected_y1_im ||

vif.y2_re !== expected_y2_re || vif.y2_im !== expected_y2_im ||

vif.y3_re !== expected_y3_re || vif.y3_im !== expected_y3_im) begin

$display("Mismatch: Expected and Actual FFT outputs do not match.");

end else begin

$display("Pass: FFT outputs are correct.");

end

endtask

endclass

// Environment Class

class FFT4Env;

FFT4Driver driver;

FFT4Monitor monitor;

FFT4Scoreboard scoreboard;

virtual FFT4If vif;


function new(virtual FFT4If vif);

this.vif = vif;

driver = new(vif);

monitor = new(vif);

scoreboard = new(vif);

endfunction

task run;

fork

monitor.monitor();

join_none

endtask

endclass

// Test Class

class FFT4Test;

FFT4Env env;

virtual FFT4If vif;


function new(virtual FFT4If vif);

this.vif = vif;

env = new(vif);

endfunction


task basic_test;

logic [15:0] expected_y0_re, expected_y0_im, expected_y1_re, expected_y1_im;

logic [15:0] expected_y2_re, expected_y2_im, expected_y3_re, expected_y3_im;


// Test Case 1

env.driver.drive(16'd1, 16'd0, 16'd2, 16'd0, 16'd3, 16'd0, 16'd4, 16'd0);

expected_y0_re = 16'd10; expected_y0_im = 16'd0;

expected_y1_re = -16'd2; expected_y1_im = 16'd0;

expected_y2_re = -16'd2; expected_y2_im = 16'd0;

expected_y3_re = -16'd2; expected_y3_im = 16'd0;

@(posedge vif.clk);

env.scoreboard.check(expected_y0_re, expected_y0_im, expected_y1_re, expected_y1_im,

expected_y2_re, expected_y2_im, expected_y3_re, expected_y3_im);


// Add more test cases with different inputs as required.

endtask


task run;

env.run();

basic_test();

endtask

endclass


// Top Module

module top;

FFT4If vif();

// Clock generation

always #5 vif.clk = ~vif.clk;


// DUT Instance

fft4 DUT (

.x0_re(vif.x0_re), .x0_im(vif.x0_im),

.x1_re(vif.x1_re), .x1_im(vif.x1_im),

.x2_re(vif.x2_re), .x2_im(vif.x2_im),

.x3_re(vif.x3_re), .x3_im(vif.x3_im),

.y0_re(vif.y0_re), .y0_im(vif.y0_im),

.y1_re(vif.y1_re), .y1_im(vif.y1_im),

.y2_re(vif.y2_re), .y2_im(vif.y2_im),

.y3_re(vif.y3_re), .y3_im(vif.y3_im)

);


FFT4Test test;

initial begin

test = new(vif);

test.run();

end


initial begin

$dumpfile("waveform.vcd"); // Name of the waveform file

$dumpvars(0, top); // Dump all signals in the module hierarchy

end


initial begin

#100; // Let the simulation run for 100 time units

$finish; // End the simulation

end


// Assertions and Coverage

always @(posedge vif.clk) begin

// Assumption: Clock signal should always be toggling correctly

assume(vif.clk === 1'b1 || vif.clk === 1'b0);


// Coverage: Cover the case when all inputs are zeros

cover (vif.x0_re == 16'd0 && vif.x0_im == 16'd0 &&

vif.x1_re == 16'd0 && vif.x1_im == 16'd0 &&

vif.x2_re == 16'd0 && vif.x2_im == 16'd0 &&

vif.x3_re == 16'd0 && vif.x3_im == 16'd0);


// Assertion: The output values must always be within a valid range

assert((vif.y0_re >= -16'd32768 && vif.y0_re <= 16'd32767) &&

(vif.y0_im >= -16'd32768 && vif.y0_im <= 16'd32767) &&

(vif.y1_re >= -16'd32768 && vif.y1_re <= 16'd32767) &&

(vif.y1_im >= -16'd32768 && vif.y1_im <= 16'd32767) &&

(vif.y2_re >= -16'd32768 && vif.y2_re <= 16'd32767) &&

(vif.y2_im >= -16'd32768 && vif.y2_im <= 16'd32767) &&

(vif.y3_re >= -16'd32768 && vif.y3_re <= 16'd32767) &&

(vif.y3_im >= -16'd32768 && vif.y3_im <= 16'd32767));

end

endmodule