///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number      : 4
// Full Name       : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

module configuration_fsm ( reset, clk, initialization_done, timing_control_enable, send_upper, send_lower, lcd_rs, config_data, character_data  );

input reset, clk;
input initialization_done;
input send_upper, send_lower;

output reg timing_control_enable;
output reg lcd_rs;
output reg [3:0] config_data;

reg change_state;
reg counter_enable;
reg [26:0] clock_counter;
reg done;

reg [10:0] address;
reg all_addresses_sent;

reg [3:0] state;
reg [3:0] next_state;

reg last_char_change;
reg lower_bits_time;
 
parameter IDLE               = 4'b0000,
          FUNCTION_SET       = 4'b0001,
          ENTRY_MODE_SET     = 4'b0010,
          DISPLAY_ON_OFF     = 4'b0011,
          CLEAR_DISPLAY      = 4'b0100,
          WAIT_1_64_MS       = 4'b0101,
          SET__DDRAM_ADDRESS = 4'b0110,
          DATA_TRANSFER      = 4'b0111,
          WAIT_1_SEC         = 4'b1000;

output [3:0] character_data;

wire [7:0] memory;

//-----------------------ALWAYS BLOCK --> FOR STATES OF CONFIGURATION LCD COMMANDS-------------------------// 

//Always block affects ONLY states FUNCTION_SET, ENTRY_MODE_SET, DISPLAY_ON_OFF, CLEAR_DISPLAY, SET_DDRAM_ADDRESS. 

//According to state - lcd_command, assign the right value to config_data register. 

//According to input signal send_upper or send_lower, assign to config_data the right upper or lower bits.

//...(See Spartan-3E User - Guide for details about configuration commands data)...//

//signal change_state informs fsm to procceed to next state.

always @(posedge clk or posedge reset) begin
	
	if ( reset ) begin
		// reset
		config_data = 4'b0000;
		change_state = 1'b1;
	end
	else if ( send_lower == 1'b1 && next_state == FUNCTION_SET ) begin
		config_data = 4'b1000;
		change_state = 1'b1;
	end
	else if ( send_upper == 1'b1 && next_state == ENTRY_MODE_SET ) begin
		config_data = 4'b0000;
	end
	else if ( send_lower == 1'b1 && next_state == ENTRY_MODE_SET ) begin
		config_data = 4'b0110;
		change_state = 1'b1;
	end
	else if ( send_upper == 1'b1 && next_state == DISPLAY_ON_OFF ) begin
		config_data = 4'b0000;
	end
	else if ( send_lower == 1'b1 && next_state == DISPLAY_ON_OFF ) begin
		config_data = 4'b1100;
		change_state = 1'b1;
	end
	else if ( send_upper == 1'b1 && next_state == CLEAR_DISPLAY ) begin
		config_data = 4'b0000;
	end
	else if ( send_lower == 1'b1 && next_state == CLEAR_DISPLAY ) begin
		config_data = 4'b0001;
		change_state = 1'b1;
	end
	else if ( send_lower == 1'b1 && next_state == SET__DDRAM_ADDRESS ) begin
		config_data = 4'b0000;
		change_state = 1'b1;
	end
	else if ( next_state == SET__DDRAM_ADDRESS ) begin
		config_data = 4'b1000;
	end
	else if ( next_state == FUNCTION_SET ) begin
		config_data = 4'b0010;
	end
	else begin
		change_state = 1'b0;
	end

end

//---------------------------------------------------------------------------------------------------------//

//-----------------------ALWAYS BLOCK --> FOR DATA_TRANFER STATE ONLY || BRAM INSTANTIATION----------------// 

//1.Always-block affects ONLY the DATA_TRANSFER state. 

//2.When in DATA_TRANSFER, after first send_upper signal, raise lcd_rs to 1.
//..Then, after every other send_upper or send_lower signal, increment address counter.

//3.address counter corresponds to Bram Memory address.

//4.lower_bits_time register is equal to 1 when lower bits of 8-bit data are to be sent.
//..This signal indicates to character_data assignment to consider the lower 4 bits of bram memory for the given address. 

//5.address = 11'd55 corresponds to "rectangle" character and address = 11'd56 corresponds to "space" character.
//..After every renewal of the LCD Display, last_char_change indicates what "else if" should be considered for the last lcd character,
//....depending on the previous visited "else if".

//6.Finaly, when all data are finally written in the LCD DISPLAY make all_addresses_sent singal equal to 1,
//..in order to inform the state machine to proceed to WAIT_1_SEC State.    

always @(posedge clk or posedge reset) begin

	if (reset) begin
		// reset
		address = 11'd0;
		lcd_rs = 1'b0;
		all_addresses_sent = 1'b0;
		last_char_change = 1'b1;
		lower_bits_time = 1'b0;
	end
	else if ( all_addresses_sent == 1'b1 ) begin
		all_addresses_sent = 1'b0;
	end
	else if ( ( address == 11'd56 || address == 11'd55 ) && send_upper == 1'b1 && next_state == DATA_TRANSFER ) begin
		lcd_rs = 1'b0;
		address = 11'b0;
		all_addresses_sent = 1'b1;
		lower_bits_time = 1'b0;
	end
	else if ( last_char_change == 1'b1 && address == 11'd54 && lcd_rs == 1'b1 && send_upper == 1'b1 && next_state == DATA_TRANSFER ) begin
		address = address + 1;
		last_char_change = 1'b0;
		lower_bits_time = 1'b0;
	end
	else if ( last_char_change == 1'b0 && address == 11'd54 && lcd_rs == 1'b1 && send_upper == 1'b1 && next_state == DATA_TRANSFER ) begin
		address = address + 2;
		last_char_change = 1'b1;
		lower_bits_time = 1'b0;
	end
	else if ( lcd_rs == 1'b1 && send_upper == 1'b1 && next_state == DATA_TRANSFER  ) begin
		address = address + 1;
		lower_bits_time = 1'b0;
	end
	else if ( lcd_rs == 1'b1 && send_lower == 1'b1 && next_state == DATA_TRANSFER  ) begin
		lower_bits_time = 1'b1;
	end
	else if ( send_upper == 1'b1 && next_state == DATA_TRANSFER ) begin
		lcd_rs = 1'b1;
		all_addresses_sent = 1'b0;
		lower_bits_time = 1'b0;
	end

end


bram bram_0 (.clk(clk), .addr(address), .char(memory));

assign character_data = ( lower_bits_time == 1'b1  ) ? memory[3:0] : memory [7:4];



//---------------------------------------------------------------------------------------------------------//

//-----------------------ALWAYS BLOCK --> FOR WAIT_1_64_MS & WAIT_1_SEC STATES ONLY------------------------// 

//Clock counter counts 1 sec when on state WAIT_1_SEC. done == 1 after finish.

//Clock counter counts 40 us when on state WAIT_1_64_MS. done == 1 after finish.

always @(posedge clk or posedge reset) begin

	if (reset) begin
		// reset
		clock_counter = 26'd0;
		done = 0;
	end
	else if ( done == 1 ) begin
		done = 0;
	end
	else if ( clock_counter == 26'd81999 && next_state == WAIT_1_64_MS ) begin
		clock_counter = 26'd0;
		done = 1;
	end
	else if ( clock_counter == 26'd49_999_999 && next_state == WAIT_1_SEC ) begin
		clock_counter = 26'd0;
		done = 1;
	end
	else if ( counter_enable == 1'b1 ) begin
		clock_counter = clock_counter + 1;
	end

end

//---------------------------------------------------------------------------------------------------------//

//-----------------------ALWAYS BLOCKS --> FOR FSM STATES MANAGEMENT---------------------------------------//

//FSM of 9 states

always @(posedge clk or posedge reset) begin
   
	if (reset) begin
      // reset
      state = IDLE;
    end
    else begin
      state = next_state;
    end
end

//States management

always @(*) begin
   
   next_state = state;
   timing_control_enable = 1'b1;
   counter_enable = 1'b0;

   	case ( state )

     IDLE: begin
      	
      	timing_control_enable = 1'b0; //Stay idle until initialization process is done.
      	
        if ( initialization_done == 1'b1 ) begin //Proceed to LCD Configuration process (First command - Function Set)
            next_state = FUNCTION_SET;
            timing_control_enable = 1'b1; // Enable time_control_fsm module.
        end

     end
     FUNCTION_SET: begin
      	
      	if ( change_state == 1'b1 ) begin 
      		next_state = ENTRY_MODE_SET;
      	end

     end
     ENTRY_MODE_SET: begin
      	
      	if ( change_state == 1'b1 ) begin
        	next_state = DISPLAY_ON_OFF;
        end

     end
     DISPLAY_ON_OFF:  begin
      	
      	if ( change_state == 1'b1 ) begin
        	next_state = CLEAR_DISPLAY;
        end

     end
     CLEAR_DISPLAY: begin
      	
      	if ( change_state == 1'b1 ) begin
        	next_state = WAIT_1_64_MS;
        end

      end
     WAIT_1_64_MS: begin //After the end of configuration wait 1,64 ms before data transfering.

   	  	if ( send_upper == 1'b1 || clock_counter != 0 ) begin //keep clock_counter enable until max value of 8200 cycles - 1.64ms.
      		timing_control_enable = 1'b0; //disable timing_control for the waiting process.
      		counter_enable = 1'b1;
      	end
      	else if ( done == 1'b1 ) begin //when waiting process is finished proceed to next state.
      		counter_enable = 1'b0; 
      		timing_control_enable = 1'b1; //enable again timing_control_fsm.
      		next_state = SET__DDRAM_ADDRESS;
      	end

     end
     SET__DDRAM_ADDRESS: begin //set DDRAM address to 0x00 address (Top Left Corner of Display).
      	
      	if ( change_state == 1'b1 ) begin
        	next_state = DATA_TRANSFER;
        end

     end
     DATA_TRANSFER: begin

      	if ( all_addresses_sent == 1'b1 ) begin //if all data were sent, proceed to second waiting state (1 second)
      		next_state = WAIT_1_SEC;
      		timing_control_enable = 1'b0;
      		counter_enable = 1'b1;
      	end

     end
     WAIT_1_SEC: begin

      	if ( clock_counter != 0 ) begin 
      		timing_control_enable = 1'b0;
      		counter_enable = 1'b1;
      	end
      	else if ( done == 1'b1 ) begin //when one second is passed, go to state IDLE and refresh display, by doing configuration process from the start.
      		counter_enable = 1'b0;
      		timing_control_enable = 1'b0;
      		next_state = IDLE;
      	end

     end

   	endcase

end

//---------------------------------------------------------------------------------------------------------//

endmodule