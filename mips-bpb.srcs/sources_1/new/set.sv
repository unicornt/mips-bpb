`include "cache.vh"
/**
 * ctls       : control signals from cache_controller
 * addr       : cache read/write address from processor
 * write_data : cache write data from processor
 * mread_data : data read from memory
 * 
 * hit        : whether cache set hits
 * dirty      : from the cache line selected by addr (cache line's tag is equal to addr's tag)
 */
module set #(
	parameter TAG_WIDTH    = `CACHE_T,
		      OFFSET_WIDTH = `CACHE_B,
		      LINES        = `CACHE_E
)(
	input                         clk, set_sel, reset, change_line_index,
	input  [4 + OFFSET_WIDTH-2:0] ctls,
	input  [31:0]                 addr, write_data, mread_data,
	output logic                  hit, dirty,
	output [31:0]                 read_data,
	output [TAG_WIDTH - 1 : 0]    tag
);

    logic w_en, set_valid, set_dirty, init, offsetSW;
    logic [OFFSET_WIDTH - 3:0] offset;
    int line_index;
    logic [LINES - 1 : 0] Dirty, Valid;
    logic [TAG_WIDTH - 1: 0] set_tag;
    logic [TAG_WIDTH - 1: 0] Tag[0 : LINES - 1];
    logic [31:0] Read_data[0 : LINES - 1];
    logic [31:0] line_write_data;
    assign line_write_data = offset_sel ? write_data : mread_data;
    // control signals will be assigned to the target line instance.
    assign {w_en, set_valid, set_dirty, offset, strategy_en, offset_sel} = ctls;
    int que[LINES : 0], j;
    always@(*)
    begin
        if(change_line_index == 1 && set_sel == 1)
        begin
            hit = 0;
            line_index = LINES;
            for(int i = 0; i < LINES; i++)
            begin
                if(Tag[que[i]] == addr[31: 31 - TAG_WIDTH + 1] && Valid[que[i]] == 1)
                begin
                    line_index = que[i];
                    if(strategy_en)
                    begin
                       // $display("stratey_en");
                        for(int k = i; k < LINES - 1; k++)
                        begin
                            que[k] = que[k + 1];
                        end
                        que[LINES - 1] = line_index;
                    end
                    break;
                end
            end
            if(line_index != LINES)
            begin
               hit = 1;
            end
            else if(strategy_en == 1)
            begin
               for(int i = 0; i < LINES; i++)
               begin
                    if(Valid[que[i]] == 0)
                    begin
                        line_index = que[i];
                        break;
                    end
               end
               if(line_index == LINES)
               begin
                   line_index = que[0];
                   // $display("strategy_en  %x", line_index);
                   for(int i = 1; i < LINES; i++) que[i - 1] = que[i];
                   que[LINES - 1] = line_index;
               end
           end
       end
       //else if(line_index < LINES && Valid[line_index] == 1) hit = 1;
        if(reset)
        begin
            for(int i = 0; i < LINES; i++) que[i] = i;
        end
    end
    
    assign set_tag = addr[31 : 31 - TAG_WIDTH + 1];
    
    generate
        genvar i;
        for(i = 0; i < LINES; i++)
        begin
            line i_line(clk & (i == line_index ? 1'b1 : 1'b0), reset, offset, w_en, 
                        set_valid, set_dirty, set_tag, line_write_data,
                        Valid[i], Dirty[i], Tag[i], Read_data[i]);
        end
    endgenerate
    assign read_data = line_index != LINES ? Read_data[line_index] : 32'bX;
    assign dirty = line_index != LINES ? Dirty[line_index] : 1'bX;
    assign tag = line_index != LINES ? Tag[line_index] : 32'bX;
endmodule
