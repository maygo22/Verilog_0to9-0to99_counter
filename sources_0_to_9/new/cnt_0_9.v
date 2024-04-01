`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/22/2023 06:48:59 PM
// Design Name: 
// Module Name: lab5_cnt_0_9
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module lab5_cnt_0_9(clk, rst, B, Y, scan);
    input clk, rst, B;
    output [7:0] Y;
    output reg [3:0] scan = 4'b0001;
    wire clk_fast_out, clk_slow_out, d_bnc;
    wire [3:0] bcd;

     clk_fast(clk,rst,clk_fast_out); //call clk 10KHz function 
     clk_slow(clk,rst,clk_slow_out); //call clk 10Hz function
     d_bounce(clk, rst, B, d_bnc); //call function to de-bounce  
     cntr_0_9(clk_slow_out, rst, d_bnc, bcd); //function to count from 0 to 9
     bcd_to_7seg(bcd, Y); //Function to display the BCD to the 7 seg. 
endmodule
