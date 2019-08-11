//////////////////////////////////////////////////
// University : Electrical & Computer Engineering
// Course     : CE430 - Digital Cirquits
// Lab number : 1st
// Full Name  : Panagiotis Anastasiadis        
// A.M.       : 2134
// Date       : 25/10/18
//////////////////////////////////////////////////

module FourBitCounter (clk, reset, counter, enable);
	input clk;
	input reset;
	input [1: 0] enable;
	output reg [3:0] counter;


//4-bit counter needed for the correct drive of signals anX and a,b,c,d,e,f,g.
// Signal enable is needed to delay the counter for the first time when reset signal is activated. The reason is for the data to to be displayed correctly when an3 is on.    

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			counter = 4'b1111;
		end
		else if (enable != 2'b00) begin
			
		end
		else if (counter == 4'b0000) begin
			counter = 4'b1111;
		end
		else begin
			counter = counter - 1;
		end
	end

endmodule
