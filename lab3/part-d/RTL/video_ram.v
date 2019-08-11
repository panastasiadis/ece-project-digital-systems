///////////////////////////////////////////////////////
// University      : University of Thessaly
// Department      : Electrical & Computer Engineering
// Course          : CE430 - Digital Cirquits
// Lab number      : 3
// Full Name       : Panagiotis Anastasiadis        
// Registry Number : 2134
///////////////////////////////////////////////////////

module video_ram (reset, clk, ver_px, hor_px, red_value, green_value, blue_value);

input reset;
input clk;
input [6:0] ver_px;
input [6:0] hor_px;

output red_value;
output green_value;
output blue_value;

//width of screen 128x96

parameter videoRamWidth  = 14'd128;

wire [13:0]index; 
wire red_value;
wire green_value;
wire blue_value;

//convert index of 2-D array to index of 1-D array 

assign index = ( ver_px * videoRamWidth ) + hor_px;

//Block Ram for red color values

RAMB16_S1 #(
.INIT(1'b0),  // Value of output RAM registers at startup
.SRVAL(1'b0), // Output value upon SSR assertion
.WRITE_MODE("WRITE_FIRST"), // WRITE_FIRST, READ_FIRST or NO_CHANGE

// The forllowing INIT_xx declarations specify the initial contents of the RAM
// Address 0 to 4095
.INIT_00(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_01(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_02(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_03(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_04(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_05(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_06(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_07(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_08(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_09(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_0A(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_0B(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_0C(256'h00000000000000000000000000000000ffffffffffffffffffffffffffffffff), //middle of OC --end of red & white part
.INIT_0D(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_0E(256'hffffffffffffffffffffffffffffffff00000000000000000000000000000000),
.INIT_0F(256'h00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
// Address 4096 to 8191
.INIT_10(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_11(256'hffffffffffffffffffffffffffffffff00000000000000000000000000000000),
.INIT_12(256'h00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
.INIT_13(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_14(256'hffffffffffffffffffffffffffffffff00000000000000000000000000000000),
.INIT_15(256'h00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
.INIT_16(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_17(256'hffffffffffffffffffffffffffffffff00000000000000000000000000000000),
.INIT_18(256'h00000000000000000000000000000000ffffffffffffffffffffffffffffffff), //middle of 18 --end of green & white part
.INIT_19(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_1A(256'hffffffffffffffffffffffffffffffff00000000000000000000000000000000),
.INIT_1B(256'h00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
.INIT_1C(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_1D(256'hffffffffffffffffffffffffffffffff00000000000000000000000000000000),
.INIT_1E(256'h00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
.INIT_1F(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
// Address 8192 to 12287
.INIT_20(256'hffffffffffffffffffffffffffffffff00000000000000000000000000000000),
.INIT_21(256'h00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
.INIT_22(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_23(256'hffffffffffffffffffffffffffffffff00000000000000000000000000000000),

.INIT_24(256'h0180c06030180c0606030180c0603018ffffffffffffffffffffffffffffffff), //middle of 24 -- end of blue & white part
.INIT_25(256'he1f0f87c3e1f0f8787c3e1f0f87c3e1fe1f0f87c3e1f0f8787c3e1f0f87c3e1f), //ww
.INIT_26(256'he1f0f87c3e1f0f8787c3e1f0f87c3e1f0180c06030180c0606030180c0603018), //bw
.INIT_27(256'h0180c06030180c0606030180c0603018e1f0f87c3e1f0f8787c3e1f0f87c3e1f), //wb
.INIT_28(256'he1f0f87c3e1f0f8787c3e1f0f87c3e1fe1f0f87c3e1f0f8787c3e1f0f87c3e1f), //ww
.INIT_29(256'he1f0f87c3e1f0f8787c3e1f0f87c3e1f0180c06030180c0606030180c0603018), //bw
.INIT_2A(256'h0180c06030180c0606030180c0603018e1f0f87c3e1f0f8787c3e1f0f87c3e1f), //wb
.INIT_2B(256'he1f0f87c3e1f0f8787c3e1f0f87c3e1fe1f0f87c3e1f0f8787c3e1f0f87c3e1f), //ww
.INIT_2C(256'he1f0f87c3e1f0f8787c3e1f0f87c3e1f0180c06030180c0606030180c0603018), //bw
.INIT_2D(256'h0180c06030180c0606030180c0603018e1f0f87c3e1f0f8787c3e1f0f87c3e1f), //wb
.INIT_2E(256'he1f0f87c3e1f0f8787c3e1f0f87c3e1fe1f0f87c3e1f0f8787c3e1f0f87c3e1f), //ww
.INIT_2F(256'hffffffffffffffffffffffffffffffff0180c06030180c0606030180c0603018), //bff //init 2f -- end of colourful part
// Address 12288 to 16383
.INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000)
) RAMB16_S1_red (
.DO(red_value),      // 1-bit Data Output
.ADDR(index),        // 14-bit Address Input
.CLK(clk),           // Clock
.DI(1'b0),           // 1-bit Data Input
.EN(1'b1),           // RAM Enable Input
.SSR(reset),         // Synchronous Set/Reset Input
.WE(1'b0)            // Write Enable Input
);

//Block Ram for green color values

RAMB16_S1 #(
.INIT(1'b0),  // Value of output RAM registers at startup
.SRVAL(1'b0), // Output value upon SSR assertion
.WRITE_MODE("WRITE_FIRST"), // WRITE_FIRST, READ_FIRST or NO_CHANGE

// The forllowing INIT_xx declarations specify the initial contents of the RAM
// Address 0 to 4095
.INIT_00(256'h00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
.INIT_01(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_02(256'hffffffffffffffffffffffffffffffff00000000000000000000000000000000),
.INIT_03(256'h00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
.INIT_04(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_05(256'hffffffffffffffffffffffffffffffff00000000000000000000000000000000),
.INIT_06(256'h00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
.INIT_07(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_08(256'hffffffffffffffffffffffffffffffff00000000000000000000000000000000),
.INIT_09(256'h00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
.INIT_0A(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_0B(256'hffffffffffffffffffffffffffffffff00000000000000000000000000000000),
.INIT_0C(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff), //middle of OC --end of red & white part
.INIT_0D(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_0E(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_0F(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
// Address 4096 to 8191
.INIT_10(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_11(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_12(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_13(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_14(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_15(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_16(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_17(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_18(256'h00000000000000000000000000000000ffffffffffffffffffffffffffffffff), //middle of 18 --end of green & white part
.INIT_19(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_1A(256'hffffffffffffffffffffffffffffffff00000000000000000000000000000000),
.INIT_1B(256'h00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
.INIT_1C(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_1D(256'hffffffffffffffffffffffffffffffff00000000000000000000000000000000),
.INIT_1E(256'h00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
.INIT_1F(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
// Address 8192 to 12287
.INIT_20(256'hffffffffffffffffffffffffffffffff00000000000000000000000000000000),
.INIT_21(256'h00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
.INIT_22(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_23(256'hffffffffffffffffffffffffffffffff00000000000000000000000000000000),
.INIT_24(256'h06030180c0603018180c06030180c060ffffffffffffffffffffffffffffffff), //middle of 24 -- end of blue & white part
.INIT_25(256'he673399cce67339999cce673399cce67e673399cce67339999cce673399cce67),
.INIT_26(256'he673399cce67339999cce673399cce6706030180c0603018180c06030180c060),
.INIT_27(256'h06030180c0603018180c06030180c060e673399cce67339999cce673399cce67),
.INIT_28(256'he673399cce67339999cce673399cce67e673399cce67339999cce673399cce67),
.INIT_29(256'he673399cce67339999cce673399cce6706030180c0603018180c06030180c060),
.INIT_2A(256'h06030180c0603018180c06030180c060e673399cce67339999cce673399cce67),
.INIT_2B(256'he673399cce67339999cce673399cce67e673399cce67339999cce673399cce67),
.INIT_2C(256'he673399cce67339999cce673399cce6706030180c0603018180c06030180c060),
.INIT_2D(256'h06030180c0603018180c06030180c060e673399cce67339999cce673399cce67),
.INIT_2E(256'he673399cce67339999cce673399cce67e673399cce67339999cce673399cce67),
.INIT_2F(256'hffffffffffffffffffffffffffffffff06030180c0603018180c06030180c060), //init 2f -- end of colourful part
// Address 12288 to 16383
.INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000)
) RAMB16_S1_green (
.DO(green_value),      // 1-bit Data Output
.ADDR(index),  // 14-bit Address Input
.CLK(clk),    // Clock
.DI(1'b0),      // 1-bit Data Input
.EN(1'b1),      // RAM Enable Input
.SSR(reset),    // Synchronous Set/Reset Input
.WE(1'b0)       // Write Enable Input
);

//Block Ram for blue color values

RAMB16_S1 #(
.INIT(1'b0),  // Value of output RAM registers at startup
.SRVAL(1'b0), // Output value upon SSR assertion
.WRITE_MODE("WRITE_FIRST"), // WRITE_FIRST, READ_FIRST or NO_CHANGE

// The forllowing INIT_xx declarations specify the initial contents of the RAM
// Address 0 to 4095
.INIT_00(256'h00000000000000000000000000000000ffffffffffffffffffffffffffffffff), 
.INIT_01(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff), 
.INIT_02(256'hffffffffffffffffffffffffffffffff00000000000000000000000000000000), 
.INIT_03(256'h00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
.INIT_04(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_05(256'hffffffffffffffffffffffffffffffff00000000000000000000000000000000),
.INIT_06(256'h00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
.INIT_07(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_08(256'hffffffffffffffffffffffffffffffff00000000000000000000000000000000),
.INIT_09(256'h00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
.INIT_0A(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_0B(256'hffffffffffffffffffffffffffffffff00000000000000000000000000000000),
.INIT_0C(256'h00000000000000000000000000000000ffffffffffffffffffffffffffffffff), //middle of OC end of red & white part
.INIT_0D(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_0E(256'hffffffffffffffffffffffffffffffff00000000000000000000000000000000),
.INIT_0F(256'h00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
// Address 4096 to 8191
.INIT_10(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_11(256'hffffffffffffffffffffffffffffffff00000000000000000000000000000000),
.INIT_12(256'h00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
.INIT_13(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_14(256'hffffffffffffffffffffffffffffffff00000000000000000000000000000000),
.INIT_15(256'h00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
.INIT_16(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_17(256'hffffffffffffffffffffffffffffffff00000000000000000000000000000000),
.INIT_18(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff), //middle of 18 --end of green & white part
.INIT_19(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_1A(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_1B(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_1C(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_1D(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_1E(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_1F(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
// Address 8192 to 12287
.INIT_20(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_21(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_22(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_23(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
.INIT_24(256'h180c06030180c0606030180c06030180ffffffffffffffffffffffffffffffff), //ffb //middle of 24 -- end of blue & white part
.INIT_25(256'hf87c3e1f0f87c3e1e1f0f87c3e1f0f87f87c3e1f0f87c3e1e1f0f87c3e1f0f87), //ww
.INIT_26(256'hf87c3e1f0f87c3e1e1f0f87c3e1f0f87180c06030180c0606030180c06030180), //bw
.INIT_27(256'h180c06030180c0606030180c06030180f87c3e1f0f87c3e1e1f0f87c3e1f0f87), //wb
.INIT_28(256'hf87c3e1f0f87c3e1e1f0f87c3e1f0f87f87c3e1f0f87c3e1e1f0f87c3e1f0f87), //ww
.INIT_29(256'hf87c3e1f0f87c3e1e1f0f87c3e1f0f87180c06030180c0606030180c06030180), //bw
.INIT_2A(256'h180c06030180c0606030180c06030180f87c3e1f0f87c3e1e1f0f87c3e1f0f87), //wb
.INIT_2B(256'hf87c3e1f0f87c3e1e1f0f87c3e1f0f87f87c3e1f0f87c3e1e1f0f87c3e1f0f87), //ww
.INIT_2C(256'hf87c3e1f0f87c3e1e1f0f87c3e1f0f87180c06030180c0606030180c06030180), //bw
.INIT_2D(256'h180c06030180c0606030180c06030180f87c3e1f0f87c3e1e1f0f87c3e1f0f87), //wb
.INIT_2E(256'hf87c3e1f0f87c3e1e1f0f87c3e1f0f87f87c3e1f0f87c3e1e1f0f87c3e1f0f87), //ww
.INIT_2F(256'hffffffffffffffffffffffffffffffff180c06030180c0606030180c06030180), //bff //init 2f -- end of colourful part
// Address 12288 to 16383
.INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000)
) RAMB16_S1_blue (
.DO(blue_value),      // 1-bit Data Output
.ADDR(index),        // 14-bit Address Input
.CLK(clk),    // Clock
.DI(1'b0),      // 1-bit Data Input
.EN(1'b1),      // RAM Enable Input
.SSR(reset),    // Synchronous Set/Reset Input
.WE(1'b0)       // Write Enable Input
);

endmodule