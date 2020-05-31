`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/15 14:20:15
// Design Name: 
// Module Name: maindec
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

//maindec md(op, zero, aluop, jump, m2reg, branch, wmem, shift, 
//aluimm, wreg, regrt, sext);

//addi，andi，ori，slti，sw，lw，beq，bne, 
//j，nop，jal

module maindec(
    input [5:0]op,
    input logic shamt,
    output logic [2:0]aluop,
    output logic jump, m2reg, branch, wmem, shift, aluimm, wreg, regrt, sigext
    );
    logic [11:0]control;
    assign {aluop, jump, m2reg, branch, wmem, shift, aluimm, wreg, regrt, sigext} = control;
    always@(*)
    begin
        case(op)
            6'b000000: control = {7'b0000000, shamt ,4'b0101};//R-type
            6'b001000: control = 12'b001000001111;//addi
            6'b001100: control = 12'b010000001110;//andi
            6'b001101: control = 12'b011000001110;//ori
            6'b001010: control = 12'b100000001111;//slti
            6'b101011: control = 12'b001000101011;//sw
            6'b100011: control = 12'b001010001111;//lw
            6'b000100: control = 12'b101001000011;//beq
            6'b000101: control = 12'b101001000011;//bnq
            6'b000010: control = 12'b000100000001;//j
            6'b000011: control = 12'b001100010101;//jal
            default: control = 12'bXXXXXXXXXXXX;
        endcase
    end
endmodule
