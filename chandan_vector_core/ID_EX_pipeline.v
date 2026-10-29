module ID_EX_pipeline (
    input          clk,
    input          reset,
    input          stall_IDEX,
    input          is_vsetvli , 

    // ================================
    // FROM DECODE STAGE
    // ================================

    input          is_vv,
    input          is_vx,
    input          is_vi,
    input    [4:0] vs1  ,
 
    input    [1:0]  mop ,
    input    [4:0]  vs3 , 
   
    // scalar values (for stride)

    input   [31:0] rs1_data,
    input   [31:0] rs2_data,

    // vector values

    input   [127:0] vs1_data,
    input   [127:0] vs2_data,
    input   [127:0] vs3_data,
    input   [7:0]   v0_data,
    input   [2:0]  sew_f,
    
    // control
    input          reg_write_vector,
    input          mem_write,
    input          wbdata,
    input   [4:0]  alu_op,
    input          alu_cin,

    // ================================
    // TO EXECUTE STAGE
    // ================================
    output reg         ex_is_vv,
    output reg         ex_is_vx,
    output reg         ex_is_vi,
 
    output reg  [1:0]  ex_mop,
    output reg         ex_vm,
    output reg  [4:0]  ex_vs3,  //vd
    output reg  [4:0] ex_imm,

    output reg  [31:0] ex_rs1_data,
    output reg  [31:0] ex_rs2_data,

    output reg  [127:0] ex_vs1_data,
    output reg  [127:0] ex_vs2_data,
    output reg  [127:0] ex_vs3_data,
    output reg  [7:0]   ex_v0_data,

    output reg  [2:0]  ex_sew_f,
    output reg         ex_reg_write_vector,
    output reg         ex_mem_write,
    output reg         ex_wbdata,
    output reg  [4:0]  ex_alu_op,
    output reg         ex_alu_cin
);

    // ================================
    // PIPELINE REGISTER
    // ================================

    always @(posedge clk or posedge reset) 
    begin
        if (reset) 
        begin
            ex_is_vv              <= 1'b0;
            ex_is_vx              <= 1'b0;
            ex_is_vi              <= 1'b0;
            ex_mop                <= 2'b0;
            ex_vm                 <= 1'b0;
            ex_vs3                <= 5'd0;
            ex_imm                <= 5'd0;
            ex_rs1_data           <= 32'd0;
            ex_rs2_data           <= 32'd0;
            ex_vs1_data           <= 128'd0;
            ex_vs2_data           <= 128'd0;
            ex_vs3_data           <= 128'd0;
            ex_v0_data            <= 8'd0;
            ex_reg_write_vector   <= 1'b0;
            ex_mem_write          <= 1'b0;
            ex_wbdata             <= 1'b0;
            ex_alu_op             <= 5'd0;
            ex_alu_cin            <= 1'b0;
        end

        else if (!stall_IDEX) 
        begin
            ex_is_vv              <= is_vv;
            ex_is_vx              <= is_vx;
            ex_is_vi              <= is_vi;
            ex_mop                <= mop;
            ex_vm                 <= sew_f[2];
            ex_vs3                <= vs3;               //vd
            ex_imm                <= vs1;
            ex_rs1_data           <= rs1_data;
            ex_rs2_data           <= rs2_data;
            ex_vs1_data           <= vs1_data;
            ex_vs2_data           <= vs2_data;
            ex_vs3_data           <= vs3_data;
            ex_v0_data            <= v0_data;
            ex_reg_write_vector   <= reg_write_vector;
            ex_mem_write          <= mem_write;
            ex_wbdata             <= wbdata;
            ex_alu_op             <= alu_op;
            ex_alu_cin            <= alu_cin;
        end
        end


always @(posedge clk or posedge reset) begin
        if (reset) 
        ex_sew_f              <= 3'd0;
        else if (is_vsetvli)
        ex_sew_f              <= sew_f;
end

endmodule

