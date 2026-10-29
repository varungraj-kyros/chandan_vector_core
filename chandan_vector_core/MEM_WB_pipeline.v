module MEM_WB_pipeline (
    input          clk,
    input          reset,

    // ================= FROM EX/MEM =================

    input   [127:0] mem_alu_result,
    input           mem_wbdata,           // 0 = ALU, 1 = MEMORY
    input           mem_vm,
    input   [2:0]   mem_sew,
    input   [4:0]   mem_vs3,
    input           mem_reg_write_vector,
    input   [127:0] mem_vs3_data,
    input   [7:0]   mem_v0_data,

    // ================= FROM LSU ====================

    input  wire [127:0] mem_lsu_result,
    input  wire         mem_done,

    output reg  [127:0] wb_vec_data,  //To WB
    output reg          wb_vm,
    output reg  [2:0]   wb_sew,
    output reg  [4:0]   wb_vs3,
    output reg          wb_reg_write_vector,
    output reg  [127:0] wb_vs3_data,
    output reg  [7:0] wb_v0_mask
);

    // =================================================
    // COMBINATIONAL WRITE-ENABLE DECISION (FIXED)
    // =================================================

    wire wb_reg_write_vector_next;

    assign wb_reg_write_vector_next = mem_reg_write_vector && ( !mem_wbdata || mem_done );

    // =================================================
    // COMBINATIONAL VECTOR DATA NEXT 
    // =================================================

    reg [127:0] wb_vec_data_next;

    always @( wb_vec_data or mem_wbdata or mem_done or mem_alu_result or mem_lsu_result )
    begin
        // default: hold previous value (load stall case)
        wb_vec_data_next = wb_vec_data;

        if (!mem_wbdata) 
        begin
            wb_vec_data_next = mem_alu_result;   // ALU result
        end

        else if (mem_done) 
        begin
            wb_vec_data_next = mem_lsu_result;   // LOAD result

        end
    end

    // =================================================
    // SEQUENTIAL PIPELINE REGISTER
    // =================================================
    
    always @(posedge clk or posedge reset) 
    begin
        if (reset) 
        begin
            wb_vec_data          <= 128'd0;
            wb_vm                <= 1'b0;
            wb_sew               <= 3'd0;
            wb_vs3               <= 5'd0;
            wb_vs3_data          <= 128'd0;
            wb_v0_mask           <= 8'd0;
            wb_reg_write_vector  <= 1'b0;
        end
        else 
        begin
            wb_vec_data         <= wb_vec_data_next;   
            wb_vm               <= mem_vm;
            wb_sew              <= mem_sew;
            wb_vs3              <= mem_vs3;
            wb_vs3_data         <= mem_vs3_data;
            wb_v0_mask          <= mem_v0_data;
            wb_reg_write_vector <= wb_reg_write_vector_next;
        end
    end

endmodule
