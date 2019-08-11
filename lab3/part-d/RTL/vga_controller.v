///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number      : 3
// Full Name       : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

module vgacontroller (resetbutton, clk, VGA_RED, VGA_GREEN, VGA_BLUE,
					  VGA_HSYNC, VGA_VSYNC);

input resetbutton, clk;
output VGA_RED, VGA_GREEN, VGA_BLUE, VGA_HSYNC, VGA_VSYNC;

wire [6:0] vpixel;
wire [6:0] hpixel;
wire vram_red;
wire vram_green;
wire vram_blue;
wire new_line;
wire new_frame;

//Synchronize reset using two flip flops to avoid setup and hold violations.

reset_synchronizer reset_synchronizer_0 (.reset(resetbutton), .clk(clk), .reset_sync(reset));

//1.Multiplexers Controller set zero on RGB Values when new_frame or new_line are is displayed.
//2.Also resets modules of hpixel or vpixel controller respectively when VGA_HSYNC or VGA_VSYNC is driven to zero.

vga_multiplexers_controller vga_multiplexers_controller_0 (.reset(reset), .VGA_HSYNC(VGA_HSYNC), .VGA_VSYNC(VGA_VSYNC),
														   .new_line(new_line), .new_frame(new_frame), .vram_red(vram_red),
														   .vram_green(vram_green), .vram_blue(vram_blue), .reset_hsync(reset_hsync), 
														   .reset_vsync(reset_vsync), .VGA_RED(VGA_RED), .VGA_GREEN(VGA_GREEN), .VGA_BLUE(VGA_BLUE));

//Drive hsync signal correctly (correct timing for 640x480 60hz monitor) through hsync_driver instantiation 

hsync_driver hsync_driver_0 (.reset( reset ), .clk( clk ), .hsync( VGA_HSYNC ), .new_line ( new_line ));

//Drive vsync signal correctly (correct timing for 640x480 60hz monitor) through vsync_driver instantiation 

vsync_driver vsync_driver_0 (.reset( reset ), .clk( clk ), .vsync( VGA_VSYNC ),.new_frame ( new_frame ));

//Instantiate controller for horizontal pixel. Hpixel is synchronized with hsync signal.

hpixel_controller hpixel_controller_0 (.reset( reset_hsync ), .clk( clk ), .new_line ( new_line ), .hpixel( hpixel ));

//Instantiate controller for verical pixel. Vpixel is synchronized with vsync signal.

vpixel_controller vpixel_controller_0 (.reset( reset_vsync ), .clk( clk ), .new_frame ( new_frame ), .new_line ( new_line ), .vpixel( vpixel ) );

//Instantiate Video Ram. Video Ram consists of 3 block rams and contains correct colors for each pixel in screen.

video_ram video_ram_0(.reset(reset), .clk(clk), .ver_px ( vpixel ), .hor_px ( hpixel ) , .red_value( vram_red ), .green_value ( vram_green ), .blue_value( vram_blue ));


endmodule