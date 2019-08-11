//////////////////////////////////////////////////
// University : Electrical & Computer Engineering
// Course     : CE430 - Digital Cirquits
// Lab number : 1st
// Full Name  : Panagiotis Anastasiadis        
// A.M.       : 2134
// Date       : 25/10/18
//////////////////////////////////////////////////

module Topmodule_tb ();


reg clk = 0;
reg rst = 1;


initial begin

	#60 rst=0;

	//Hit reset once again to test reset_synchronizer module

	#100663 rst = 1;
	#100922 rst = 0;
end

//Set clk period equal to spartan 3 clock frequency (50 MHZ)

always #10 clk <= ~clk;

Topmodule Topmodule_0 (rst, clk, an3, an2, an1, an0,
a, b, c, d, e, f, g, dp);

endmodule