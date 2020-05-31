`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/03 19:29:36
// Design Name: 
// Module Name: mux3
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


module mux3(
    input [31:0]a, b, c, d,
    input [1:0]e,
    output logic [31:0]f
    );
    always@(*)
    begin
        case(e)
            2'b00: f <= a;
            2'b01: f <= b;
            2'b10: f <= c;
            2'b11: f <= d;
        endcase
    end
endmodule
