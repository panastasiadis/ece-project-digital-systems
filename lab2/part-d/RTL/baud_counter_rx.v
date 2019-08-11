///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number      : 2
// Full Name       : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

module baud_counter_rx ( reset, clk, STARTBIT, counter_ENABLE, Rx_sample_ENABLE, sample_now );
	input reset;
	input clk;
	input STARTBIT;
	input counter_ENABLE;
	input Rx_sample_ENABLE;
	output reg sample_now;

	reg [3:0] baud_counter;

	//baud counter for receiver

	always @( posedge reset or posedge clk ) begin
		if (reset) begin
			baud_counter = 4'b0000;
			sample_now = 1'b0;
		end

		//If startbit is 1 calculate 8 baud cycles

		else if (counter_ENABLE == 1 && STARTBIT == 1 && baud_counter == 4'b1000 && Rx_sample_ENABLE == 1'b1) begin
			baud_counter = 4'b0000;
			sample_now = 1'b1;
		end

		//After starbit for every other bit (data bit, parity bit or stop bit) calculate 16 cycles 

		else if (counter_ENABLE == 1 && baud_counter == 4'b1111 && Rx_sample_ENABLE == 1'b1) begin
			baud_counter = 4'b0000;
			sample_now = 1'b1;
		end
		else if ( counter_ENABLE == 1 && Rx_sample_ENABLE == 1'b1) begin
			baud_counter = baud_counter + 1;
			sample_now = 1'b0;
		end
		else begin
			sample_now = 1'b0;
		end
	end

endmodule