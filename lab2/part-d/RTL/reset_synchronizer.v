///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number      : 2
// Full Name       : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

module reset_synchronizer (reset, clk, reset_sync);


input reset, clk;
output reg reset_sync;
reg reset_1st_flipflop;

//Synchronize reset using two flip flops to avoid setup and hold violations.

always @(posedge clk)
begin
	reset_1st_flipflop = reset;
end

always @(posedge clk)
begin
	reset_sync = reset_1st_flipflop;
end

endmodule