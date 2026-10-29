module vector_top (
    input          clk,
    input          reset ,
    input          rst_inst_mem,
    input          rst_scal_register_file,
    input          rst_vector_register_file,

    input [31:0]   instruction_data_in,
    input [7:0]    instruction_write_address,
    input          instruction_write_en,

    input [4:0]    scalar_write_address,
    input          scalar_write_en,
    input [31:0]   scalar_data_in,


    output[4:0]    top_vector_address,
    output[127:0]  top_vector_data ,
    output         top_vector_en 

	);

    // =============================================================
    // IF STAGE
    // =============================================================

    wire [31:0]     ifid_instr;
    wire            stall_IFID;
    
    if_stage if_instance (

        .clk                (clk),
        .reset              (reset),
	    .rst_inst_mem       (rst_inst_mem),
        .stall_IFID         (stall_IFID),
        .IF_ID_instruction  (ifid_instr),
        .data_in            (instruction_data_in),
	    .write_en           (instruction_write_en),
	    .write_address      (instruction_write_address)

    );

    // =============================================================
    // WRITEBACK 
    // =============================================================

    wire [127:0]    wb_vector_data;
    wire [4:0]      wb_vs3;
    wire            wb_reg_write_vector;

    // =============================================================
    // DECODE STAGE OUTPUTS
    // =============================================================

    wire            is_vv, is_vx, is_vi;
    wire [31:0]     rs1_data, rs2_data;
    wire [127:0]    vs1_data, vs2_data, vs3_data;
    wire [7:0]      v0_data;
    wire            reg_write_vector;   
    wire            mem_write, wbdata;
    wire [4:0]      alu_op;
    wire            alu_cin;
    wire            start_mem;
    wire            start_mul;
    wire            start_div;
    wire            mem_done;
    wire            is_vsetvli;
    wire            mul_16_done_0, mul_16_done_1, mul_16_done_2, mul_16_done_3, mul_32_done_0, mul_32_done_1, mul_64_done_0, mul_64_done_1; 
    wire            div_16_done_0, div_16_done_1, div_16_done_2, div_16_done_3, div_32_done_0, div_32_done_1, div_64_done_0, div_64_done_1;

    decode_stage ID (

        .clk                        (clk),        
        .reset                      (reset),
        .rst_scal_register_file     ( rst_scal_register_file),
        .rst_vector_register_file   ( rst_vector_register_file),
        .opcode                     (ifid_instr[6:0]) ,
        .funct3                     (ifid_instr[14:12]) ,
        .funct6                     (ifid_instr[31:26]) ,
        .vs1                        (ifid_instr[19:15]) ,
        .vs2                        (ifid_instr[24:20]) ,
        .vs3                        (ifid_instr[11:7]) ,
        .is_vsetvli                 (is_vsetvli) ,
        .scalar_write_en            (scalar_write_en),
        .scalar_write_address       (scalar_write_address),
        .scalar_data_in             (scalar_data_in),      
        .wb_vector_we               (wb_reg_write_vector),
        .wb_vector_vd               (wb_vs3),
        .wb_vector_data             (wb_vector_data),
        .mem_done                   (mem_done),
        .mul_16_done_0              (mul_16_done_0),
        .mul_16_done_1              (mul_16_done_1),
        .mul_16_done_2              (mul_16_done_2),
        .mul_16_done_3              (mul_16_done_3),
        .mul_32_done_0              (mul_32_done_0),
        .mul_32_done_1              (mul_32_done_1),
        .mul_64_done_0              (mul_64_done_0),
        .mul_64_done_1              (mul_64_done_1),
        .div_16_done_0              (div_16_done_0),
        .div_16_done_1              (div_16_done_1),
        .div_16_done_2              (div_16_done_2),
        .div_16_done_3              (div_16_done_3),
        .div_32_done_0              (div_32_done_0),
        .div_32_done_1              (div_32_done_1),
        .div_64_done_0              (div_64_done_0),
        .div_64_done_1              (div_64_done_1),
        .stall_IFID                 (stall_IFID),
        .is_vv                      (is_vv),
        .is_vx                      (is_vx),
        .is_vi                      (is_vi),
        .rs1_data                   (rs1_data),
        .rs2_data                   (rs2_data),
        .vs1_data                   (vs1_data),
        .vs2_data                   (vs2_data),
        .vs3_data                   (vs3_data),
        .v0_data                    (v0_data),
        .reg_write_vector           (reg_write_vector),
        .mem_write                  (mem_write),
        .wbdata                     (wbdata),
        .alu_op                     (alu_op),
        .alu_cin                    (alu_cin),
        .start_mem                  (start_mem),  
        .start_mul                  (start_mul),
        .start_div                  (start_div)
                    );

    // =============================================================
    // ID / EX PIPELINE
    // =============================================================

    wire            ex_is_vv, ex_is_vx, ex_is_vi;
    wire [1:0]      ex_mop;    
    wire [4:0]      ex_vs3; 
    wire [4:0]      ex_imm;
    wire            ex_vm;
    wire [31:0]     ex_rs1_data, ex_rs2_data;
    wire [127:0]    ex_vs1_data, ex_vs2_data, ex_vs3_data;
    wire [7:0]      ex_v0_data;
    wire [2:0]      ex_sew_f;
    wire            ex_reg_write_vector; 
    wire            ex_mem_write, ex_wbdata;
    wire [4:0]      ex_alu_op;
    wire            ex_alu_cin;

    ID_EX_pipeline ID_EX (
        .clk                        (clk),
        .reset                      (reset),
        .stall_IDEX                 (stall_IFID),
        .is_vsetvli                 (is_vsetvli) ,
        .is_vv                      (is_vv),
        .is_vx                      (is_vx),
        .is_vi                      (is_vi),
        .mop                        (ifid_instr[27:26]) ,
        .vs3                        (ifid_instr[11:7]) ,
        .vs1                        (ifid_instr[19:15]) ,
        .rs1_data                   (rs1_data),
        .rs2_data                   (rs2_data),
        .vs1_data                   (vs1_data),
        .vs2_data                   (vs2_data),
        .vs3_data                   (vs3_data),
        .v0_data                    (v0_data),
        .sew_f                      (ifid_instr[25:23]),
        .reg_write_vector           (reg_write_vector),
        .mem_write                  (mem_write),
        .wbdata                     (wbdata),
        .alu_op                     (alu_op),
        .alu_cin                    (alu_cin),
        .ex_is_vv                   (ex_is_vv),
        .ex_is_vx                   (ex_is_vx),
        .ex_is_vi                   (ex_is_vi),
        .ex_mop                     (ex_mop),
        .ex_vm                      (ex_vm),
        .ex_vs3                     (ex_vs3),
        .ex_imm                     (ex_imm),
        .ex_rs1_data                (ex_rs1_data),
        .ex_rs2_data                (ex_rs2_data),
        .ex_vs1_data                (ex_vs1_data),
        .ex_vs2_data                (ex_vs2_data),
        .ex_vs3_data                (ex_vs3_data),
        .ex_v0_data                 (ex_v0_data),
        .ex_sew_f                   (ex_sew_f),
        .ex_reg_write_vector        (ex_reg_write_vector),
        .ex_mem_write               (ex_mem_write),
        .ex_wbdata                  (ex_wbdata),
        .ex_alu_op                  (ex_alu_op),
        .ex_alu_cin                 (ex_alu_cin)
    );

    // =============================================================
    // EXECUTE STAGE (ALU)
    // =============================================================
   
    wire [127:0]    ex_alu_result;
    
    execute_stage EX (
        .ex_is_vv                   (ex_is_vv),
        .ex_is_vx                   (ex_is_vx),
        .ex_is_vi                   (ex_is_vi),
        .clk                        (clk),
        .reset                      (reset),
        .start_div                  (start_div),
        .start_mul                  (start_mul),
        .mul_16_done_0              (mul_16_done_0),
        .mul_16_done_1              (mul_16_done_1),
        .mul_16_done_2              (mul_16_done_2),
        .mul_16_done_3              (mul_16_done_3),
        .mul_32_done_0              (mul_32_done_0),
        .mul_32_done_1              (mul_32_done_1),
        .mul_64_done_0              (mul_64_done_0),
        .mul_64_done_1              (mul_64_done_1),
        .div_16_done_0              (div_16_done_0),
        .div_16_done_1              (div_16_done_1),
        .div_16_done_2              (div_16_done_2),
        .div_16_done_3              (div_16_done_3),
        .div_32_done_0              (div_32_done_0),
        .div_32_done_1              (div_32_done_1),
        .div_64_done_0              (div_64_done_0),
        .div_64_done_1              (div_64_done_1),
        .ex_rs1_data                (ex_rs1_data),
        .ex_imm                     (ex_imm),
        .ex_vs1_data                (ex_vs1_data),
        .ex_vs2_data                (ex_vs2_data),
        .ex_sew_f                   (ex_sew_f),
        .ex_alu_op                  (ex_alu_op),
        .ex_alu_cin                 (ex_alu_cin),
        .ex_alu_result              (ex_alu_result)
    );

    // =============================================================
    // EX / MEM PIPELINE
    // =============================================================

    wire [127:0]    mem_alu_result;
    wire [1:0]      mem_mop;
    wire            mem_vm;
    wire [4:0]      mem_vs3; 
    wire [31:0]     mem_rs1_data, mem_rs2_data;
    wire [127:0]    mem_vs2_data, mem_vs3_data;
    wire [2:0]      mem_sew_f;
    wire [7:0]      mem_v0_data;
    wire            mem_reg_write_vector; 
    wire            mem_wbdata;
    wire            mem_mem_write;

    EX_MEM_pipeline EX_MEM (
        .clk                        (clk),
        .reset                      (reset),
        .ex_alu_result              (ex_alu_result),
        .ex_mop                     (ex_mop),
        .ex_vm                      (ex_vm),
        .ex_vs3                     (ex_vs3),
        .ex_sew_f                   (ex_sew_f),
        .ex_v0_data                 (ex_v0_data),
        .ex_rs1_data                (ex_rs1_data),
        .ex_rs2_data                (ex_rs2_data),
        .ex_vs2_data                (ex_vs2_data),
        .ex_vs3_data                (ex_vs3_data),
        .ex_reg_write_vector        (ex_reg_write_vector),
        .ex_wbdata                  (ex_wbdata),
    	.ex_mem_write               (ex_mem_write),
        .mem_alu_result             (mem_alu_result),
        .mem_mop                    (mem_mop),
        .mem_vm                     (mem_vm),
        .mem_vs3                    (mem_vs3),
        .mem_sew_f                  (mem_sew_f),
        .mem_v0_data                (mem_v0_data),
        .mem_rs1_data               (mem_rs1_data),
        .mem_rs2_data               (mem_rs2_data),
        .mem_vs2_data               (mem_vs2_data),
        .mem_vs3_data               (mem_vs3_data),
    	.mem_mem_write              (mem_mem_write),
        .mem_reg_write_vector       (mem_reg_write_vector),
        .mem_wbdata                 (mem_wbdata)
    );

    // =============================================================
    // MEMORY STAGE (LSU)
    // =============================================================

    wire [127:0]    mem_lsu_result;

    memory_stage MEM (
        .clk                        (clk),
        .reset                      (reset),
        .mem_mem_read               (mem_wbdata),
        .mem_mem_write              (mem_mem_write),
        .mem_mop                    (mem_mop),
        .mem_rs1_data               (mem_rs1_data),
        .mem_rs2_data               (mem_rs2_data),
        .mem_vs2_data               (mem_vs2_data),
        .mem_vs3_data               (mem_vs3_data),
        .start_mem                  (start_mem),
        .mem_lsu_result             (mem_lsu_result),
        .mem_done                   (mem_done)
    );

    // =============================================================
    // MEM / WB PIPELINE
    // =============================================================

    wire [127:0]    wb_vec_data_internal;
    wire            wb_vm;
    wire [2:0]      wb_sew;
    wire [127:0]    wb_vs3_data;
    wire [7:0]      wb_v0_mask;

    MEM_WB_pipeline MEM_WB (
        .clk                        (clk),
        .reset                      (reset),
        .mem_alu_result             (mem_alu_result),
        .mem_wbdata                 (mem_wbdata),
        .mem_vm                     (mem_vm),
        .mem_sew                    (mem_sew_f),
        .mem_vs3                    (mem_vs3),
        .mem_reg_write_vector       (mem_reg_write_vector),
        .mem_vs3_data               (mem_vs3_data),
        .mem_v0_data                (mem_v0_data),
        .mem_lsu_result             (mem_lsu_result),
        .mem_done                   (mem_done),
        .wb_vec_data                (wb_vec_data_internal),
        .wb_vm                      (wb_vm),
        .wb_sew                     (wb_sew),
        .wb_vs3                     (wb_vs3),  //vd
        .wb_reg_write_vector        (wb_reg_write_vector),
        .wb_vs3_data                (wb_vs3_data),
        .wb_v0_mask                 (wb_v0_mask)
    );

    // =============================================================
    // WRITEBACK STAGE
    // =============================================================

    writeback_stage WB (
        .wb_reg_write_vector        (wb_reg_write_vector),
        .wb_vm                      (wb_vm),
        .wb_sew                     (wb_sew),
        .wb_vec_data                (wb_vec_data_internal),
        .wb_vs3_data                (wb_vs3_data),
        .wb_v0_mask                 (wb_v0_mask),
        .vector_write_data          (wb_vector_data)
     );

    assign top_vector_address = wb_vs3;
    assign top_vector_data = wb_vector_data;
    assign top_vector_en = wb_reg_write_vector ;

endmodule
