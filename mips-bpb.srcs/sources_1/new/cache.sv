`include "cache.vh"

/**
 * NOTE: The sum of TAG_WIDTH, SET_WIDTH and OFFSET_WIDTH should be 32
 *
 * TAG_WIDTH    : (t) tag bits
 * SET_WIDTH    : (s) set index bits, the number of sets is 2**SET_WIDTH
 * OFFSET_WIDTH : (b) block offset bits
 * LINES        : number of lines per set
 *
 * stall        : inorder to synchronize instruction memroy cache and data memroy cache, you may need this so that two caches will write data at most once per instruction respectively.
 *
 * input_ready  : whether input data from processor are ready
 * addr         : cache read/write address from processor
 * write_data   : cache write data from processor
 * w_en         : cache write enable
 * hit          : whether cache hits
 * read_data    : data read from cache
 *
 * maddr        : memory address 
 * mwrite_data  : data written to memory
 * m_wen        : memory write enable
 * mread_data   : data read from memory
 */
module cache #(
	parameter TAG_WIDTH    = `CACHE_T,
		      SET_WIDTH    = `CACHE_S,
		      OFFSET_WIDTH = `CACHE_B,
		      LINES        = `CACHE_E
)(
	input         clk, reset, stall,

	// interface with CPU
	input input_ready,
	input [31:0]  addr, write_data,
	input         w_en,
	output        hit,
	output [31:0] read_data,

	// interface with memory
	output [31:0] maddr, mwrite_data,
	output        m_wen,
	input [31:0]  mread_data
	/* input         mready // memory ready ? */
);
    logic lw_en, set_valid, set_dirty, strategy_en, strategy_en_cc, offset_sel, change_line_index;
    logic [SET_WIDTH - 1 : 0]set_index;
    logic [OFFSET_WIDTH - 3:0] block_offset;
    logic [2 ** SET_WIDTH - 1:0]Hit, Dirty;
    logic [TAG_WIDTH - 1 : 0]Tag[0: 2 ** SET_WIDTH - 1];
    logic [31:0]Read_data[0: 2 ** SET_WIDTH - 1];
    cache_controller cc(clk, reset | (~input_ready), ~stall , addr[OFFSET_WIDTH - 1  : 2], 
                        w_en, Hit[set_index], Dirty[set_index], lw_en, set_valid, set_dirty,
                        m_wen, block_offset, strategy_en_cc, offset_sel, change_line_index, hit);
    assign strategy_en = strategy_en_cc & input_ready & ~Hit[set_index];
    assign set_index = addr[31 - TAG_WIDTH : 31 - TAG_WIDTH - SET_WIDTH + 1];
    generate
        genvar i;
        for(i = 0; i < 2 ** SET_WIDTH; i++)
        begin
            set i_set(clk & (i == set_index) & input_ready, input_ready & (i == set_index), reset, change_line_index & (i == set_index),
                      {lw_en, set_valid, set_dirty, offset_sel ? addr[OFFSET_WIDTH - 1  : 2] : block_offset, strategy_en, offset_sel},
                      addr, write_data, mread_data, Hit[i], Dirty[i], Read_data[i], Tag[i]);
        end
    endgenerate
    assign read_data = Read_data[set_index];
    assign maddr = {lw_en? addr[31 : 31 - TAG_WIDTH + 1]: Tag[set_index], set_index , block_offset, 2'b00};
    assign mwrite_data = Read_data[set_index];
endmodule
