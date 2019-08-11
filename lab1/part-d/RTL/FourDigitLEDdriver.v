//////////////////////////////////////////////////
// University : Electrical & Computer Engineering
// Course     : CE430 - Digital Cirquits
// Lab number : 1st
// Full Name  : Panagiotis Anastasiadis        
// A.M.       : 2134
// Date       : 25/10/18
//////////////////////////////////////////////////

module FourDigitLEDdriver(reset, clk, LED, enable, counter, an3, an2, an1, an0,
a, b, c, d, e, f, g, dp);


input clk, reset;
input [6:0] LED;
input [3:0] counter;
output reg an3, an2, an1, an0;
output reg a, b, c, d, e, f, g;
output dp;
output reg [1:0] enable;

wire [6:0] LED;
wire [3:0] counter;

wire dp;				
assign dp = 1'b1;			//dp signal is requested to retain its value at zero

//Data transfer from the LEDdecoder to the a,b,c,d,e,f,g outputs.
//Important Information! Enable signal is a 2-bit register which is used right after the reset signal
//in order to delay the beginning of the 4bitCounter Module. This action takes place
//because of the need for a specific time interval between a,b,c,d,e,f,g digits when 
//recieve their values and the the turn on of an AnX digit.			

always @(posedge clk or posedge reset ) begin
	if (reset) begin
		// reset
		a = 1;
		b = 1;
		c = 1;
		d = 1;
		e = 1;
		f = 1;
		g = 1;
		enable = 2'b10;
	end
	else if (enable == 2'b10) begin
		a = LED[6];
		b = LED[5];
		c = LED[4];
		d = LED[3];
		e = LED[2];
		f = LED[1];
		g = LED[0];
		enable = enable - 1;
	end
	else if (enable == 2'b01) begin
		enable = enable - 1;
	end
	else begin
		if ( counter == 4'b1100 || counter == 4'b1000 || counter == 4'b0100 || counter == 4'b0000 ) begin
				a = LED[6];
				b = LED[5];
				c = LED[4];
				d = LED[3];
				e = LED[2];
				f = LED[1];
				g = LED[0];
		end
		
	end
end



//Values assigned to anX digits according to Lab instructions and the 4BitCounter module.

always @(posedge clk or posedge reset ) begin
	if (reset ) begin
		an3 = 1;
		an2 = 1;
		an1 = 1;
		an0 = 1;
	end
	else begin
		case (counter)
			4'b1110: an3 = 0;
			4'b1010: an2 = 0;
			4'b0110: an1 = 0;
			4'b0010: an0 = 0;
			default: begin
					 an3 = 1;
					 an2 = 1;
					 an1 = 1;
					 an0 = 1;
					 end
		endcase
	end
end

endmodule