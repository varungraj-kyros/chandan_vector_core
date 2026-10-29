module execute_stage (

    // FROM ID/EX PIPELINE

    input          clk, reset, start_mul, start_div,
    input          ex_is_vv,
    input          ex_is_vx,
    input          ex_is_vi,

    input   [31:0] ex_rs1_data,
    input   [4:0] ex_imm,

    input   [127:0] ex_vs1_data,
    input   [127:0] ex_vs2_data,

    input   [2:0]  ex_sew_f,

    input   [4:0]  ex_alu_op,
    input          ex_alu_cin,
    output         mul_16_done_0,
                   mul_16_done_1,
                   mul_16_done_2,
                   mul_16_done_3,
                   mul_32_done_0, 
                   mul_32_done_1,
                   mul_64_done_0, 
                   mul_64_done_1, 
                   div_16_done_0,
                   div_16_done_1,
                   div_16_done_2, 
                   div_16_done_3, 
                   div_32_done_0, 
                   div_32_done_1, 
                   div_64_done_0,
                   div_64_done_1,

    // =================================================
    // TO EX/MEM PIPELINE
    // =================================================

    output [127:0] ex_alu_result

);

    // =================================================
    // OPERAND SELECT
    // =================================================

    wire [127:0] alu_in1;
    wire [127:0] alu_in2;

    vector_operand_select u_operand_select (
        .rs1_data (ex_rs1_data),
        .vs1_data (ex_vs1_data),
        .vs2_data (ex_vs2_data),
        .imm      (ex_imm),
        .sew      (ex_sew_f[2:0]),

        .is_vv    (ex_is_vv),
        .is_vx    (ex_is_vx),
        .is_vi    (ex_is_vi),

        .alu_in1  (alu_in1),
        .alu_in2  (alu_in2)
    );

    // =================================================
    // VECTOR ALU
    // =================================================

    alu_top u_alu (
        .in_1           (alu_in1),
        .in_2           (alu_in2),
        .clk            (clk),
        .reset          (reset),
        .start_mul      (start_mul),
        .start_div      (start_div),
        .mul_16_done_0  (mul_16_done_0),
        .mul_16_done_1  (mul_16_done_1),
        .mul_16_done_2  (mul_16_done_2),
        .mul_16_done_3  (mul_16_done_3),
        .mul_32_done_0  (mul_32_done_0),
        .mul_32_done_1  (mul_32_done_1),
        .mul_64_done_0  (mul_64_done_0),
        .mul_64_done_1  (mul_64_done_1),
        .div_16_done_0  (div_16_done_0),
        .div_16_done_1  (div_16_done_1),
        .div_16_done_2  (div_16_done_2),
        .div_16_done_3  (div_16_done_3),
        .div_32_done_0  (div_32_done_0),
        .div_32_done_1  (div_32_done_1),
        .div_64_done_0  (div_64_done_0),
        .div_64_done_1  (div_64_done_1),
        .alu_op         (ex_alu_op),
        .cin            (ex_alu_cin),
        .sew            (ex_sew_f[2:0]),
        .alu_out        (ex_alu_result)
    );

endmodule
