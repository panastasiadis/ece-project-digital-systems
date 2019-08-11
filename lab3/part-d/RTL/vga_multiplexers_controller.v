///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number      : 3
// Full Name       : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

module vga_multiplexers_controller (reset, VGA_HSYNC, VGA_VSYNC, new_line, new_frame,
									vram_red, vram_green, vram_blue, reset_hsync, reset_vsync,
									VGA_RED, VGA_GREEN, VGA_BLUE);

input reset;
input VGA_HSYNC, VGA_VSYNC;
input new_line, new_frame;
input vram_red, vram_green, vram_blue;

output VGA_RED, VGA_GREEN, VGA_BLUE, reset_hsync, reset_vsync;

//reset_hsync and reset_vsync are reset signals for hpixel_controller and vpixel_controller
//Except toplevel reset, after every VGA_HSYNC == 0 and VGA_VSYNC == 0 all counters of the above modules should reset.

assign reset_hsync = ( reset == 1'b1 || VGA_HSYNC == 1'b0 ) ? 1'b1 : 1'b0;
assign reset_vsync = ( reset == 1'b1 || VGA_VSYNC == 1'b0 ) ? 1'b1 : 1'b0;

//assign zero to each color when time exceeds timing part of frame or line.

assign VGA_RED   = ( new_line == 1'b1 && new_frame == 1'b1 ) ? vram_red   : 1'b0;
assign VGA_GREEN = ( new_line == 1'b1 && new_frame == 1'b1 ) ? vram_green : 1'b0;
assign VGA_BLUE  = ( new_line == 1'b1 && new_frame == 1'b1 ) ? vram_blue  : 1'b0;

endmodule