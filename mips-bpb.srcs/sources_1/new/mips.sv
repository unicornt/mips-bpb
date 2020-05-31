`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2020 09:01:31 PM
// Design Name: 
// Module Name: mips
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

//mips mips(.clk(cpu_clk), .reset(reset), .pc(pc), .instr(instr), 
//.memwrite(cpu_mem_write), .aluout(cpu_data_addr), .writedata(write_data),
// .readdata(read_data));


module mips(
    input clk, reset,
    output [31:0]pc,
    input [31:0]instr,
    output memwrite,
    output [31:0]aluout, writedata,
    input [31:0] readdata,
    input ihit, dhit,
    output logic dcen
    );
    logic jumpD, m2regE, m2regM, m2regW, branchD, shiftE, aluimmE, wregE, wregM, wregW, regrtE;
    logic [3:0]alucE;
    logic [31:0]instrD;
    logic jalD, jalE, jrD, flushE, flushD, same, branchsrc, sigextD, dcenw, wmem;
    controller ct(instrD[31:26], instrD[5:0], same, jumpD, m2regE, m2regM, m2regW, branchD, branchsrc, memwrite,
                    alucE, shiftE, aluimmE, wregE, wregM, wregW, regrtE, jalD, jalE, jrD, sigextD, flushE, reset, clk, dcen);
    
    datapath dp(clk, reset, instr, regrtE, wregE, wregM, wregW, aluimmE, shiftE, jrD, alucE,
                branchD, sigextD, branchsrc, m2regE, m2regM, m2regW, jumpD, jalD, jalE, readdata, writedata, aluout, pc, flushE, same, instrD, ihit);
endmodule
