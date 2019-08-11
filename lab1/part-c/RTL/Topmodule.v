//////////////////////////////////////////////////
// University : Electrical & Computer Engineering
// Course     : CE430 - Digital Cirquits
// Lab number : 1st
// Full Name  : Panagiotis Anastasiadis        
// A.M.       : 2134
// Date       : 25/10/18
//////////////////////////////////////////////////

module Topmodule (reset, clk, old_click, an3, an2, an1, an0,
a, b, c, d, e, f, g, dp);

input clk, reset, old_click ;
output an3, an2, an1, an0;
output a, b, c, d, e, f, g, dp;

wire an3, an2, an1, an0;
wire a, b, c, d, e, f, g,dp;
wire [6:0] LED;
wire [1:0] enable;
wire [5:0]charToDecode;
wire [3:0] counter;
wire reset_sync;
wire click;

//Synchronize reset using two flip flops to avoid setup and hold violations.

reset_synchronizer reset_synchronizer_0 (reset,clk, reset_sync);

//Debouncer Module to control click button
Debouncer Debouncer_1 (reset_sync, clk, old_click, click); 


 DCM #(
      .SIM_MODE("SAFE"),  // Simulation: "SAFE" vs. "FAST", see "Synthesis and Simulation Design Guide" for details
      .CLKDV_DIVIDE(16.0), // Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
                          //   7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
      .CLKFX_DIVIDE(1),   // Can be any integer from 1 to 32
      .CLKFX_MULTIPLY(4), // Can be any integer from 2 to 32
      .CLKIN_DIVIDE_BY_2("FALSE"), // TRUE/FALSE to enable CLKIN divide by two feature
      .CLKIN_PERIOD(0.0),  // Specify period of input clock
      .CLKOUT_PHASE_SHIFT("NONE"), // Specify phase shift of NONE, FIXED or VARIABLE
      .CLK_FEEDBACK("1X"),  // Specify clock feedback of NONE, 1X or 2X
      .DESKEW_ADJUST("SYSTEM_SYNCHRONOUS"), // SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS or
                                            //   an integer from 0 to 15
      .DFS_FREQUENCY_MODE("LOW"),  // HIGH or LOW frequency mode for frequency synthesis
      .DLL_FREQUENCY_MODE("LOW"),  // HIGH or LOW frequency mode for DLL
      .DUTY_CYCLE_CORRECTION("TRUE"), // Duty cycle correction, TRUE or FALSE
      .FACTORY_JF(16'hC080),   // FACTORY JF values
      .PHASE_SHIFT(0),     // Amount of fixed phase shift from -255 to 255
      .STARTUP_WAIT("FALSE")   // Delay configuration DONE until DCM LOCK, TRUE/FALSE
   ) DCM_inst (
      .CLK0(CLK0),     // 0 degree DCM CLK output
     // .CLK180(CLK180), // 180 degree DCM CLK output
     // .CLK270(CLK270), // 270 degree DCM CLK output
     // .CLK2X(CLK2X),   // 2X DCM CLK output
     // .CLK2X180(CLK2X180), // 2X, 180 degree DCM CLK out
     // .CLK90(CLK90),   // 90 degree DCM CLK output
      .CLKDV(CLKDV),   // Divided DCM CLK out (CLKDV_DIVIDE)
     // .CLKFX(CLKFX),   // DCM CLK synthesis out (M/D)
     // .CLKFX180(CLKFX180), // 180 degree CLK synthesis out
     // .LOCKED(LOCKED), // DCM LOCK status output
     // .PSDONE(PSDONE), // Dynamic phase adjust done output
     // .STATUS(STATUS), // 8-bit DCM status bits output
      .CLKFB(CLK0),   // DCM clock feedback
      .CLKIN(clk),   // Clock input (from IBUFG, BUFG or DCM)
     // .PSCLK(PSCLK),   // Dynamic phase adjust clock input
     // .PSEN(PSEN),     // Dynamic phase adjust enable input
     // .PSINCDEC(PSINCDEC), // Dynamic phase adjust increment/decrement
      .RST(reset_sync)        // DCM asynchronous reset input
   );


/////////////////////////////Lab 1 Part C
//clickCounter needed for the one step-digit rotation 
//RotationalMessageClick module for providing the Driver and Decoder with message "FPgA spartan 3"

wire [3:0] clickCounter;
ClickCounter ClickCounter_0 (reset_sync , click, clickCounter);
RotationalMessageClick RotationalMessageClick_0 (reset_sync, CLKDV, click,an3, an2, an1, an0, clickCounter, charToDecode );
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//Instantiations of the LEDdecoder module and the FourBitCounter module.

LEDdecoder LEDdecoder_0 (charToDecode, LED);
FourBitCounter FourBitCounter_0 (CLKDV, reset_sync , counter, enable);


//Instantiate driver for signals AnX and a.b.c.d.e.f.g,dp of the 7-Segment Display.

FourDigitLEDdriver FourDigitLEDdriver_0 (reset_sync , CLKDV, LED, enable, counter, an3, an2, an1, an0, a, b, c, d, e, f, g, dp);

endmodule