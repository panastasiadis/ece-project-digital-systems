//////////////////////////////////////////////////
// University : Electrical & Computer Engineering
// Course     : CE430 - Digital Cirquits
// Lab number : 1st
// Full Name  : Panagiotis Anastasiadis        
// A.M.       : 2134
// Date       : 25/10/18
//////////////////////////////////////////////////

module Topmodule_PartC_tb ();


reg clk = 0;
reg rst = 1;
reg click = 0;

initial begin
	#60 rst=0;
end

// Simulates in a way the bouncing activity of the button when pressed in spartan 3 fpga.

always  begin
			#40000 click = 1'b1;
			
			#400 click = 1'b0;		
			
			#800 click = 1'b1;	
			
			#800 click = 1'b0;				
			
			#800 click = 1'b1;

			#40000 click = 1'b0;
			
			#4000 click = 1'b1;		
			
			#40000 click = 1'b0;

			#400 click = 1'b1;
			
			#800 click = 1'b0;		
			
			#800 click = 1'b1;

			#800 click = 1'b0;
			
			#40000 click = 1'b1;		
			
			#4000 click = 1'b0;
end

always #10 clk <= ~clk;

Topmodule Topmodule_0 (rst, clk,click, an3, an2, an1, an0,
a, b, c, d, e, f, g, dp);

endmodule