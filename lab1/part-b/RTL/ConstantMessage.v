//////////////////////////////////////////////////
// University : Electrical & Computer Engineering
// Course     : CE430 - Digital Cirquits
// Lab number : 1st
// Full Name  : Panagiotis Anastasiadis        
// A.M.       : 2134
// Date       : 25/10/18
//////////////////////////////////////////////////

module ConstantMessage (reset, clk, an3, an2, an1, an0, charToDecode);

input clk, reset, an3, an2, an1, an0;
output reg [5:0] charToDecode;

// The message is "FPgA".

parameter 

letter_F		  =	 6'b001111,
letter_P		  =	 6'b011001,
letter_g		  =	 6'b010000,
letter_A		  =	 6'b001010;

wire an3, an2, an1, an0;

//Every time an AnX digit is on, LEDdecoder module will decode the data for the next AnX digit. 

always @(posedge clk or posedge reset) begin
 	if (reset) begin
 	 		// reset
		charToDecode = letter_F;
	end
	else if (an3 == 0 || an2 == 0 || an1 == 0 || an0 == 0)  begin  
		case (charToDecode)
	 		letter_F: charToDecode = letter_P;
	 		letter_P: charToDecode = letter_g;
	 		letter_g: charToDecode = letter_A;
	 		letter_A: charToDecode = letter_F;
	 	endcase
 	end
 end

endmodule 