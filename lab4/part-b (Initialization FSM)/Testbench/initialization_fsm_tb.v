///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number      : 4
// Full Name       : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

`timescale 1ns/1000ps

module initialization_tb ();

reg clk = 0;
reg rst = 1;

wire [3:0] init_data;

//Initialize cirquit at a random moment (after 74ns)

initial begin
	#50 rst=0;
end

//Fpga spartan 3 clock frequency ==> 50 Mhz

always #10 clk <= ~clk;

//Test LCD initialization process of LCD Display

initialization_fsm initialization_fsm_0 ( .reset( rst ), .clk( clk ), .lcd_e_init( lcd_e_init ), 
										  .init_data( init_data ), .initialization_done( initialization_done ) );

endmodule