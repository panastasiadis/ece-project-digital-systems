///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number      : 2
// Full Name       : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

module uart_transmitter(reset, clk, Tx_DATA, baud_select, Tx_WR, Tx_EN, TxD, Tx_BUSY);

input reset, clk;
input [7:0] Tx_DATA;
input [2:0] baud_select;
input Tx_EN;
input Tx_WR;

output reg TxD;
output reg Tx_BUSY;

reg [7:0] stored_data;
reg [1:0] state;
reg [1:0] next_state;
reg [9:0] shifter;

reg [3:0] bit_counter;
reg counter_ENABLE;
reg load_shifter;

wire Tx_sample_ENABLE;
wire baud_tx_clk;

//States names of transmitter.

parameter
IDLE         = 0,
START        = 1,
TRANSMISSION = 2;


//Baud controller drives sample signal to 1 with 16 x Baud Rate frequency

baud_controller baud_controller_tx_instance(reset, clk, baud_select, Tx_sample_ENABLE);

//Baud counter for transmitter. Transmitter should send a bit every 1/ baud rate seconds.
//Therefore baud_counter_tx manipulates sample signal from baud_controller and creates a new clock signal with frequency equal to baud to rate.

baud_counter_tx baud_counter_tx_0 ( reset, clk, counter_ENABLE, Tx_sample_ENABLE, baud_tx_clk );

//If Tx_WR signal is enabled store value of Tx_Data to register.
//Otherwise set register to value 8'b1111111.  

always @(posedge clk or posedge reset) begin
  if (reset) begin
    stored_data = 8'b11111111;
  end
  else if ( Tx_WR == 1'b1 && state == IDLE && Tx_EN == 1'b1 ) begin
    stored_data = Tx_DATA;
  end
  else if ( Tx_EN == 0 ) begin
    stored_data = 8'b11111111;
  end
end

//1.If transmitter is initialized in START STATE (load_shifter == 1) store to shifter 8-bit data + start bit + stop bit + parity bit.
//2.Every baud_tx_clk a new bit must be send. Increment the bit counter and set shifter[0] with the next value.

always @(posedge clk or posedge reset) begin
  if ( reset ) begin
    shifter = 10'b1_1111_11111; 
    bit_counter = 0;
  end
  else if (Tx_EN == 1'b0) begin

    shifter = 10'b1_1111_11111; 
    bit_counter = 0;

  end
  else if ( load_shifter == 1 ) begin
    shifter = { (^stored_data), stored_data, 1'b0 };
    bit_counter = 0;
  end
  else if ( load_shifter == 1'b0 && baud_tx_clk == 1'b1) begin
    shifter = {1'b1, shifter[9:1]};
    bit_counter = bit_counter + 1;
  end
end

//Every posedge clock send to output TxD the value of shifter[0]

always @(posedge clk) begin
  TxD = shifter[0];
end
  
//// States of transmitter ////
  
always @(posedge clk or posedge reset)
  if ( reset )
    state <= IDLE;
  else if (Tx_EN == 1'b0)
    state <= IDLE;
  else
    state <= next_state;


always @(*) begin

  //Default values
  //Stay in the same state by default

  next_state = state;     
  load_shifter = 0;
  counter_ENABLE = 0;

  case (state)

    //Idle state
    //Remain in this state until Tx_WR is 1
    
    IDLE: begin
      Tx_BUSY = 0;
      if (Tx_WR == 1'b1 && Tx_EN == 1'b1)
        next_state = START;
    end

    //1 cycle long
    //turn on the baud counter and load the shift register

    START: begin
      load_shifter = 1;
      counter_ENABLE = 1;
      Tx_BUSY = 1;
      next_state = TRANSMISSION;
    end
    
    //Stay here until all the bits have been sent
    
    TRANSMISSION: begin
      counter_ENABLE = 1;
      Tx_BUSY = 1;
      if (bit_counter == 11)
        next_state = IDLE;
    end

    default:
      Tx_BUSY = 1;
  
  endcase

end

endmodule 