//////////////////////////////////////////////////
// University : Electrical & Computer Engineering
// Course     : CE430 - Digital Cirquits
// Lab number : 1st
// Full Name  : Panagiotis Anastasiadis        
// A.M.       : 2134
// Date       : 25/10/18
//////////////////////////////////////////////////

module LEDdecoder_tb ();


reg [5:0] char = 6'b000000;
wire [6:0] LED;

//Pass to LED Decoder all valid inputs (0-36 in decimal) plus one invalid input (value 37) 

initial begin
 repeat (38) 
 	#5 char = char + 1;
 	$finish;
end

LEDdecoder LEDdecoder_0 (.char(char), .LED (LED));

endmodule