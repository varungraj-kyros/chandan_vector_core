module EX_MEM_pipeline (
    input          clk,
    input          reset,

    // FROM EXECUTE STAGE

    input  [127:0] ex_alu_result,

    // FROM ID/EX 

    input  [1:0]   ex_mop,
    input          ex_vm,
    input  [4:0]   ex_vs3, 
    input  [2:0]   ex_sew_f,
    input  [7:0]   ex_v0_data,   
    input  [31:0]  ex_rs1_data,
    input  [31:0]  ex_rs2_data,
    input  [127:0] ex_vs2_data,
    input  [127:0] ex_vs3_data,
    input          ex_reg_write_vector,
    input          ex_wbdata,
    input          ex_mem_write,

    // ============================================
    // TO MEMORY STAGE
    // ============================================

    output reg  [127:0]mem_alu_result,
    output reg  [1:0]  mem_mop,
    output reg         mem_vm,
    output reg  [4:0]  mem_vs3, 
    output reg  [2:0]  mem_sew_f,
    output reg  [7:0]  mem_v0_data,      
    output reg  [31:0] mem_rs1_data,
    output reg  [31:0] mem_rs2_data,
    output reg  [127:0]mem_vs2_data,
    output reg  [127:0]mem_vs3_data,
    output reg         mem_mem_write,
    output reg         mem_reg_write_vector,
    output reg         mem_wbdata
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mem_alu_result        <= 128'd0;
            mem_v0_data           <= 8'd0;
            mem_rs1_data          <= 32'd0;
            mem_rs2_data          <= 32'd0;
            mem_vs2_data          <= 128'd0;
            mem_vs3_data          <= 128'd0;
            mem_mop               <= 2'b00;
            mem_vm                <= 1'b0;
            mem_vs3                 <= 5'd0;
            mem_sew_f             <= 3'd0;
            mem_reg_write_vector  <= 1'b0;
            mem_wbdata            <= 1'b0;
            mem_mem_write <= 1'b0;
        end
        else begin
            mem_alu_result        <= ex_alu_result;
            mem_v0_data           <= ex_v0_data;
            mem_rs1_data          <= ex_rs1_data;
            mem_rs2_data          <= ex_rs2_data;
            mem_vs2_data          <= ex_vs2_data;
            mem_vs3_data          <= ex_vs3_data;
            mem_mop               <= ex_mop;
            mem_vm                <= ex_vm;
            mem_vs3                <= ex_vs3; 
            mem_sew_f             <= ex_sew_f;
            mem_reg_write_vector  <= ex_reg_write_vector;
            mem_wbdata            <= ex_wbdata;
            mem_mem_write<=ex_mem_write ;

        end
    end

endmodule
