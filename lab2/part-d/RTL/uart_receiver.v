///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number      : 2
// Full Name       : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

module uart_receiver(reset, clk, Rx_DATA, baud_select, Rx_EN, RxD, 
Rx_FERROR, Rx_PERROR, Rx_VALID);

input reset, clk;
input [2:0] baud_select;
input Rx_EN;
input RxD;

output reg [7:0] Rx_DATA;
output reg Rx_FERROR; // Framing Error //
output reg Rx_PERROR; // Parity Error //
output reg Rx_VALID; // Rx_DATA is Valid //

reg stored_bit;
reg [3:0] bit_counter;
reg clear_counter;

reg [10:0] raw_data;

reg [1:0] state;
reg [1:0] next_state;
reg counter_ENABLE;
reg error;
reg parity_check;
reg load;

wire Rx_sample_ENABLE;
wire sample_now;
wire STARTBIT;


//Receiver states parameters

parameter
IDLE         = 0,
RECV         = 1,
LOAD         = 2,
DAV          = 3;


//Store incoming bit to register every clock cycle

always @(posedge clk or posedge reset) begin
	if (reset) begin
		stored_bit = 1'b1;
	end
	else if ( Rx_EN == 1'b0 ) begin
		stored_bit = 1'b1;
	end
	else begin
		stored_bit = RxD;
	end
end

//instantiation of baud_controller. A sample signal is sent with frequency 16 x Baud Rate 

baud_controller baud_controller_rx_instance(reset, clk, baud_select, Rx_sample_ENABLE);

//Manipulate baud controller. If startbit is sent sample it right after 8 baud cycles.
//After startbit sample next bit after 16 baud cycles 

baud_counter_rx baud_counter_rx_0( reset, clk, STARTBIT, counter_ENABLE, Rx_sample_ENABLE, sample_now );

//When sample_now is sent by baud_counter_rx increment bit counter to calculate number of bits.

always @( posedge clk or posedge reset )
  if ( reset ) begin
  	bit_counter = 4'b0000;
  end
  else if ( clear_counter == 1'b1 || Rx_EN == 1'b0 ) begin
    bit_counter = 4'b0000;
  end
  else if ( clear_counter == 0 && sample_now == 1 ) begin
  	bit_counter = bit_counter + 1;
  end

//After every sampling of incoming bit, store bit to [10:0] register raw_data along with parity bit.
//Store every new bit at MSB position of raw_data register

always @( posedge clk or posedge reset ) begin
	if ( reset ) begin
		raw_data = 11'd0;
		parity_check = 0;
	end
	else if (Rx_EN == 1'b0) begin
		raw_data = 11'd0;
		parity_check = 0;
	end
	else if ( sample_now == 1  ) begin
		raw_data = {stored_bit, raw_data[10:1]};
		parity_check = ^(raw_data[8:1]);
	end
end
  		

//Data register. Store the character received
//1.When all bits are sent and load signal is 1, store data to Rx_DATA
//2.If stop bit and start bit are wrong send frame error and do not store anything
//3.Calcuate parity bit of receiving data. 
//	if calculated parity bit and received parity bit do not match send parity error.

always @(posedge clk or posedge reset)
  if ( reset ) begin
    Rx_DATA = 0;
    error = 0;
    Rx_PERROR = 1'b0;
   	Rx_FERROR = 1'b0;
  end
  else if (Rx_EN == 0) begin
  	Rx_DATA = 0;
   	error = 0;
   	Rx_PERROR = 1'b0;
   	Rx_FERROR = 1'b0;
  end
  else if (load && parity_check != raw_data[9])	begin
  	Rx_PERROR = 1'b1;
  	error = 1;
  end
  else if (load && ((raw_data[10] == 0) || (raw_data[0] == 1))) begin
  	Rx_FERROR = 1'b1;
  	error = 1;
  end
  else if ( Rx_FERROR == 1'b1 || Rx_PERROR == 1'b1 ) begin
    Rx_PERROR = 1'b0;
    Rx_FERROR = 1'b0;
  end
  else if ( load ) begin
  	error = 0;
  	Rx_DATA = raw_data[8:1];
  end  

//Transition between states

always @(posedge clk or posedge reset)
  if ( reset )
    state <= IDLE;
  else if ( Rx_EN == 1'b0 )
    state <= IDLE;
  else
  	state <= next_state;

//if we are at bit zero we are going to sample startbit.
//Make STARTBIT signal 1 for baud_counter_rx 

assign STARTBIT = (bit_counter == 0) ? 1:0 ;

//-- Control signal generation and next states

always @(*) begin

  //-- Default values
  //-- Stay in the same state by default

  next_state = state;      
  counter_ENABLE = 0;
  clear_counter = 0;
  load = 0;

  case(state)

    //Idle state
    //Remain in this state until a start bit is received in Tx_WR

    IDLE: begin
      clear_counter = 1;
      Rx_VALID = 0;
      if ( stored_bit == 0 && Rx_EN == 1'b1 ) begin
      	next_state = RECV;
      	counter_ENABLE = 1;
      end
        
    end

    //Receiving state
    //Enable counter and wait for the serial package to be received

    RECV: begin
      counter_ENABLE = 1;
      Rx_VALID = 0;
      if (bit_counter == 4'd11) begin
        next_state = LOAD;
      end
    end

    //Change value of load to 1. Check if there are errors otherwise store the data to Rx_DATA. 
    
    LOAD: begin
      load = 1;
      Rx_VALID = 0;
      next_state = DAV;
    end

    //No error -> Data Available (1 cycle).
    //Error    -> None of the data are stored, go to state idle.
   
    DAV: begin
    	if ( error == 0) begin
    		Rx_VALID = 1;
    		next_state = IDLE;
    	end
      else begin 
      		next_state = IDLE;
          Rx_VALID = 1'b0;
      end
    end

    default:
      Rx_VALID = 0;

  endcase
end

endmodule