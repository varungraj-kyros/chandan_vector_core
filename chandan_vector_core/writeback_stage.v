module writeback_stage (

    // =================================================
    // FROM MEM/WB PIPELINE
    // =================================================

    input           wb_reg_write_vector,
    input           wb_vm,
    input   [2:0]   wb_sew,
    input   [127:0] wb_vec_data,
    input   [127:0] wb_vs3_data,
    input   [7:0]   wb_v0_mask,

    // =================================================
    // TO VECTOR REGISTER FILE
    // =================================================
  
    output  [127:0] vector_write_data

);

    // =================================================
    // WRITEBACK UNIT (MASK + SEW HANDLING)
    // =================================================

    write_back u_write_back (

        .vd_we        (wb_reg_write_vector),
        .vm           (wb_vm),
        .sew          (wb_sew),
        .wb_vec_data  (wb_vec_data),
        .vs3_data     (wb_vs3_data),
        .v0_mask      (wb_v0_mask),
        .vd_wdata     (vector_write_data)

    );

endmodule

