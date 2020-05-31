`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/29 15:37:48
// Design Name: 
// Module Name: mux2
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


module mux2(
    input [31:0]a, b, c,
    input [1:0]d,
    output logic [31:0]e
    );
    always@(*)
    begin
        case(d)
            2'b00: e <= a;
            2'b01: e <= b;
            2'b10: e <= c;
        endcase
    end
endmodule
