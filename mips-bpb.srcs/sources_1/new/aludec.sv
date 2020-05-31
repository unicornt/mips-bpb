`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/15 14:21:00
// Design Name: 
// Module Name: aludec
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

//add，sub，and，or，slt, jr, sll, srl, sra

module aludec(
    input [5:0]func,
    input [2:0]aluop,
    output logic [3:0]alu
    );
    always@(*)
    begin
        case(aluop)
            3'b001: alu = 4'b0000;//add
            3'b101: alu = 4'b0001;//sub
            3'b010: alu = 4'b0010;//and
            3'b011: alu = 4'b0011;//or
            3'b100: alu = 4'b0100;//slt
            3'b000://R-type
                case(func)
                    6'b100000:alu = 4'b0000;//add
                    6'b100010:alu = 4'b0001;//sub
                    6'b100100:alu = 4'b0010;//and
                    6'b100101:alu = 4'b0011;//or
                    6'b101010:alu = 4'b0100;//slt
                    6'b001000:alu = 4'b0000;//jr
                    6'b000000:alu = 4'b0101;//sll
                    6'b000010:alu = 4'b0110;//srl
                    6'b000011:alu = 4'b0111;//sra
                    default: alu = 4'bxxxx;
                endcase
        endcase
    end
endmodule
