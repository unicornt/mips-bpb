`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2020 09:01:31 PM
// Design Name: 
// Module Name: dmem
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

//dmem dmem(.clk(clk), .we(mem_write), .a(cpu_data_addr), .wd(write_data), .rd(read_data));

module dmem(
    input clk, we,
    input [31:0]a, wd,
    output logic [31:0]rd
    );
    logic[31:0]RAM[127:0];
    always@(posedge clk)
        if(we == 1) RAM[a[31:2]] <= wd;
    assign rd = RAM[a[31:2]];
endmodule
