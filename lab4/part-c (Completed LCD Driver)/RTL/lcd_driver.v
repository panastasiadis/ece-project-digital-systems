///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number      : 4
// Full Name       : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

module lcd_driver( clk, rst, LCD_RS, LCD_RW, LCD_E, SF_D11, SF_D10, SF_D9, SF_D8 );

input clk, rst;
output LCD_RS, LCD_RW, LCD_E, SF_D11, SF_D10, SF_D9, SF_D8;

wire fsm_enable;
wire [3:0] init_data;
wire [3:0] config_data;
wire [3:0] character_data;

//Synchronize reset using two flip flops to avoid setup and hold violations.

reset_synchronizer reset_synchronizer_0 ( .reset( rst ), .clk( clk ), .reset_sync ( reset ));

//Instantiation of initialization_fsm. Module that handles LCD initialization process.

initialization_fsm initialization_fsm_0 ( .reset( reset ), .clk( clk ), .lcd_e_init( lcd_e_init ), 
										  .init_data( init_data ), .initialization_done( initialization_done ) );

//Instantiation of configuration_fsm. Module that handles LCD configuration Process and data tranfer.

configuration_fsm configuration_fsm_0 ( .reset( reset ), .clk( clk ), .initialization_done( initialization_done ), 
										.timing_control_enable( fsm_enable ), .send_upper( send_upper ), .send_lower( send_lower ), 
										.lcd_rs( LCD_RS ), .config_data( config_data ), .character_data ( character_data )  );

//Instantiation of time_control_fsm. Module that handles LCD timing restrictions between the commands or data that are to be sent serially.

time_control_fsm time_control_fsm_0 (.reset( reset ), .clk( clk ), .fsm_enable( fsm_enable ), .lcd_e_tc_fsm( lcd_e_tc ), .send_upper( send_upper ), .send_lower( send_lower ) );

//Signal controller manages output signals of the other modules and choose the correct values for LCD Driver main outputs.

signal_controller signal_controller_0 ( .initialization_done ( initialization_done ), .LCD_RS( LCD_RS ), 
									    .lcd_e_init( lcd_e_init ), .lcd_e_tc( lcd_e_tc ), 
									    .init_data( init_data ), .config_data( config_data ), .character_data( character_data ), 
									    .SF_D11( SF_D11 ), .SF_D10( SF_D10 ), .SF_D9( SF_D9 ), .SF_D8( SF_D8 ),
									    .LCD_RW( LCD_RW ), .LCD_E( LCD_E ) ); 

endmodule
