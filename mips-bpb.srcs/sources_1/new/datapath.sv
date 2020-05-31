`timescale 1ns / 1ps
`include "bpb.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/09 14:53:44
// Design Name: 
// Module Name: datapath
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

//dp(clk, reset, instr, regrt, sext, wreg, aluimm, shift, alu,
                //branch,m2reg, jump, zero, readdata, writedata, pc);

module datapath #(
    parameter TAG_WIDTH = `BPB_T
)(
    input clk, reset,
    input [31:0]instrF,
    input regrtE, 
    input wregE, wregM, wregW,
    input aluimmE, shiftE, jrD,
    input [3:0]alucE,
    input branchD, sigextD, branchsrc,
    input m2regE, m2regM, m2regW,
    input jumpD, jalD, jalE,
    input [31:0]readdataM,
    output [31:0]writedataM, aluoutM,
    output [31:0]pcF,
    output flushE, same,
    output [31:0]instrD,
    input ihit
    );
    logic [4:0]ndW, ndE, ndM;
    logic [31:0]shamt, shaE, shaD, instrE;
    extsig #(5) essha(instrD[10:6], shamt);
    logic [31:0]q1D, q1E, q2D, q2E, d1W, alua, alua1, alub, alub1, extoutD, extoutE;
    logic [31:0]extaddrD, npcF, npcD, braddrD, pc1, jumpaddrD, nextpc, nextpc1, result;
    logic stallF, stallD, MemtoRegE, RegWriteM, RegWRiteW;
    logic [1:0]ForwardAE, ForwardBE;
    logic ForwardAD, ForwardBD;
    logic [31:0]aluoutE, aluoutW, readdataW, writedataE;
    logic [4:0]rsD, rtD, rsE, rtE;
    logic flushD, branchstallD, jrstallD;
    hazardunit haz(rsD, rtD, rsE, rtE, ndE, ndM,
                  ndW, wregE, wregM, wregW,
                  m2regE, m2regM, branchD, jrD,
                  ForwardAD, ForwardBD,
                  ForwardAE, ForwardBE,
                  stallF, stallD, flushE, branchstallD, jrstallD);
    
    logic predict_takenF, predict_takenD;
    logic [31:0] predict_adr;
    bpb bpb(clk, reset, stallD, flushD, pcF[TAG_WIDTH-1:0],
        (instrF[31:27] == 5'b00010), branchsrc, braddrD,
        predict_takenF, predict_adr
    );
    
    assign flushD = jumpD | (jrD & (~jrstallD)) | jalD | 
                    (~branchsrc & ~branchstallD & predict_takenD & stallD) |
                    (branchsrc & ~branchstallD & ~predict_takenD & stallD);
    mux muxjal(shamt, npcD, jalD, shaD);
    
    flopenr #(32) fppc(nextpc, pcF, clk, reset, stallF);
  //  flopenr fpdec(
    adder addnpc(pcF, 32'b100, npcF);
    
    flopenr #(32) fpnpc(npcF, npcD, clk, reset, stallD);
    flopenr #(32) fppred(predict_takenF, predict_takenD, clk, reset,stallD);
    flopenrc #(32) fpinstrFD(instrF, instrD, clk, reset, stallD, flushD);
    floprc #(32) fpinstrDE(instrD, instrE, clk, reset, flushE);
    assign rsD = instrD[25:21];
    assign rtD = jalD ? 5'b00000: instrD[20:16];
    regfile rf(wregW, rsD, rtD, ndW, d1W, clk, reset, q1D, q2D);
    logic [4:0]nde1;
    mux#(5) muxnde1(instrE[15:11], 5'b11111, jalE, nde1);
    mux#(5) muxnd(nde1, instrE[20:16], regrtE, ndE);
    extsig #(16) es(instrD[15:0], extoutD, sigextD);
    shiftleft2 sl2ext(extoutD, extaddrD);
    shiftleft2 sl2jump({6'b0, instrD[25:0]}, jumpaddrD);
    adder addbr(extaddrD, npcD, braddrD);
    logic [31:0]cmpa, cmpb;
    mux muxcmpa(q1D, aluoutM, ForwardAD, cmpa);
    mux muxcmpb(q2D, aluoutM, ForwardBD, cmpb);
    cmp cmpab(cmpa, cmpb, same);
    mux muxbr(npcF, braddrD, branchsrc & ~predict_takenD, pc1);
    mux muxjump(pc1, {npcD[31:28], jumpaddrD[27:0]}, jumpD, nextpc1);
    logic [31:0]nextpc2;
    logic [31:0]nextpc3;
    mux muxjr(nextpc1, cmpa, jrD, nextpc2);
    mux muxbp(nextpc2, predict_adr, predict_takenF, nextpc3);
    mux muxbpfail(nextpc3, npcD, ~branchsrc & predict_takenD & stallD, nextpc);
    
    floprc #(5) fprsDE(rsD, rsE, clk, reset, flushE);
    floprc #(5) fprtDE(rtD, rtE, clk, reset, flushE);
    floprc #(32) fpq1DE(q1D, q1E, clk, reset, flushE);
    floprc #(32) fpq2DE(q2D, q2E, clk, reset, flushE);
    floprc #(32) fpshaDE(shaD, shaE, clk, reset, flushE);
    floprc #(32) fpextDE(extoutD, extoutE, clk, reset, flushE);
    mux muxalua(alua1, shaE, shiftE, alua);
    mux2 muxaluaf(q1E, aluoutM, d1W, ForwardAE, alua1);
    mux muxalub(alub1, extoutE, aluimmE, alub);
    mux2 muxalubf(q2E, aluoutM, d1W, ForwardBE, alub1);
    alu alu(alua, alub, alucE, aluoutE);
    flopr #(5) fpndem(ndE, ndM, clk, reset);
    flopr #(5) fpndmw(ndM, ndW, clk, reset);
//    assign writedata = q2;
//    assign aluoutM = result;
    assign writedataE = alub1;
    flopr #(32) fpwritedataem(writedataE, writedataM, clk, reset);
    flopr #(32) fpaluoutmw(aluoutM, aluoutW, clk, reset);
    flopr #(32) fpreaddatamw(readdataM, readdataW, clk, reset);
    flopr #(32) fpalutem(aluoutE, aluoutM, clk, reset);
    mux muxd1(aluoutW, readdataW, m2regW, d1W);
endmodule