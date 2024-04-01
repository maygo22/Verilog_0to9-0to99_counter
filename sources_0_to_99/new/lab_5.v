`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.11.2023 15:11:31
// Design Name: 
// Module Name: lab_5
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
module lab5_cnt_0_9(clk, rst, Y, scan);
    input clk, rst;
    output [7:0] Y;
    output reg [3:0] scan;
    wire clk_fast_out, clk_slow_out;
    wire [3:0] bcd1, bcd2;
    reg x;
    reg [3:0] bcd_out;

     clk_fast(clk,rst,clk_fast_out); //call clk 10KHz function 
     clk_slow(clk,rst,clk_slow_out); //call clk 10Hz function

     cntr_0_9(clk_slow_out, rst, bcd1, bcd2); //function to count from 0 to 9

     always @(posedge clk_fast_out or posedge rst)begin //always block to decide the y seg to be used and which bcd to show 
        if (rst)x<=0;
        else x<=~x;
     end
     always @(posedge clk_fast_out)begin
        if(x)begin
            bcd_out <= bcd1;
            scan <= 4'b0001;
        end
        else begin
            bcd_out <= bcd2;
            scan <= 4'b0010;
            end
     end
     bcd_to_7seg(bcd_out, Y); //Function to display the BCD to the 7 seg. 
endmodule
