///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number      : 3
// Full Name       : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

module vpixel_controller (reset, clk, new_frame,new_line, vpixel);

input reset, clk,new_frame, new_line;
output reg [6:0] vpixel;

reg [2:0] scaleTo480_counter;
reg scale_done;

//scaleTo480 counter forces vpixel to keep its value five times of new_line signal being active. 

always @(posedge clk or posedge reset) begin
   if (reset) begin
      // reset
      scaleTo480_counter = 3'b0;
      vpixel = 7'd0;
   end
   else if ( vpixel == 7'd95 && scaleTo480_counter == 3'd4 && scale_done == 1'b1 ) begin
      vpixel = 7'd0;
      scaleTo480_counter = 3'd0;
   end
   else if ( scaleTo480_counter == 3'd4 && scale_done == 1'b1 ) begin
      scaleTo480_counter = 3'd0;
      vpixel = vpixel + 1;
   end
   else if ( scale_done == 1'b1 ) begin
      scaleTo480_counter = scaleTo480_counter + 1;
   end
end

reg [1:0] state;
reg [1:0] next_state;
 
parameter STATE_zero = 2'b00,
          STATE_one = 2'b01,
          STATE_IDLE = 2'b10;

//FSM of 3 states for vpixel_controller

always @(posedge clk or posedge reset) begin
   if (reset) begin
      // reset
      state = STATE_zero;
   end
   else begin
      state = next_state;
   end
end

//States management

always @(*) begin
   next_state = state;
   scale_done = 1'b0;
   case (state)
      STATE_zero: begin //initialization state..
         if ( new_line == 1 && new_frame == 1) begin
            next_state = STATE_one;
         end
      end
      STATE_one: begin //when new_line is set to zero, send scale_done signal to indicate that scale_counter should increase.   
         if ( new_line == 0 && new_frame == 1) begin
            scale_done = 1'b1;
            next_state = STATE_IDLE;
         end
      end
      STATE_IDLE: begin //controller should stay idle the whole time when new_line is 1 except the first_time (State_zero)
         if ( new_line == 1'b1 && new_frame == 1) begin
            next_state = STATE_one;
         end
      end
   endcase 
end

endmodule