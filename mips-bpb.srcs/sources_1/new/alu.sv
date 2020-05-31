`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/10 18:28:46
// Design Name: 
// Module Name: alu
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

module alu(
    input [31:0]a, b,
    input [3:0]c,
    output logic [31:0]result
    );
    always@(*)
    begin
        case(c)
            4'b0000: result <= a + b;
            4'b0001: result <= a - b;
            4'b0010: result <= a & b;
            4'b0011: result <= a | b;
            4'b0100: 
            begin
                if(a[31] == b[31]) result <= (a < b) ? 1 : 0;
                else result <= (a[31] < b[31]) ? 0 : 1;
            end
            4'b0101: result <= b << a;
            4'b0110: result <= b >> a;
            4'b0111: 
            begin
                result <= b >> a;
                if(a && b[31] == 1)
                begin
                    result <= result | (((1<<a) - 1) << (31-a));
                end
            end
            default result <= 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
        endcase
    end
endmodule
