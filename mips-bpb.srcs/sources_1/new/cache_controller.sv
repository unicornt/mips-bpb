`include "cache.vh"
/**
 * en         : en in cache module
 * cw_en      : cache writing enable signal, from w_en in cache module
 * hit, dirty : from set module
 *
 * w_en       : writing enable signal to cache line
 * mw_en      : writing enable signal to memory , controls whether to write to memory
 * set_valid  : control signal for cache line
 * set_dirty  : control signal for cache line
 * offset_sel : control signal for cache line and this may be used in other places
 */
module cache_controller #(
    parameter OFFSET_WIDTH = `CACHE_B
)(
    input  clk, reset, en,
    input [OFFSET_WIDTH - 3 : 0]offseta,
    input cw_en, hit, dirty, // mready,
    output logic w_en, set_valid, set_dirty, mw_en,
    output logic [OFFSET_WIDTH - 3:0] block_offset,
    output logic strategy_en, offset_sel, change_line_index, out_hit
);
    parameter ReadMem = 2'b00, WriteBack = 2'b01, Initialize = 2'b11, WriteCache = 2'b10;
    parameter maxoffset = 2 ** (OFFSET_WIDTH - 2);
    logic [1:0]state = Initialize;
    int offset = 0;
    always@(negedge clk, reset)
    begin
        if(reset) offset <= offseta;
        else if(/*(en | ~(state == WriteBack)) &&*/ state != Initialize && state != WriteCache) offset <= offset + 1;
    end
    always@(negedge clk)
    begin
        case(state)
            Initialize:
            begin
                if(~hit)
                begin
                    if(dirty == 1)
                    begin
                        change_line_index <= 0;
                        strategy_en <= 0;
                        offset <= 0;
                        mw_en <= 1;
                        out_hit <= 0;
                        w_en <= 0;
                        set_valid <= 0;
                        set_dirty <= 0;
                        offset_sel <= 0;
                        //$display("WriteBack %x", offset);
                        state <= WriteBack;
                    end
                    else if(dirty == 0)
                    begin
                        offset_sel <= 0;
                        offset <= 0;
                        w_en <= 1;
                        out_hit <= 0;
                        mw_en <= 0;
                        change_line_index <= 0;
                        strategy_en <= 0;
                        set_valid <= 0;
                        set_dirty <= 0;
                        state <= ReadMem;//
                    end
                end
                else if(cw_en)
                begin
                    change_line_index <= 0;
                    strategy_en <= 0;
                    offset <= offseta;
                    w_en <= 1;
                    mw_en <= 0;
                    out_hit <= 0;
                    set_valid <= 1;
                    set_dirty <= 1;
                    offset_sel <= 1;
                    state <= WriteCache;
                end
                else
                begin
                    out_hit <= hit;
                    offset <= offseta;
                end
            end
            ReadMem:
            begin
                if(offset == maxoffset - 1)
                begin
                    out_hit <= hit;
                    change_line_index <= 1;
                    offset_sel <= 0;
                    w_en <= 0;
                    mw_en <= 0;
                    strategy_en <= 1;
                    offset <= offseta;
                    state <= Initialize;
                end
                else if(offset == maxoffset - 2) set_valid <= 1;
            end
            WriteBack:
            begin
                if(offset == maxoffset - 1)
                begin
                    offset_sel <= 0;
                    offset <= 0;
                    w_en <= 1;
                    out_hit <= 0;
                    mw_en <= 0;
                    change_line_index <= 0;
                    strategy_en <= 0;
                    set_valid <= 0;
                    set_dirty <= 0;
                    state <= ReadMem;
                end
            end
            WriteCache:
            begin
                out_hit <= hit;
                change_line_index <= 1;
                mw_en <= 0;
                offset_sel <= 0;
                strategy_en <= 1;
                w_en <= 0;
                offset <= offseta;
                set_valid <= 0;
                set_dirty <= 0;
                state <= Initialize;
            end
        endcase
        if(reset)
        begin
            out_hit <= 0;
            change_line_index <= 1;
            strategy_en <= 1;
            offset_sel <= 0;
            w_en <= 0;
            mw_en <= 0;
            set_valid <= 0;
            set_dirty <= 0;
            state <= Initialize;
        end
    end
    assign block_offset = offset[OFFSET_WIDTH - 1 : 0];
endmodule
