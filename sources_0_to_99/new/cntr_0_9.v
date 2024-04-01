`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2023 14:02:02
// Design Name: 
// Module Name: counter_0_9
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
module clk_fast(clk, rst, clk_out); //Function to divide the clock from 100MHz to 10KHz
    input clk, rst;
    output reg clk_out;
    integer cnt;
    always@(posedge clk or posedge rst)
    begin
        if(rst) cnt <=0;
        else if(cnt==10000)
        cnt<=0;
        else
        cnt<=cnt+1;
      end  
    always @ (posedge(clk) or posedge rst)
    begin
        if (rst) clk_out <= 0;
        else if(cnt<=5000)clk_out<=1'b1;
        else clk_out<=1'b0;
    end    
endmodule

module clk_slow(clk, rst, clk_out); //Function to divide the clock from 100MHz to 10Hz
    input clk, rst;
    output reg clk_out;
    integer cnt;
    always@(posedge clk or posedge rst)
    begin
        if(rst) cnt <=0;
        else if(cnt==10000000)
        cnt<=0;
        else
        cnt<=cnt+1;
      end  
    always @ (posedge(clk) or posedge rst)
    begin
        if (rst) clk_out <= 0;
        else if(cnt<=5000000)clk_out<=1'b1;
        else clk_out<=1'b0;
    end    
endmodule

module and_gate(x, y, f); //and gate module
    input x, y;
    output f;
    
    assign f = x & y;
endmodule 
module dff(clk, rst, D, Q); //D flip flop module
    input clk, rst, D;
    output reg Q;
    always @(posedge (clk) or posedge rst) begin
        if (rst) Q <= 1'b0;
        else Q <= D;
    end     
endmodule
module d_bounce(clk, rst, D, d_bnc); //de-bounce circuit 
    input clk, rst, D;
    output d_bnc;
    wire [2:0] Q;
    wire clk_div, l;
    
    clk_slow u1(clk, rst, clk_div);
    dff d1(clk_div, rst, D, Q[0]);
    dff d2(clk_div, rst, Q[0], Q[1]);
    dff d3(clk_div, rst, Q[1], Q[2]);
    
    and_gate and1(Q[0], Q[1], l);
    and_gate and2(Q[2], l, d_bnc);
             
endmodule

module cntr_0_9(clk, rst, bcd1, bcd2); //module to count from 0 to 9
    input clk, rst;
    output reg[3:0] bcd1, bcd2;
    reg r9;
    integer cntr1, cntr2;
    always @(posedge clk or posedge rst) begin //always block to control the first counter
        if(rst) begin 
                cntr1 <=0;
                r9<=0;
                end
        else if(cntr1==9) begin
                cntr1<=0;
                r9<=1;
                end
        else begin
        cntr1<=cntr1+1;
        r9<=0;
        end
    end
    always @(posedge rst or posedge r9) begin //always block to control the second counter
        if(rst)
        cntr2<=0;
        else if(r9==1 & cntr2!=9)begin
        cntr2<=cntr2+1;
        end
        else if(cntr2==9 & r9==1)begin
            cntr2<=0;
        end
    end
    always @(cntr1) begin //always block to translate decimal to BCD
        case(cntr1)
          1      : bcd1 = {4'b0001};
          2      : bcd1 = {4'b0010};
          3      : bcd1 = {4'b0011};
          4      : bcd1 = {4'b0100};
          5      : bcd1 = {4'b0101};
          6      : bcd1 = {4'b0110};
          7      : bcd1 = {4'b0111};
          8      : bcd1 = {4'b1000};
          9      : bcd1 = {4'b1001};
          default: bcd1 = {4'b0000};
       endcase
    end      
    always @(cntr2) begin 
        case(cntr2)
          1      : bcd2 = {4'b0001};
          2      : bcd2 = {4'b0010};
          3      : bcd2 = {4'b0011};
          4      : bcd2 = {4'b0100};
          5      : bcd2 = {4'b0101};
          6      : bcd2 = {4'b0110};
          7      : bcd2 = {4'b0111};
          8      : bcd2 = {4'b1000};
          9      : bcd2 = {4'b1001};
          default: bcd2 = {4'b0000};
       endcase
    end            
endmodule 
module bcd_to_7seg(bcd_in, Y); //module to display the corresponding LEDs in the 7 seg
    input [3:0] bcd_in;
    output reg [7:0] Y;
     always @(bcd_in) 
        case({bcd_in})
            4'b0001 : Y = {8'b01100000};
            4'b0010 : Y = {8'b11011010};
            4'b0011 : Y = {8'b11110010};
            4'b0100 : Y = {8'b01100110};
            4'b0101 : Y = {8'b10110110};
            4'b0110 : Y = {8'b10111110};
            4'b0111 : Y = {8'b11100000};
            4'b1000 : Y = {8'b11111110};
            4'b1001 : Y = {8'b11110110};
            4'b1010 : Y = {8'b11101110};
            4'b1011 : Y = {8'b00111110};
            4'b1100 : Y = {8'b10011100};
            4'b1101 : Y = {8'b01111010};
            4'b1110 : Y = {8'b10011110};
            4'b1111 : Y = {8'b10001110};
            default: Y = {8'b11111100};
        endcase
endmodule