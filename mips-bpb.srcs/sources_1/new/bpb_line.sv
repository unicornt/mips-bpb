`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/27 16:55:13
// Design Name: 
// Module Name: bpb_line
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


module bpb_line
#(
    parameter TAG_WIDTH = `BPB_T
)(
    input clk, reset, wen,
    input [32 + TAG_WIDTH : 0] A,
    output logic [32 + TAG_WIDTH: 0]B
);
    parameter strong_yes = 2'b11, weak_yes = 2'b10, weak_no = 2'b01, strong_no = 2'b00;
    logic predict, reall;
    logic [1:0]state;
    assign predict = B[32 + TAG_WIDTH];
    assign reall = A[32 + TAG_WIDTH];
    always@(posedge clk, reset)
    begin
        if(reset)
        begin
            B <= {33'b0, `BPB_T'b0};
            state <= weak_no;
        end
        else if(wen)
        begin
            $display("%x %x %x", A[TAG_WIDTH - 1 : 0], A[32+TAG_WIDTH], A[31 +TAG_WIDTH: TAG_WIDTH]);
            B[31 + TAG_WIDTH:0] <= A[31 + TAG_WIDTH:0];
            if(predict == reall) state <= (reall == 0 ? strong_no : strong_yes);
            else
            begin
                case(state)
                    strong_yes: state <= weak_yes;
                    weak_yes: state <= weak_no;
                    weak_no: state <= weak_yes;
                    strong_no: state <= weak_no;
                endcase
            end
            B[32 + TAG_WIDTH] <= state[1];
        end
    end
endmodule
