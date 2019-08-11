///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number      : 3
// Full Name       : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////
`timescale 1ns/1000ps

module vga_controller_tb ();

reg clk = 0;
reg rst = 1;

//Initialize cirquit at a random moment (after 74ns)

initial begin
	#60000 rst=0;
end

//Fpga spartan 3 clock frequency ==> 50 Mhz

always #10 clk <= ~clk;

//test vga controller function 

vgacontroller vgacontroller_0 (.resetbutton (rst), .clk(clk), .VGA_RED (VGA_RED), .VGA_GREEN (VGA_GREEN), .VGA_BLUE(VGA_BLUE),
					 		   .VGA_HSYNC(VGA_HSYNC), .VGA_VSYNC(VGA_VSYNC));

endmodule
