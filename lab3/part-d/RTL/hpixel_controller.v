///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number      : 3
// Full Name       : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

module hpixel_controller (reset, clk, new_line, hpixel);

input reset, clk, new_line;
output reg [6:0] hpixel;

reg [2:0] scaleTo640_counter;
reg end_of_line;
reg scale_done;

//scaleTo640_counter counts 5 times when new_line is active.
//1.scaleTo640_counter max value indicates that next horizontal pixel should be send as output.
//2.scaleTo640_counter in other words keep the output the same for 5 times.
//...This means that 128 horizontal pixel line will scale to 640 pixels.

always @(posedge clk or posedge reset) begin
	if (reset) begin
		// reset
		scaleTo640_counter = 3'b0;
		end_of_line = 1'b0;
	end
	else if ( new_line == 1'b0 ) begin
	 	end_of_line = 1'b0;
	end
	else if ( hpixel == 7'd127 && scale_done == 1'b1 && scaleTo640_counter == 3'd4 ) begin
		scaleTo640_counter = 3'd0;
		end_of_line = 1'b1; //end of the line indicates that the final horizontal pixel was sent to output.
	end
	else if ( scale_done == 1'b1 && scaleTo640_counter == 3'd4 ) begin
		scaleTo640_counter = 3'd0;
	end
	else if ( scale_done == 1'b1 ) begin
		scaleTo640_counter = scaleTo640_counter + 1;
	end
end

//Increment horizontal pixel when new_line is active and according to scaleTo640_counter value 

always @(posedge clk or posedge reset) begin
	if (reset) begin
		// reset
		hpixel = 7'd0;
	end
	else if ( hpixel == 7'd127 && end_of_line == 1'b1 ) begin
		hpixel = 7'd0;
	end 
	else if ( scaleTo640_counter == 3'd0 && scale_done == 1'b1 ) begin
		//after scaleTo640_counter indicates that same pixel was sent for five times, next pixel sould be sent.   
		hpixel = hpixel + 1;
	end
end


reg [1:0] state;
reg [1:0] next_state;
 
parameter STATE_wait = 2'b00,
          STATE_set = 2'b01;

//FSM of 2 states for hpixel_controller

always @(posedge clk or posedge reset) begin
   if (reset) begin
      // reset
      state = STATE_wait;
   end
   else begin
      state = next_state;
   end
end

//States management
//Scan-line time consists of 1280 cycles. Therefore, 640 pixels should be sent after every two clock cycles.   

always @(*) begin
   next_state = state;
   scale_done = 1'b0;
   case (state)
      STATE_set: begin // Assign address of horizontal pixel
         if ( new_line == 1 ) begin
            next_state = STATE_wait;
            scale_done = 1'b1;
         end
      end
      STATE_wait: begin //Wait one cycle before next asssign. 
         if ( new_line == 1 ) begin
            next_state = STATE_set;
         end
      end
   endcase 
end

endmodule