`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/28 15:20:37
// Design Name: 
// Module Name: hazardunit
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


module hazardunit(
    input [4:0] rsD, rtD, rsE, rtE,
    input [4:0] writeregE, writeregM, writeregW,
    input wregE, wregM, wregW,
    input m2regE, m2regM, branchD, jrD,
    output ForwardAD, ForwardBD,
    output logic [1:0]ForwardAE, ForwardBE,
    output stallF, stallD, flushE, branchstallD, jrstallD
    );
    assign ForwardAD = (rsD != 0 & rsD == writeregM & wregM != 0);
    assign ForwardBD = (rtD != 0 & rtD == writeregM & wregM != 0);
    always@(*)
    begin
        ForwardAE = 2'b00;
        ForwardBE = 2'b00;
        if(rsE != 0)
        begin
            if(rsE == writeregM && wregM != 0) ForwardAE = 2'b01;
            else if(rsE == writeregW && wregW != 0) ForwardAE = 2'b10;
        end
        if(rtE != 0)
        begin
            if(rtE == writeregM && wregM != 0) ForwardBE = 2'b01;
            else if(rtE == writeregW && wregW != 0) ForwardBE = 2'b10;
        end
    end
    logic lwstallD;
    assign lwstallD = m2regE & (rtE == rsD | rtE == rtD);
    assign branchstallD = branchD &
                        ((wregE & (writeregE == rsD | writeregE == rtD)) | 
                         (m2regM & (writeregM == rsD | writeregM == rtD)));
    assign jrstallD = jrD & ((wregE & writeregE == rsD) | (m2regM & writeregM == rsD));
    assign stallD = ~(lwstallD | jrstallD | branchstallD);
    assign stallF = stallD;
    assign flushE = ~stallD;
endmodule