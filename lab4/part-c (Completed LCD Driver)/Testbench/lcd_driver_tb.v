///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number      : 4
// Full Name       : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

`timescale 1ns/1000ps

module lcd_driver_tb ();

reg clk = 0;
reg rst = 1;

initial begin
	#60 rst=0;
end

//Fpga spartan 3 clock frequency ==> 50 Mhz

always #10 clk <= ~clk;

//Test LCD Driver 

lcd_driver lcd_driver_0 (.clk( clk ), .rst( rst ),
						 .LCD_RS( LCD_RS ),.LCD_RW( LCD_RW ),.LCD_E( LCD_E ),
	                     .SF_D11( SF_D11 ),.SF_D10( SF_D10 ),.SF_D9( SF_D9 ),.SF_D8( SF_D8 ) );

endmodule