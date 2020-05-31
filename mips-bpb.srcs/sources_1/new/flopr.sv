`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/11 20:59:20
// Design Name: 
// Module Name: flopr
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


module flopr
#(parameter WIDTH = 32)
(
    input [WIDTH - 1:0]nextpc,
    output logic [WIDTH - 1:0]pc,
    input clk,
    input reset
    );
    always@(posedge clk, posedge reset)
        if(reset) pc <= 0;
        else pc <= nextpc;
endmodule
