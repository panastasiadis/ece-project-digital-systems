//////////////////////////////////////////////////
// University : Electrical & Computer Engineering
// Course     : CE430 - Digital Cirquits
// Lab number : 1st
// Full Name  : Panagiotis Anastasiadis        
// A.M.       : 2134
// Date       : 25/10/18
//////////////////////////////////////////////////

module ClickCounter (reset, click, clickCounter);
	input click;
	input reset;
	output reg [3:0] clickCounter;

//increase clickCounter after every click of the button.
//When clickCounter reaches value of d'14 (final position in message array), set its value to zero to start again. 

	always @(posedge reset or posedge click) begin
		if (reset) begin
			clickCounter = 4'b0000;
		end
		else if (clickCounter == 4'b1110) begin
			clickCounter = 4'b0000;
		end
		else begin
			clickCounter = clickCounter + 1;
		end
	end

endmodule