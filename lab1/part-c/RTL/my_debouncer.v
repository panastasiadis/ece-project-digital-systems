//////////////////////////////////////////////////
// University : Electrical & Computer Engineering
// Course     : CE430 - Digital Cirquits
// Lab number : 1st
// Full Name  : Panagiotis Anastasiadis        
// A.M.       : 2134
// Date       : 25/10/18
//////////////////////////////////////////////////

module Debouncer (reset, clk , button_in , button_out);
	
	input clk;
	input reset;
	input button_in;
	output reg button_out;

	reg [22:0] buttonClickedCounter;

// If button_in retain value 1 for 6000000 clock cycles, then is valid and button_out becomes 1 for 1 cycle. 

	always @( posedge clk or posedge reset) begin
		if (reset) begin
			button_out = 0;
			buttonClickedCounter = 0;
		end
		else if (button_in == 1'b1 && buttonClickedCounter != 23'd6000000 ) begin
			buttonClickedCounter = buttonClickedCounter + 1;
			button_out = 0;
		end
		else if (button_in == 1'b1 && buttonClickedCounter == 23'd6000000 ) begin
			button_out = 1;
			buttonClickedCounter = 0;

		end
		else if ( button_in == 1'b0 ) begin
			button_out = 0;
			buttonClickedCounter = 0;
		end
		else if (button_out == 1'b1) begin
			button_out = 0;
		end
	end

endmodule