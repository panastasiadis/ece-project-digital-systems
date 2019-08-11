//////////////////////////////////////////////////
// University : Electrical & Computer Engineering
// Course     : CE430 - Digital Cirquits
// Lab number : 1st
// Full Name  : Panagiotis Anastasiadis        
// A.M.       : 2134
// Date       : 25/10/18
//////////////////////////////////////////////////

module ConstantDelayCounter (reset, clk, clickCounter);
	input reset,clk;
	output reg [3:0] clickCounter;
	reg [21:0] counterEnableClick;

//When counterEnableClick reaches final state which is equal to 4194304 clock cycles, increment clickCounter by 1. 

	always @(posedge reset or posedge clk) begin
		if (reset) begin
			clickCounter = 4'b0000;
			counterEnableClick = 0;
		end
		else if (counterEnableClick == 22'b1111111111111111111111 && clickCounter == 4'b1110) begin
			clickCounter = 4'b0000;
			counterEnableClick = 0;
		end
		else if (counterEnableClick == 22'b1111111111111111111111) begin
			clickCounter = clickCounter + 1;
			counterEnableClick = 0;
		end
		else begin
			counterEnableClick = counterEnableClick + 1;
		end
	end

endmodule