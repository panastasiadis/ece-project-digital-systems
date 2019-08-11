///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number 	   : 2
// Full Name  	   : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

module uart_tb ();

reg clk = 0;
reg rst = 1;
reg Tx_WR;

reg [1:0]  i;
reg [1:0] first;

reg  [7:0] sequence [0:3];
reg is_valid;
reg is_error;

wire [2:0] baud_select;
wire [7:0] Tx_DATA;
wire [7:0] Rx_DATA;

//Set value of baud select to 115200 bits/sec

assign baud_select = 3'b111;

//Initialize transmission by setting Tx_WR to value 1 after 1500 ns

initial begin
	#74 rst=0;
	#1500 Tx_WR = 1;
end

//Fpga spartan 3 clock frequency ==> 50 Mhz

always #10 clk <= ~clk;

//After every Rx_VALID == 1 (receiver received data successfully) and Tx_BUSY == 0 (Transmitter is not busy and can send data again )
//-->send Tx_WR signal and write next sequence of data 

always @(posedge clk or posedge rst) begin
	if (rst) begin
		// reset
		Tx_WR = 0;
		i = 0;
		sequence[0] = 8'hAA;
		sequence[1] = 8'h55;
		sequence[2] = 8'hCC;
		sequence[3] = 8'h89;
		first = 2'b10;
	end
	else if (Tx_WR) begin
		Tx_WR = 0;
	end
	else if (Tx_BUSY == 0 && i == 2'b11) begin
		i = 0;
		Tx_WR = 1;
	end
	else if (Tx_BUSY == 1) begin
		first = 2'b01;
	end
	else if (Tx_BUSY == 0 && first == 2'b00 && is_valid == 1) begin
		Tx_WR = 1;
		i = i + 1;
	end
	else if (Tx_BUSY == 0 && first == 2'b01 && is_valid == 1) begin
		Tx_WR = 1;
		i = i + 1;
		first = 2'b00;
	end
	else if ( is_error == 1 ) begin
		$display ("Error in Data");
	end
end

//assign sequence value to Tx_Data
//At every Tx_WR == 1 assign continuously 4 values of sequence register to Tx_Data

assign Tx_DATA = sequence[i];

//If there is error in receiver make is_error 1 in order for an error message to be dispalyed on screen.

always @(posedge clk or posedge rst) begin
	if (rst) begin
		// reset
		is_valid = 0;
		is_error = 0;
	end
	else if ( Rx_VALID == 1 ) begin
		is_valid = Rx_VALID;
	end
	else if ( Tx_WR == 1) begin
		is_valid = 0;
	end
	else if ( Rx_FERROR == 1 || Rx_PERROR == 1 ) begin
		is_error = 1;
	end
end

//Instatiation of uart system
//Alwawys enable receiver and transmitter. Always Rx_EN == 1 and Tx_EN == 1. 

uart uart_0 (rst, clk, Tx_DATA, Tx_BUSY, baud_select, Tx_WR, 1'b1, 1'b1, Rx_DATA, Rx_VALID, Rx_FERROR, Rx_PERROR);

endmodule