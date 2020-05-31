`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/10 18:28:46
// Design Name: 
// Module Name: extsig
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


module extsig
#(parameter WIDTH = 16)
(
    input logic [WIDTH - 1:0]a,
    output logic [31:0]c,
    input d
    );
    assign c = d ? {{(32 - WIDTH){a[WIDTH - 1]}}, a} : {{(32-WIDTH){1'b0}}, a};
endmodule
