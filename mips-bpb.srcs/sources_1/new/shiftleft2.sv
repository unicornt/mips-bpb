`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/10 18:28:46
// Design Name: 
// Module Name: shiftleft2
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


module shiftleft2(
    input [31:0]a,
    output [31:0]b
    );
    assign b = {a[29:0], 2'b00};
endmodule
