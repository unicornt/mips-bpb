`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/09 14:53:44
// Design Name: 
// Module Name: controller
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

//controller ct(instr[31:26], instr[5:0], zero, jump, m2reg, branch, wmem,
//                    alu, shift, aluimm, wreg, regrt, sext);
module controller(
    input [5:0]opD, funcD,
    input same,
    output jumpD, m2regE, m2regM, m2regW, branchD, branchsrc, wmemM,
    output [3:0]alucE,
    output logic shiftE, aluimmE, wregE, wregM, wregW, regrtE, jalD, jalE, jrD, sigextD,
    input flushE, reset, clk,
    output dcen
    );
    logic [2:0]aluopD;
    logic shamtD, m2regD, wmemD, shiftD, aluimmD, wregD, regrtD, branchD1;
    logic [3:0]alucD;
    logic wmemE;
    assign jrD = (opD == 6'b000000 && funcD == 6'b001000) ? 1 : 0;
    assign jalD = (opD == 6'b000011) ? 1 : 0;
    assign shamtD = (opD == 6'b000000 && funcD[5:2] == 4'b0000) ? 1 : 0;
    assign branchsrc = branchD & (opD == 6'b000100 ? same: ~same);
    maindec md(opD, shamtD, aluopD, jumpD, m2regD, branchD, wmemD, shiftD, aluimmD, wregD, regrtD, sigextD);
    aludec ad(funcD, aluopD, alucD);
    floprc #(11) fpDE({wregD, m2regD, wmemD, alucD, aluimmD, regrtD, jalD, shiftD},
                      {wregE, m2regE, wmemE, alucE, aluimmE, regrtE, jalE, shiftE},
                      clk, reset, flushE);
    flopr #(3) fpEM({wregE, m2regE, wmemE},
                    {wregM, m2regM, wmemM},
                    clk, reset);
    flopr #(2) fpMW({wregM, m2regM}, {wregW, m2regW}, clk, reset);
    assign dcen = m2regM | wmemM;
endmodule
