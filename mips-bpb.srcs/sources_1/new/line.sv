`include "cache.vh"
/**
 * w_en: write enable
 */
module line #(
	parameter TAG_WIDTH    = `CACHE_T,
		      OFFSET_WIDTH = `CACHE_B
)(
	input                        clk, reset,
	input  [OFFSET_WIDTH - 3:0]  offset,
	input                        w_en, set_valid, set_dirty,
	input  [TAG_WIDTH - 1:0]     set_tag,
	input  [31:0]                write_data,
	output  logic                  valid,
	output  logic                  dirty,
	output  logic  [TAG_WIDTH - 1:0] tag,
	output  [31:0]            read_data
);
    logic [31:0]R[0:2 ** (OFFSET_WIDTH - 2) - 1];
    always@(posedge clk, reset)
    begin
        if(reset)
        begin
            for(int i = 0; i < 2 ** (OFFSET_WIDTH - 2); i++) R[i] <= 32'b0;
            {valid, dirty, tag} <= 3'b0;
        end
        else if(w_en == 1)
        begin
            //$display("%d <= %X", offset, write_data);
            {valid, dirty, tag, R[offset]} <= {set_valid, set_dirty, set_tag, write_data};
        end
    end
    assign read_data = R[offset];
endmodule
