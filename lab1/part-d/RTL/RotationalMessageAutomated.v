//////////////////////////////////////////////////
// University : Electrical & Computer Engineering
// Course     : CE430 - Digital Cirquits
// Lab number : 1st
// Full Name  : Panagiotis Anastasiadis        
// A.M.       : 2134
// Date       : 25/10/18
//////////////////////////////////////////////////

module RotationalMessageAutomated (reset, clk, an3, an2, an1, an0, clickCounter, charToDecode);

input clk, reset, an3, an2, an1, an0, clickCounter;
output reg [5:0] charToDecode;

reg [5:0] message [0:14];


reg [3:0]flag0;
reg [3:0]flag1;
reg [3:0]flag2;

wire an3, an2, an1, an0;
wire [3:0] clickCounter;

reg ack0, ack1, ack2;

//Homework1 Part D: Message will be "fpga spartan 3 ".

parameter
letter_F		  =	 6'b001111,
letter_P		  =	 6'b011001,
letter_g		  =	 6'b010000,
letter_A		  =	 6'b001010,

space             =  6'b100100,

letter_S		  =	 6'b011100,
letter_r		  =  6'b011011,
letter_T		  =	 6'b011101,
letter_n		  =	 6'b010111,

three     		  =  6'b000011;

//flag registers are needed for a specific function. When clickCounter reaches value 11 anX signals will show message[11 (an3) 12 (an2) 13(an1) 14 (an0)].
//After this action, we need the message to start again from the begining.This must not happen instantly but with rotating.

//Example 11->n _ 3 _     memory [11 12 13 14]
// 		  12->_ 3 _ f     memory [12 13 14  0]  
// 		  13->3 _ f p     memory [13 14  0  1]
// 		  14->_ f p g     memory [14 0   1  2] 

//We insert value 15 in each flag register when is the correct timing to display the message as above. 

//Acks aka acknowledgements are needed because of the necessity to prevent, after each clock positive edge, the insertion of the same value over and over again in flag registers.  

always @(posedge reset or posedge clk) begin
	if (reset) begin
		message[0]  = letter_F; 
		message[1]  = letter_P; 
		message[2]  = letter_g; 
		message[3]  = letter_A; 
		message[4]  = space;
		message[5]  = letter_S;
		message[6]  = letter_P;
		message[7]  = letter_A;
		message[8]  = letter_r;
		message[9]  = letter_T;
		message[10] = letter_A;
		message[11] = letter_n;
		message[12] = space;
		message[13] = three;
		message[14] = space;
		flag0 = 4'b0000;
		flag1 = 4'b0000;
		flag2 = 4'b0000;
		ack0 = 1'b0;
		ack1 = 1'b0;
		ack2 = 1'b0;
	end
	else if (clickCounter == 4'b1100 && ack0 == 1'b0) begin
		flag0 = 4'b1111;
		ack0 = 1'b1;
	end
	else if  (clickCounter == 4'b1101 && ack1 == 1'b0) begin
		flag1 = 4'b1111;
		ack1 = 1'b1;
	end
	else if (clickCounter == 4'b1110 && ack2 == 1'b0) begin
		flag2 = 4'b1111;
		ack2 = 1'b1;
	end
	else if (clickCounter == 4'b0000) begin
		flag0 = 4'b0000;
		flag1 = 4'b0000;
		flag2 = 4'b0000;
		ack0 = 1'b0;
		ack1 = 1'b0;
		ack2 = 1'b0;

	end
end

//Every time an AnX digit is on, LEDdecoder module will decode the data for the next AnX digit. 

always @(posedge clk or posedge reset ) begin
	if (reset) begin
		charToDecode = message[0];
	end
	else begin
	    if (!an3) begin
			charToDecode = message [clickCounter + 1 - flag2];  
		end
		else if (!an2) begin
			charToDecode = message [clickCounter + 2 - flag1];  
		end
		else if (!an1) begin
			charToDecode = message [clickCounter + 3 - flag0];  
		end
		else if (!an0) begin
			charToDecode = message [clickCounter];      
		end
	end
end

endmodule 