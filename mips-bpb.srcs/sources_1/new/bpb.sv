`include "bpb.vh"

/**
 * ENTRIES          : number of entries in the branch predictor buffer
 * TAG_WIDTH        : index bits
 * instr_adr        : if this address has been recorded, then CPU can go as the BPB directs
 * isbranch         : in order to register the branch when first meeted
 * real_taken       : whether this branch should be taken according to the semantics of the instructions
 * real_adr         : where should this branch jumps to
 * predict_taken    : whether this branch should be taken according to the prediction of our BPB
 * predict_adr      : where should this branch jumps to if it's taken
 */
module bpb #(
    parameter ENTRIES = `BPB_E,
    parameter TAG_WIDTH = `BPB_T
) (
    input                   clk, reset, stall, flush,
    input [TAG_WIDTH-1:0]   instr_adr,
    
    input                   isbranch,
    // reality
    input                   real_taken,
    input [31:0]            real_adr,
    // prediction
    output               predict_taken,
    output  [31:0]       predict_adr
);

    parameter initialize = 1'b0, writing = 1'b1;
    logic state = 0;
    int change_index = 0, line_index = 0, miss = 0;
    logic [TAG_WIDTH - 1:0]index[0:ENTRIES - 1], target_index;
    always@(posedge clk, reset)
    begin
        if(reset)
        begin
            state <= initialize;
            miss <= 0;
            change_index <= 0;
        end
        else begin
            case(state)
                initialize:begin
                    if(isbranch)
                    begin
                        state <= writing;
                        target_index <= instr_adr;
                        if(miss == 1)
                        begin
                            change_index <= (change_index + 1) % ENTRIES;
                            miss <= 0;
                        end
                    end
                end
                writing:begin
                    if(stall)
                    begin
                        state <= initialize;
                    end
                end
            endcase
        end
    end
    always@(*)
    begin
        if(state == initialize && isbranch)
        begin
            miss = 1;
            for(int i = 0; i < ENTRIES; i++)
            begin
                if(index[i] == instr_adr)
                begin
                    miss = 0;
                    line_index = i;
                end
            end
            if(miss == 1)
            begin
                line_index = change_index;
            end
        end
    end
    logic [32:0]predict[0:ENTRIES - 1];
    generate
        genvar i;
        for(i = 0; i < ENTRIES; i++)
        begin
            bpb_line i_bpb_line(clk, reset, (state == writing) && stall && (i == line_index), 
                      {real_taken, real_adr, target_index},
                      {predict[i], index[i]}); 
        end
    endgenerate
    assign {predict_taken, predict_adr} = ((miss == 0 && isbranch == 1) ? predict[line_index] : 33'b0);
endmodule