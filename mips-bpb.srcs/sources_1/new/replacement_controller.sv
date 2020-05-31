`include "cache.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/05 11:11:34
// Design Name: 
// Module Name: replacement_controller
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


module replacement_controller #(
	parameter TAG_WIDTH    = `CACHE_T,
		      OFFSET_WIDTH = `CACHE_B,
		      LINES        = `CACHE_E
)(
    input reset, strategy_en,
    input [31:0]addr,
    input [TAG_WIDTH * LINES - 1 : 0] Tag,
    input [TAG_WIDTH * LINES - 1 : 0] Dirty,
    input [TAG_WIDTH * LINES - 1 : 0] Valid, 
    output logic line_index, hit
    );
    
endmodule
