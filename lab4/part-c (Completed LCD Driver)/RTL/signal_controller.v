///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number      : 4
// Full Name       : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

module signal_controller (initialization_done, LCD_RS, lcd_e_init, lcd_e_tc, 
						  init_data, config_data, character_data, 
						  SF_D11,SF_D10,SF_D9,SF_D8,
						  LCD_RW, LCD_E);

input initialization_done, LCD_RS;
input lcd_e_init, lcd_e_tc;
input [3:0] init_data, config_data, character_data;

output SF_D11,SF_D10,SF_D9,SF_D8;
output LCD_RW;
output reg LCD_E;

wire [3:0] command_data;
wire [3:0] LCD_D;

//If system is running under the initialization process, consider lcd_e_init from initialization_fsm as LCD_E signal. 

always @(*) begin

	if ( initialization_done == 1'b1 ) begin
		LCD_E = lcd_e_tc;
	end
	else  begin
		LCD_E = lcd_e_init;
	end
	
end

//Because of the lack of need for reading operations, assign to LCD_RW value of 0.

assign LCD_RW = 1'b0;

//If system is running under the initialization process, consider init_data from initialization_fsm as the output data. 

assign command_data = ( initialization_done == 1'b1 ) ? config_data : init_data ;

//LCD_RS indicates whether commands or data are to be sent. When LCD_RS == 1, LCD Driver output data should be the data from BRAM. 

assign  LCD_D = ( LCD_RS == 1'b1 ) ? character_data : command_data ;

//Seperate 4-bit LCD Data to 1-bit values. 

assign SF_D11   = LCD_D[3];
assign SF_D10 	= LCD_D[2];
assign SF_D9 	= LCD_D[1];
assign SF_D8 	= LCD_D[0];

endmodule
