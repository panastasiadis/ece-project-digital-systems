///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number      : 2
// Full Name       : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

module baud_counter_tx ( reset, clk, counter_ENABLE, Tx_sample_ENABLE, baud_tx_clk );
	input reset;
	input clk;
	input counter_ENABLE;
	input Tx_sample_ENABLE;
	output reg baud_tx_clk;

	reg [3:0] baud_counter;

	//baud counter for transmitter

	always @( posedge reset or posedge clk ) begin
		if (reset) begin
			baud_counter = 4'b0000;
			baud_tx_clk = 1'b0;
		end

		//after 16 baud signals send signal for transmitter  

		else if (counter_ENABLE == 1 && baud_counter == 4'b1111 && Tx_sample_ENABLE == 1'b1) begin
			baud_counter = 4'b0000;
			baud_tx_clk = 1'b1;
		end
		else if ( counter_ENABLE == 1 && Tx_sample_ENABLE == 1'b1) begin
			baud_counter = baud_counter + 1;
			baud_tx_clk = 1'b0;
		end
		else begin
			baud_tx_clk = 1'b0;
		end
	end

endmodule