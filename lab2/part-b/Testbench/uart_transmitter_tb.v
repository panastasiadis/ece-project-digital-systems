///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number 	   : 2
// Full Name  	   : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

module uart_transmitter_tb ();

reg clk = 0;
reg rst = 1;
reg Tx_WR;

wire [2:0] baud_select;
wire [7:0] Tx_DATA;

reg [1:0]  i;
reg [1:0] first;

reg  [7:0] sequence [0:3];

//Set value of baud select to 115200 bits/sec

assign baud_select = 3'b111;

//Initialize transmission by setting Tx_WR to value 1 after 1500 ns

initial begin
	#74 rst=0;
	#1500 Tx_WR = 1;
end

//Fpga spartan 3 clock frequency ==> 50 Mhz

always #10 clk <= ~clk;

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
	else if (Tx_BUSY == 0 && first == 2'b00) begin
		Tx_WR = 1;
		i = i + 1;
	end
	else if (Tx_BUSY == 0 && first == 2'b01) begin
		Tx_WR = 1;
		i = i + 1;
		first = 2'b00;
	end
end

//assign sequence value to Tx_Data
//At every Tx_WR == 1 assign continuously 4 values of sequence register to Tx_Data

assign Tx_DATA = sequence[i];


 uart_transmitter uart_transmitter_0(.rst (rst), .clk(clk), .Tx_DATA (Tx_DATA), .baud_select(baud_select), .Tx_WR(Tx_WR), .Tx_EN(1'b1), .TxD(TxD), .Tx_BUSY(Tx_BUSY));


endmodule