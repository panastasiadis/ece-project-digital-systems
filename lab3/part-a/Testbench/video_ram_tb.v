///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number      : 3
// Full Name       : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

`timescale 1ns/1000ps

module video_ram_tb ();

reg clk = 0;
reg rst = 1;
reg [6:0] i;
reg [6:0] j;
reg flag;

//Initialize cirquit at a random moment (after 74ns)

initial begin
	#74 rst=0;
end

//Fpga spartan 3 pixel clock frequency ==> 50 Mhz

always #10 clk <= ~clk;

//Test every pixel of 128x96 screen.

always @(posedge clk or posedge rst) begin
	if (rst) begin
		// reset
		i = 0;
		j = 0;
		flag = 1'b1;	
	end
	else if ( flag == 2'b1 ) begin
		flag = 1'b0;
	end
	else if (i == 7'd95 && j == 7'd127 ) begin
		i = 0;
		j = 0;
		$finish;
	end
	else if ( j == 7'd127 ) begin
		i = i + 1;
		j = 0;
	end
	else begin
		j = j + 1;
	end
end

//instantiate video ram to extract colours for every pixel

video_ram video_ram_0 (.reset(rst),.clk(clk), .ver_px(i), .hor_px(j), .red_value(red_value), .green_value(green_value), .blue_value(blue_value) );

endmodule