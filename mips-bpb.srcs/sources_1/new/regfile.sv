`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/10 18:28:46
// Design Name: 
// Module Name: regfile
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


module regfile(
    input we,
    input [4:0]n1, n2, nd,
    input [31:0]d1,
    input clk, reset,
    output [31:0]q1, q2
    );
    logic [31:0]rf[31:0];
    always@(negedge clk, posedge reset)
        if(reset)
        begin
            for(int i = 0; i < 32; i++)
                rf[i] = 0;
        end
        else if(we) rf[nd] <= d1;
    assign q1 = (n1 != 0) ? rf[n1] : 0;
    assign q2 = (n2 != 0) ? rf[n2] : 0;
endmodule
