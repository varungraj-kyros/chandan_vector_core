module memory_stage (
    input           clk,
    input           reset,

    // =============================================================
    // FROM EX/MEM PIPELINE 
    // =============================================================
    input           mem_mem_read,          // scalar load
    input           mem_mem_write,         // scalar store

    input   [1:0]   mem_mop,            // 00=unit,10=strided,01=indexed

    // =============================================================
    // FROM EX/MEM PIPELINE (OPERANDS)
    // =============================================================
    input   [31:0]  mem_rs1_data,       // base address
    input   [31:0]  mem_rs2_data,       // stride
    input   [127:0] mem_vs2_data,       // index vector
    input   [127:0] mem_vs3_data,       // store data

    // =============================================================
    // FROM STALLING LOGIC
    // =============================================================
    input           start_mem,           // 1-cycle start pulse

    // =============================================================
    // TO MEM/WB PIPELINE
    // =============================================================
    output  [127:0] mem_lsu_result,      // load result
    output          mem_done             // LSU done 
);

    wire lsu_is_load;
    wire lsu_is_store;

    assign lsu_is_load  = mem_mem_read;  
    assign lsu_is_store = mem_mem_write;


    // =============================================================
    // VECTOR / SCALAR LSU INSTANCE
    // =============================================================
    vector_lsu_nw u_lsu (
        .clk            (clk),
        .reset          (reset),
        .start          (start_mem),
        .is_load        (lsu_is_load),
        .is_store       (lsu_is_store),
        .mop            (mem_mop),
        .rs1_base_addr  (mem_rs1_data),
        .rs2_stride     (mem_rs2_data),
        .vs2_index      (mem_vs2_data),
        .vs3_store      (mem_vs3_data),
        .vd_load        (mem_lsu_result),
        .done           (mem_done)
    );

endmodule

