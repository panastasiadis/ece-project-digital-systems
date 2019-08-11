///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number 	   : 2
// Full Name  	   : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

module baud_controller(rst, clk, baud_select, sample_ENABLE); 

input rst, clk; 
input [2:0] baud_select;
output reg sample_ENABLE; 

reg [14:0] counter;
reg [2:0] stored_baud;

//Synchronize reset using two flip flops to avoid setup and hold violations.

reset_synchronizer reset_synchronizer_0 (rst, clk, reset);

always @(posedge clk or posedge reset) begin
	if (reset) begin
		counter = 0;
		sample_ENABLE = 0;
		stored_baud = 3'b000;
	end
	else begin

		counter = counter + 1;

		//if during process baud select is changed 
		//make counter zero in order to start from scratch again.


		if ( stored_baud != baud_select ) begin
			stored_baud = baud_select;
			counter = 0;
		end
		//case for each of the eight (16 x)baud rates.
		//For each baud rate if counter reaches max value drive sample signal to one

		case( stored_baud )

			3'b000: 
			begin
			if ( counter == 14'd10417 ) 
				begin
					counter = 0;
					sample_ENABLE = 1'b1;	
				end
				else if ( sample_ENABLE == 1'b1 ) 
				begin
					sample_ENABLE = 1'b0;
				end
			end
			3'b001: 
			begin

				if ( counter == 14'd2604 ) 
				begin
					counter = 0;
					sample_ENABLE = 1'b1;	
				end
				else if ( sample_ENABLE == 1'b1 ) 
				begin
					sample_ENABLE = 1'b0;
				end
			end
			3'b010: 
			begin

				if ( counter == 14'd651 ) 
				begin
					counter = 0;
					sample_ENABLE = 1'b1;	
				end
				else if ( sample_ENABLE == 1'b1 ) 
				begin
					sample_ENABLE = 1'b0;
				end
			end
			3'b011: 
			begin

				if ( counter == 14'd326 ) 
				begin
					counter = 0;
					sample_ENABLE = 1'b1;	
				end
				else if ( sample_ENABLE == 1'b1 ) 
				begin
					sample_ENABLE = 1'b0;
				end
			end
			3'b100: 
			begin

				if ( counter == 14'd163 ) 
				begin
					counter = 0;
					sample_ENABLE = 1'b1;	
				end
				else if ( sample_ENABLE == 1'b1 ) 
				begin
					sample_ENABLE = 1'b0;
				end
			end
			3'b101: 
			begin
				if ( counter == 14'd81 ) 
				begin
					counter = 0;
					sample_ENABLE = 1'b1;	
				end
				else if ( sample_ENABLE == 1'b1 ) 
				begin
					sample_ENABLE = 1'b0;
				end
			end
			3'b110: 
			begin

				if ( counter == 14'd54 ) 
				begin
					counter = 0;
					sample_ENABLE = 1'b1;	
				end
				else if ( sample_ENABLE == 1'b1 ) 
				begin
					sample_ENABLE = 1'b0;
				end
			end
			3'b111: 
			begin

				if ( counter == 14'd27 ) 
				begin
					counter = 0;
					sample_ENABLE = 1'b1;	
				end
				else if ( sample_ENABLE == 1'b1 ) 
				begin
					sample_ENABLE = 1'b0;
				end
			end
		endcase
	end
end

endmodule 