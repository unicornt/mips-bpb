`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/28 21:03:11
// Design Name: 
// Module Name: floprnc
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


module flopenrc
#(parameter width = 1)
(
    input [width - 1 : 0] a,
    output logic [width - 1 : 0] b,
    input clk,
    input reset,
    input en,
    input clear
    );
    always@(posedge clk, posedge reset)
        if(reset) b <= 0;
        else if(clear) b <= 0;
        else if(en) b <= a;
endmodule
