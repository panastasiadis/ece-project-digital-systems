///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number      : 3
// Full Name       : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

`timescale 1ns/1000ps

module hsync_driver_tb ();

reg clk = 0;
reg rst = 1;

//Initialize cirquit at a random moment (after 74ns)

initial begin
	#74 rst=0;
end

//Fpga spartan 3 clock frequency ==> 50 Mhz

always #10 clk <= ~clk;

hsync_driver hsync_driver_0 (.reset(rst), .clk(clk), .hsync(hsync), .new_line(new_line));

wire [6:0] hpixel;

hpixel_controller hpixel_controller_0 (.reset(rst), .clk(clk), .new_line(new_line), .hpixel(hpixel) );
endmodule