///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number      : 2
// Full Name       : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

module uart (rst, clk, Tx_DATA, Tx_BUSY, baud_select, Tx_WR, Tx_EN, Rx_EN, Rx_DATA, Rx_VALID, Rx_FERROR, Rx_PERROR);

input rst, clk;
input [7:0] Tx_DATA;
input [2:0] baud_select;
input Tx_WR,Tx_EN, Rx_EN;

output [7:0] Rx_DATA;
output Rx_PERROR;
output Rx_FERROR;
output Rx_VALID;
output Tx_BUSY;

wire TxD;
wire Tx_BUSY;
wire [7:0] Rx_DATA;
wire [7:0] Tx_DATA;
wire [2:0] baud_select;
wire Tx_EN, Rx_EN;
wire Rx_FERROR;
wire Rx_PERROR;
wire Rx_VALID;

//Synchronize reset using two flip flops to avoid setup and hold violations.

reset_synchronizer reset_synchronizer_0(rst, clk, reset);

//Instantiate Transmitter

uart_transmitter uart_transmitter_0(reset, clk, Tx_DATA, baud_select, Tx_WR, 
Tx_EN, TxD, Tx_BUSY);

//Instantiate Receiver. Connect Transmitter to Receiver (TxD <===> RxD)

uart_receiver uart_receiver_0 (reset, clk, Rx_DATA, baud_select, Rx_EN, TxD, 
Rx_FERROR, Rx_PERROR, Rx_VALID);

endmodule