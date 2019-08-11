///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number 	   : 2
// Full Name  	   : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

module uart_receiver_tb ();

reg clk = 0;
reg reset = 1;

wire [2:0] baud_select;
wire [7:0] stored_data;
reg [9:0] shifter;

reg counter_ENABLE = 0;
reg [3:0] bit_counter;
reg RxD;

wire Tx_sample_ENABLE;
wire [7:0] Rx_DATA;
wire baud_tx_clk;

initial begin
	#74 reset=0;
end

//Fpga spartan 3 clock frequency ==> 50 Mhz

always #10 clk <= ~clk;

//Set value of baud select to 115200 bits/sec

assign baud_select = 3'b111;

//Set 8-bit sequence to send to receiver 

assign stored_data = 10'b10101010;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////---------Simulate transmitter behaviour, in order to send data to Receiver-----------//////////

baud_controller baud_controller_for_tb(reset, clk, baud_select, Tx_sample_ENABLE);


baud_counter_tx baud_counter_for_tb ( reset, clk, counter_ENABLE, Tx_sample_ENABLE, baud_tx_clk );

always @(posedge clk or posedge reset) begin
	if ( reset ) begin

		shifter = 10'b1_1111_11111; 
		bit_counter = 0;
	
	end
	else if ( counter_ENABLE == 0 ) begin
	
		counter_ENABLE = 1;
		shifter = { 1'b0 , stored_data, 1'b0 };
		bit_counter = 0;
	
	end
	else if ( bit_counter != 4'd11 && baud_tx_clk == 1'b1) begin
	
		shifter = {1'b1, shifter[9:1]};
		bit_counter = bit_counter + 1;
	
	end
	else if ( bit_counter == 4'd11 ) begin
		
		counter_ENABLE = 0;

	end	
end

always @(posedge clk) begin
	RxD = shifter[0];
end

/////////////////////////////////////////////////////////////////////////////////////////////////////////

//Instantiate Receiver Module
//Set Rx_Enable always to 1

uart_receiver uart_receiver_for_tb(reset, clk, Rx_DATA, baud_select, 1'b1, RxD, 
Rx_FERROR, Rx_PERROR, Rx_VALID);

endmodule