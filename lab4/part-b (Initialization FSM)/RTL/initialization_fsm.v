///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number      : 4
// Full Name       : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

module initialization_fsm ( reset, clk, lcd_e_init, init_data, initialization_done );

input reset, clk;
output reg lcd_e_init;
output reg [3:0] init_data;
output reg initialization_done;

reg [19:0] clock_counter;
reg counter_enable;

reg done;

reg [3:0] state;
reg [3:0] next_state;
 
parameter 
		  INIT_1 = 4'b0000,
		  INIT_2 = 4'b0001,
		  INIT_3 = 4'b0010,
		  INIT_4 = 4'b0011,
		  INIT_5 = 4'b0100,
		  INIT_6 = 4'b0101,
		  INIT_7 = 4'b0110,
		  INIT_8 = 4'b0111,
		  INIT_9 = 4'b1000,
		  DONE   = 4'b1001;

//-----------------------ALWAYS BLOCK --> INITIALIZATION PROCESS-------------------------------------------// 

//Depending on current state, increment clock_counter to specific max value (-WHEN INITIALIZATION IS STILL ON PROGRESS-)

always @(posedge clk or posedge reset) begin

	if (reset) begin //reset
		clock_counter = 20'd0;
		done = 0;
	end
	else if ( clock_counter == 20'd750000 && next_state == INIT_1 ) begin //count 15ms for init state 1 
		clock_counter = 20'd0;
		done = 1;
	end
	else if ( clock_counter == 20'd11 && ( next_state == INIT_2 || next_state == INIT_4 || next_state == INIT_6 || next_state == INIT_8 )) begin  //count 12 cycles for LCD_E == 1 -> init states 2,4,6,8 
		clock_counter = 20'd0;
		done = 1;
	end
	else if ( clock_counter == 20'd204999 && next_state == INIT_3 ) begin //count 4.1ms for init state 3
		clock_counter = 20'd0;
		done = 1;
	end
	else if ( clock_counter == 20'd4999 && next_state == INIT_5 ) begin //count 100us for init state 5
		clock_counter = 20'd0;
		done = 1;
	end
	else if ( clock_counter == 20'd1999 && ( next_state == INIT_7 || next_state == INIT_9 )) begin 	//count 40us for init states 7,9
		clock_counter = 20'd0;
		done = 1;
	end
	else if ( counter_enable == 1'b1 ) begin
		clock_counter = clock_counter + 1;
		done = 0;
	end

end

//---------------------------------------------------------------------------------------------------------//

//-----------------------ALWAYS BLOCKS --> FOR FSM STATES MANAGEMENT---------------------------------------//

//FSM of 10 states

always @(posedge clk or posedge reset) begin

   if (reset) begin
      // reset
      state = INIT_1;
   end
   else begin
      state = next_state;
   end

end

//States management

always @(*) begin
   
   next_state = state;

   counter_enable = 1'b0;
   lcd_e_init = 0;
   init_data = 4'h3;
   initialization_done = 1'b0;

   case (state)

    	INIT_1: begin //wait 15ms

      		counter_enable = 1'b1;

	        if ( done == 1'b1 ) begin
	            next_state = INIT_2;
	            lcd_e_init = 1'b1;
	            init_data = 4'h3;
	        end

	    end
    	INIT_2: begin  //LCD_E = 1, 12 cycles, SF_D = 0x03

      		counter_enable = 1'b1;
      		lcd_e_init = 1'b1;
      		init_data = 4'h3;

      		if ( done == 1'b1 ) begin
      			lcd_e_init = 1'b0;
      			next_state = INIT_3;
      		end

    	end
    	INIT_3: begin //wait 4.1ms

      		counter_enable = 1'b1;

        	if ( done == 1'b1 ) begin
            	next_state = INIT_4;
            	lcd_e_init = 1'b1;
            	init_data = 4'h3;
        	end

     	end
    	INIT_4: begin //LCD_E = 1, 12 cycles, SF_D = 0x03

      		counter_enable = 1'b1;
      		lcd_e_init = 1'b1;
      		init_data = 4'h3;

      		if ( done == 1'b1 ) begin
      			lcd_e_init = 1'b0;
      			next_state = INIT_5;
	      	end

    	end
    	INIT_5: begin //wait 100us

    		counter_enable = 1'b1;
    	
    		if ( done == 1'b1 ) begin
            	next_state = INIT_6;
            	lcd_e_init = 1'b1;
            	init_data = 4'h3;
        	end

    	end
    	INIT_6: begin //LCD_E = 1, 12 cycles, SF_D = 0x03

      		counter_enable = 1'b1;
      		lcd_e_init = 1'b1;
      		init_data = 4'h3;

      		if ( done == 1'b1 ) begin
      			lcd_e_init = 1'b0;
      			next_state = INIT_7;
	      	end

    	end
    	INIT_7: begin //wait 40us
    		
    		counter_enable = 1'b1;
    		init_data = 4'h2;
    		
    		if ( done == 1'b1 ) begin
            	next_state = INIT_8;
            	lcd_e_init = 1'b1;
        	end

    	end
    	INIT_8: begin //LCD_E = 1, 12 cycles, SF_D = 0x02
      		
      		counter_enable = 1'b1;
      		lcd_e_init = 1'b1;
      		init_data = 4'h2;
      		
      		if ( done == 1'b1 ) begin
      			lcd_e_init = 1'b0;
      			next_state = INIT_9;
	      	end

    	end
    	INIT_9: begin //wait 40us
    		
    		counter_enable = 1'b1;

    		if ( done == 1'b1 ) begin
            	next_state = DONE;
            	counter_enable = 1'b0;
    			initialization_done = 1'b1;
        	end

    	end
    	DONE: begin //Finish LCD Initialization
    		
    		counter_enable = 1'b0;
    		initialization_done = 1'b1;
    	
    	end

   endcase 
   
end

//---------------------------------------------------------------------------------------------------------//

endmodule