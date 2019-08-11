///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number      : 4
// Full Name       : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

module time_control_fsm ( reset, clk, fsm_enable ,lcd_e_tc_fsm, send_upper, send_lower );

input reset, clk;
input fsm_enable;
output reg lcd_e_tc_fsm;
output reg send_upper, send_lower;

reg setup_counter_enable;
reg palm_enable;

reg [5:0] count_to_1us; 
reg [10:0] count_to_40us;

reg wait_enable;

reg switch_to_1us;
reg switch_to_40us;

reg [1:0] setup_counter;
reg [3:0] palm_counter;

reg [2:0] state;
reg [2:0] next_state;

parameter STATE_IDLE = 3'b000,
          STATE_SETUP= 3'b001,
          STATE_LCD_E_PALM = 3'b010,
          STATE_HOLD = 3'b011,
          STATE_WAIT = 3'b100;

//-----------------------ALWAYS BLOCK --> FOR STATES SETUP & LCD_E_PALM--------------------------------------// 

//1.Setup counter counts 40ns, in order to raise LCD_E(lcd_e_tc_fsm) value to 1. (STATE SETUP)
//Setup counter only increments in state setup, when setup_enable == 1.

//2.Palm counter counts 240ns(12 cycles), for LCD_E(lcd_e_tc_fsm) to hold its value to 1. (STATE LCD_E_PALM)
//Palm counter only increments in state LCD_E_PALM, when palm_enable == 1.

always @(posedge clk or posedge reset) begin

	if ( reset ) begin // reset
		setup_counter = 2'd0;
		palm_counter = 4'd0;
		lcd_e_tc_fsm = 1'b0;
	end
	else if ( palm_counter == 4'd11 && palm_enable == 1'b1 ) begin
		palm_counter = 4'd0;
		lcd_e_tc_fsm = 1'b0;
	end
	else if ( palm_enable == 1'b1 ) begin
		palm_counter = palm_counter + 1;
	end
	else if ( setup_counter == 2'd1 && setup_counter_enable == 1'b1 ) begin
		setup_counter = 2'd0;
		lcd_e_tc_fsm = 1'b1;
	end
	else if ( setup_counter_enable == 1'b1 ) begin
		setup_counter = setup_counter + 1;
	end

end

//---------------------------------------------------------------------------------------------------------//

//-----------------------ALWAYS BLOCK --> FOR STATE WAIT---------------------------------------------------//

//This always block is active when time_control fsm is activated (fsm_enable == 1) 
//..and cirquit is going through state STATE_WAIT

//1.if fsm is deactivated (fsm_enable == 0), leave always block "idle" with same values as reset.

//2.when in state WAIT, and upper bits are already sent --> wait 1us (switch_to_1us == 1, switch_to_40us == 0),
//Increment count_to_1us counter.

//3.when in state WAIT, and next command or data are to be sent --> wait 40us (switch_to_1us == 0, switch_to_40us == 1),
//Increment count_to_40us counter.

always @(posedge clk or posedge reset) begin

  if (reset) begin
    count_to_1us = 6'd0;
    count_to_40us = 11'd0;
    switch_to_1us = 1'b1;
    switch_to_40us = 1'b0;
  end
  else if ( fsm_enable == 0 ) begin
    count_to_1us = 6'd0;
    count_to_40us = 11'd0;
    switch_to_1us = 1'b1;
    switch_to_40us = 1'b0;
  end
  else if ( wait_enable == 1'b1 && count_to_1us == 6'd49 && switch_to_1us == 1'b1 ) begin
    count_to_1us = 6'd0;
    switch_to_1us = 1'b0;
    switch_to_40us = 1'b1;
  end
  else if ( wait_enable == 1'b1 && switch_to_1us == 1'b1 ) begin
    count_to_1us = count_to_1us + 1;
  end
  else if ( wait_enable == 1'b1 && count_to_40us == 11'd1999 && switch_to_40us == 1'b1  ) begin
    count_to_40us = 11'd0;
    switch_to_1us = 1'b1;
    switch_to_40us = 1'b0;
  end
  else if ( wait_enable == 1'b1 && switch_to_40us == 1'b1 ) begin
    count_to_40us = count_to_40us + 1;
  end

end

//---------------------------------------------------------------------------------------------------------//

//-----------------------ALWAYS BLOCKS --> FOR FSM STATES MANAGEMENT---------------------------------------//

//FSM of 5 states

always @(posedge clk or posedge reset) begin

   if (reset) begin
      // reset
      state = STATE_IDLE;
   end
   else begin
      state = next_state;
   end

end

//States management

always @(*) begin
   
   next_state = state;
   setup_counter_enable = 1'b0;
   palm_enable = 1'b0;
   wait_enable = 1'b0;
   send_upper = 1'b0;
   send_lower = 1'b0;

   case (state)

      STATE_IDLE: begin  

        if ( fsm_enable == 1'b1 ) begin //module is idle until fsm is activated.
            next_state = STATE_SETUP;
        end
      
      end
      STATE_SETUP: begin 
      
      	setup_counter_enable = 1'b1; //enable setup counter
      
      	if ( setup_counter == 2'd1 ) begin //if setup counter reaches max value, proceed to next state
      		next_state = STATE_LCD_E_PALM;
      	end
      
      end
      STATE_LCD_E_PALM: begin
    	
    	palm_enable = 1'b1; //enable lcd_e palm counter
        
        if ( palm_counter == 4'd11 ) begin //if palm counter reaches max value, proceed
          next_state = STATE_HOLD;
        end

      end
      STATE_HOLD:  begin 
       
        if ( switch_to_1us == 1'b0 ) begin  //if upper bits (new command or date) are to be sent, 
          send_upper = 1'b1; 				//..send to output 1-cycle-active signal for upper bits 
        end
        else begin //if lower bits are to be sent, send to output 1-cycle-active signal for lower bits 
          send_lower = 1'b1;
        end

        next_state = STATE_WAIT;  //hold state lasts one cycle until next state 

      end
      STATE_WAIT: begin

        wait_enable = 1'b1; //start wait counter for 40us or 1us
      
        if ( count_to_1us == 6'd49 || count_to_40us == 11'd1999 ) begin //if one of the counters is active and reaches max value,
          next_state = STATE_SETUP; 								    //..proceed to state setup for new data to be sent.
        end
        else if ( fsm_enable == 0 ) begin //if input signal disabled fsm, go to state IDLE
          next_state = STATE_IDLE;
        end

      end
      
   endcase 

end

//---------------------------------------------------------------------------------------------------------//

endmodule
