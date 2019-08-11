//////////////////////////////////////////////////
// University : Electrical & Computer Engineering
// Course     : CE430 - Digital Cirquits
// Lab number : 1st
// Full Name  : Panagiotis Anastasiadis        
// A.M.       : 2134
// Date       : 25/10/18
//////////////////////////////////////////////////

module LEDdecoder (char, LED) ;
	
	input [5:0] char;
	output [6:0] LED;
	
	reg [6:0] LED;

	//Parameters including the valid inputs to the LED Decoder. 
	//These inputs are: 
	// 1. numbers 0-9
	// 2. english alphabet
	// 3. space character 

    parameter 

	zero      		  =  6'b000000,
	one       		  =  6'b000001,
    two       		  =  6'b000010,
	three     		  =  6'b000011,
	four      		  =  6'b000100,
	five	  		  =  6'b000101,
	six		  		  =  6'b000110,
	seven     		  =  6'b000111,
	eight     		  =  6'b001000,
	nine	  		  =  6'b001001,
	letter_A		  =	 6'b001010,
	letter_b		  =	 6'b001011,
	letter_C		  =	 6'b001100,
	letter_d		  =	 6'b001101,
	letter_E		  =	 6'b001110,
	letter_F		  =	 6'b001111,
	letter_g		  =	 6'b010000,
	letter_H		  =	 6'b010001,
	letter_I		  =	 6'b010010,
	letter_J		  =	 6'b010011,
	letter_k		  =	 6'b010100,
	letter_L		  =	 6'b010101,
	letter_M		  =	 6'b010110,
	letter_n		  =	 6'b010111,
	letter_O		  =	 6'b011000,
	letter_P		  =	 6'b011001,
	letter_q		  =	 6'b011010,
	letter_r		  =  6'b011011,
	letter_S		  =	 6'b011100,
	letter_T		  =	 6'b011101,
	letter_U		  =	 6'b011110,
	letter_v		  =	 6'b011111,
	letter_W		  =	 6'b100000,
	letter_X		  =	 6'b100001,
	letter_y	      =	 6'b100010,
	letter_Z		  =	 6'b100011,
	space             =  6'b100100;

	always @( char ) begin
	  case ( char )
	  	zero:  		  LED = 7'b0000001;
	  	one:          LED = 7'b1001111;
	  	two:          LED = 7'b0010010;
	  	three:        LED = 7'b0000110;
	  	four:         LED = 7'b1001100;
	  	five:         LED = 7'b0100100;
	  	six:          LED = 7'b0100000;
	  	seven:        LED = 7'b0001111;
	  	eight:        LED = 7'b0000000;
	  	nine:         LED = 7'b0000100;
	  	letter_A:     LED = 7'b0001000;
	  	letter_b:     LED = 7'b1100000;
	  	letter_C:     LED = 7'b0110001;
	  	letter_d:     LED = 7'b1000010;
	  	letter_E:     LED = 7'b0110000;
	  	letter_F:     LED = 7'b0111000;
	  	letter_g:     LED = 7'b0000100;
	  	letter_H:     LED = 7'b1001000;
	  	letter_I:     LED = 7'b1111001;
	  	letter_J:     LED = 7'b1000011;
	  	letter_k:     LED = 7'b1110000;
	  	letter_L:     LED = 7'b1110001;
	  	letter_M:     LED = 7'b0101011;
	  	letter_n:     LED = 7'b1101010;
	  	letter_O:     LED = 7'b0000001;
	  	letter_P:     LED = 7'b0011000;
	  	letter_r:     LED = 7'b1111010;
	  	letter_S:     LED = 7'b0100100;
	  	letter_T:     LED = 7'b1001110;
	  	letter_U:     LED = 7'b1000001;
	  	letter_v:     LED = 7'b1100011;
	  	letter_W:     LED = 7'b1010101;
	  	letter_X:     LED = 7'b1001000;
	  	letter_y:     LED = 7'b1000100;
	  	letter_Z:     LED = 7'b0010010;
	  	space:        LED = 7'b1111111;

// If input does not contain valid character, display error character in display ("-").

	  	default:      LED = 7'b1111110;
	  endcase
	end

endmodule