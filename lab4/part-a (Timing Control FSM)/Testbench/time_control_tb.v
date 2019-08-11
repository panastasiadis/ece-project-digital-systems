///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number      : 4
// Full Name       : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

`timescale 1ns/1000ps

module time_control_tb ();

reg clk = 0;
reg rst = 1;
reg fsm_enable = 0;
reg LCD_RS = 0;
reg [10:0] address;
reg lower_bits_time;

wire [3:0] data;
wire [7:0] memory;

//Initialize cirquit at a random moment (after 74ns)

initial begin
	#60 rst=0;
	#110 fsm_enable = 1;
		 LCD_RS = 1;
end

//Fpga spartan 3 clock frequency ==> 50 Mhz

always #10 clk <= ~clk;

//Increment address counter to display the full message of Block Ram

always @(posedge clk or posedge rst) begin
	if ( rst ) begin
		address = 11'd0;
		lower_bits_time = 1'b0;
	end
	if ( address == 11'd55 && send_upper == 1'b1 ) begin
		address = 11'd0;
		fsm_enable = 0;
		lower_bits_time = 1'b0;
		LCD_RS = 0;
	end
	else if ( send_upper == 1'b1 ) begin
		address = address + 1;
		lower_bits_time = 1'b0;
	end
	else if ( send_lower == 1'b1 ) begin
		lower_bits_time = 1'b1;
	end
end

//Block Ram 8-bit Instantiation. Block ram contains the message for LCD Display 

bram bram_0 ( .clk( clk ), .addr( address ), .char( memory ) );

//Assign to data output upper or lower 4-bits of 8-bit Block Ram element

assign data = ( lower_bits_time == 1'b1  ) ? memory[3:0] : memory [7:4];

//Instantiate and test time control FSM module

time_control_fsm time_control_fsm_0 (.reset( rst ), .clk( clk ), .fsm_enable( fsm_enable ), 
									 .lcd_e_tc_fsm( LCD_E ), .send_upper( send_upper ), 
									 .send_lower( send_lower ) );


endmodule