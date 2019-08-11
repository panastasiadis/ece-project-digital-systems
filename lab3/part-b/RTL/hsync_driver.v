///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number      : 3
// Full Name       : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

module hsync_driver (reset, clk, hsync, new_line);

input reset, clk;
output reg hsync, new_line;

reg [10:0] scanline_counter;
reg [7:0] hsync_palm_counter;
reg [6:0] back_porch_counter;
reg [10:0] active_line_counter;
reg back_porch_enable;

//Manage hsync signal by controlling scanline time period = 32 usec after next edge.
//Also hold hsync palm active for 3.84 usec with hsync_palm_counter

always @(posedge clk or posedge reset) begin
	if (reset) begin
		// reset
		hsync = 1'b1;
		hsync_palm_counter = 8'd0;
		scanline_counter = 11'd0;
	end
	//scanline counter will be reset in next cycle so we need 1599 cycles in order to achive exactly 32 usec time period
	else if ( scanline_counter == 11'd1599 ) begin 
		hsync = 1'b0;					
		hsync_palm_counter = hsync_palm_counter + 1;
		scanline_counter = 11'd0;
	end
	else if ( hsync_palm_counter == 8'd192 ) begin
		hsync = 1'b1;
		hsync_palm_counter = 8'd0;
		scanline_counter = scanline_counter + 1;
	end
	else if ( hsync == 1'b0 ) begin
		hsync_palm_counter = hsync_palm_counter + 1;
		scanline_counter = scanline_counter + 1;
	end
	else begin
		scanline_counter = scanline_counter + 1;
	end
end

//In this always block we manage back portch duration before screen go active
//Back portch counter counts 1.92 usec back portch time

always @( posedge clk or posedge reset ) begin
	if (reset) begin
		// reset
		back_porch_counter = 7'd0;
		back_porch_enable = 1'b0;
	end
	else if ( back_porch_counter == 7'd97 ) begin
		back_porch_counter = 0;
		back_porch_enable= 1'b0;
	end
	else if ( ( hsync == 1'b1  && back_porch_enable == 1'b1 )  ) begin
		back_porch_counter = back_porch_counter + 1;
		back_porch_enable = 1'b1;
	end

	else if ( back_porch_enable == 1'b1 ) begin
		back_porch_counter = back_porch_counter + 1;
	end
	else if ( hsync_palm_counter == 8'd192 ) begin
		back_porch_enable = 1'b1;
	end
end

//In this always block we manipulate for how long the line will retain in its active state
//A signal new_line indicates if screen is off or on.
//Max value of active line counter indicates the start of the front_portch duration (time before next hsync_palm) 

always @(posedge clk or posedge reset) begin
	if (reset) begin
		// reset
		active_line_counter = 11'd0;
		new_line = 1'b0;	
	end
	else if ( active_line_counter == 11'd1279 ) begin
		active_line_counter = 11'd0;
		new_line = 1'b0;
	end
	else if ( back_porch_counter == 7'd97 ) begin
		new_line = 1'b1;
	end
	else if ( new_line == 1'b1 ) begin
		active_line_counter = active_line_counter + 1;
	end
end

endmodule