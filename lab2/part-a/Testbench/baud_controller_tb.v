///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number 	   : 2
// Full Name  	   : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

module baud_controller_tb ();

reg clk = 0;
reg rst = 1;
reg [2:0] baud_select = 3'b000;

//Initialize module
//Set baud select to new value for baud_controller_0 after 450000ns,
//in order to test the functionality of the ciruit after the change.

initial begin
	#74 rst=0;
	#20000 baud_select = 3'b111;
	#450000 baud_select = 3'b001;
end

//Fpga spartan 3 clock frequency ==> 50 Mhz

always #10 clk <= ~clk;

wire sample_enable;

//Instantiate baud controller with all the possible values for baud select

baud_controller baud_controller_0(rst, clk , baud_select, sample_enable );
baud_controller baud_controller_1(rst, clk , 3'b001, sample_enable1);
baud_controller baud_controller_2(rst, clk , 3'b010, sample_enable2);
baud_controller baud_controller_3(rst, clk , 3'b011, sample_enable3);
baud_controller baud_controller_4(rst, clk , 3'b100, sample_enable4);
baud_controller baud_controller_5(rst, clk , 3'b101, sample_enable5);
baud_controller baud_controller_6(rst, clk , 3'b110, sample_enable6);
baud_controller baud_controller_7(rst, clk , 3'b111, sample_enable7);

endmodule

