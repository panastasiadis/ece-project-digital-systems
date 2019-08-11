///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number      : 3
// Full Name       : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

`timescale 1ns/1000ps

module vsync_driver_tb ();

reg clk = 0;
reg rst = 1;
wire new_line;
wire new_frame;
wire [6:0] vpixel;

//Initialize cirquit at a random moment (after 74ns)

initial begin
	#74 rst=0;
end

//Fpga spartan 3 clock frequency ==> 50 Mhz

always #10 clk <= ~clk;


//Instantiate hsync, vsync driver to extract new_line and new_frame signal.

hsync_driver hsync_driver_0 (.reset(rst), .clk(clk), .hsync(hsync), .new_line(new_line));
vsync_driver vsync_driver_0 (.reset(rst), .clk(clk), .vsync(vsync), .new_frame(new_frame));

//Instantiate vpixel to test vertical pixels synchronization with vsync and hsync.

vpixel_controller vpixel_controller_0 (.reset(rst), .clk(clk),.new_frame(new_frame), .new_line(new_line), .vpixel(vpixel) );


endmodule