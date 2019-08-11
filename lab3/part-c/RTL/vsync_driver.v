///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number      : 3
// Full Name       : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

module vsync_driver (reset, clk, vsync, new_frame);

input reset, clk;
output reg vsync, new_frame;

reg [19:0] frame_counter;
reg [11:0] vsync_palm_counter;
reg [15:0] back_porch_counter;
reg [19:0] active_screen_counter;
reg back_porch_enable;
reg [8:0] first_time_counter;
reg first_time_flag;

//Manage vsync signal by controlling frame time period = 16.67 msec after next edge.
//Also hold vsync palm active for 64 usec with hsync_palm_counter.

always @(posedge clk or posedge reset) begin
	if (reset) begin
		// reset
		vsync = 1'b1;
		vsync_palm_counter = 12'd0;
		frame_counter = 20'd0;
		first_time_flag = 1'b1;
		first_time_counter = 9'd0;
	end
	//after exception of first time period. drive vsync to zero and start main process.
	else if ( first_time_counter == 9'd287 ) begin
		first_time_flag = 1'b0;
		vsync = 1'b0;					
		vsync_palm_counter = vsync_palm_counter + 1;
		frame_counter = 20'd0;
		first_time_counter = 9'd0;
	end
	//frame counter will be reset in next cycle so we need 833599 cycles in order to achive exactly 32 usec time period
	else if ( frame_counter == 20'd833599 ) begin 
		vsync = 1'b0;					
		vsync_palm_counter = vsync_palm_counter + 1;
		frame_counter = 20'd0;
	end
	else if ( vsync_palm_counter == 12'd3200 ) begin
		vsync = 1'b1;
		vsync_palm_counter = 12'd0;
		frame_counter = frame_counter + 1;
	end
	else if ( vsync == 1'b0 ) begin
		vsync_palm_counter = vsync_palm_counter + 1;
		frame_counter = frame_counter + 1;
	end
	//First-time-counter counts a specific time period after reset in order vsync frame time to be synchronized with scanline time.
	else if ( first_time_flag == 1'b1 ) begin
		frame_counter = frame_counter + 1;
		first_time_counter = first_time_counter + 1;
	end
	else begin
		frame_counter = frame_counter + 1;
	end
end

//In this always block we manage back portch duration before screen go active
//Back portch counter counts 928 usec back portch time

always @( posedge clk or posedge reset ) begin
	if (reset) begin
		// reset
		back_porch_counter = 16'd0;
		back_porch_enable = 1'b0;
	end
	else if ( back_porch_counter == 16'd46401 ) begin
		back_porch_counter = 0;
		back_porch_enable= 1'b0;
	end
	else if ( ( vsync == 1'b1 && back_porch_enable == 1'b1 )  ) begin
		back_porch_counter = back_porch_counter + 1;
		back_porch_enable = 1'b1;
	end

	else if ( back_porch_enable == 1'b1 ) begin
		back_porch_counter = back_porch_counter + 1;
	end
	else if ( vsync_palm_counter == 12'd3200 ) begin
		back_porch_enable = 1'b1;
	end
end

//In this always block we manipulate for how long the screen will retain in its active state.
//A signal new_frame indicates if screen is off or on.
//Max value of active screen counter indicates the start of the front_portch duration (time before next vsync_palm) 

always @(posedge clk or posedge reset) begin
	if (reset) begin
		// reset
		active_screen_counter = 20'd0;
		new_frame = 1'b0;	
	end
	else if ( active_screen_counter == 20'd767999 ) begin
		active_screen_counter = 20'd0;
		new_frame = 1'b0;
	end
	else if ( back_porch_counter == 16'd46401 ) begin
		new_frame = 1'b1;
	end
	else if ( new_frame == 1'b1 ) begin
		active_screen_counter = active_screen_counter + 1;
	end
end

endmodule