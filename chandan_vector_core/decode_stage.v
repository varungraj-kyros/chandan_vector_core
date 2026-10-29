module decode_stage (
    input          clk,
    input          reset,
    input          rst_scal_register_file,
    input          rst_vector_register_file,

    // ---------------- FROM IF/ID ----------------

    input [6:0] opcode ,
    input [4:0] vs1 ,
    input [4:0] vs2 ,
    input [4:0] vs3 ,
    input [5:0] funct6 ,
    input [2:0] funct3 ,
   
    // ---------------- FROM WRITEBACK ----------------
   
    input          wb_vector_we,
    input  [4:0]   wb_vector_vd,
    input  [127:0] wb_vector_data,

    // ---------------- FROM LSU ----------------

    input          mem_done,
    input          mul_16_done_0,mul_16_done_1,mul_16_done_2,mul_16_done_3,mul_32_done_0, mul_32_done_1,mul_64_done_0, mul_64_done_1, div_16_done_0,div_16_done_1,div_16_done_2, div_16_done_3, div_32_done_0, div_32_done_1, div_64_done_0,div_64_done_1,
    
    // ---------------- STALL OUTPUTS ----------------

    output         stall_IFID,
  
    // ---------------- TO ID/EX ----------------

    output         is_vv,
    output         is_vx,
    output         is_vi,

    output [31:0] rs1_data,         // scalar rs1 
    output [31:0] rs2_data,         // scalar rs2

    output [127:0] vs1_data,
    output [127:0] vs2_data,
    output [127:0] vs3_data,
    output [7:0] v0_data,

  
    output wire        reg_write_vector,
    output wire        mem_write,
    output wire        wbdata,
    output wire [4:0]  alu_op,
    output wire        alu_cin,

    // ---------------- TO LSU ----------------

    output wire        start_mem,
    output wire        start_div,
    output wire        start_mul,
    output wire        is_vsetvli ,
    input wire [4:0] scalar_write_address,
    input wire scalar_write_en,
    input wire [31:0] scalar_data_in

);

    wire        writes_vd;
    wire        block_decode;
    wire        ISSUE_REQ;
    wire        busy;
    wire        reserve_valid;
    wire [4:0]  reserve_vd;

    wire is_vec_load, is_vec_store;

    // =================================================
    // VECTOR DECODER
    // =================================================

    instrn_decoder dec (
      
        .opcode(opcode),
        .funct3(funct3),
        .is_vv(is_vv),
        .is_vx(is_vx),
        .is_vi(is_vi),
        .is_vec_load(is_vec_load),
        .is_vec_store(is_vec_store),
        .is_vsetvli(is_vsetvli) ,
        .writes_vd(writes_vd)
    );

    // =================================================
    // SCALAR REGISTER FILE
    // (only needed for vsetvli + stride)
    // =================================================
    

    scalar_register_file srf (
        .clk(clk),
	    .reset(rst_scal_register_file),
        .write_en(scalar_write_en),
        .write_address(scalar_write_address),
        .read_address_1(vs1),                    // rs1 field reused
        .read_address_2(vs2),                    // rs2 field reused
        .data_in(scalar_data_in),

        .read_data_out_1(rs1_data),
        .read_data_out_2(rs2_data)
    );


    // =================================================
    // VECTOR REGISTER FILE
    // =================================================
    vector_register_file vrf (
        .clk(clk),
    	.reset(rst_vector_register_file),
        .vector_write_en(wb_vector_we),
        .vector_write_address(wb_vector_vd),
        .vector_write_data_in(wb_vector_data),
        .vs1_address(vs1),
        .vs2_address(vs2),
        .vs3_address(vs3),
        .vector_vs1_out(vs1_data),
        .vector_vs2_out(vs2_data),
        .vector_vs3_out(vs3_data),
        .vector_v0_out(v0_data)
    );

     wire is_mul, is_div;


    // =================================================
    // VECTOR CONTROL UNIT
    // =================================================

    vector_control_unit vcu (
                .opcode(opcode),
                .funct3(funct3),
                .funct6(funct6),
                .reg_write_vector(reg_write_vector),
                .mem_write(mem_write),
                .wbdata(wbdata),
                .alu_op(alu_op),
                .alu_cin(alu_cin),
                .is_mul(is_mul),
                .is_div(is_div)
             );


    // =================================================
    // SCOREBOARD
    // =================================================

    scoreboard sb (
        .clk(clk),
        .reset(reset),
        .reserve_valid(reserve_valid),
        .reserve_vd(reserve_vd),
        .release_valid(wb_vector_we),
        .release_vd(wb_vector_vd),
        .vs1(vs1),
        .vs2(vs2),
        .vs3(vs3),
        .is_vv(is_vv),
        .is_vx(is_vx),
        .is_vi(is_vi),
        .block_decode(block_decode)
    );

    // =================================================
    // ISSUE CONTROL STAGE
    // =================================================

    decode_control_stage issue (

        .writes_vd(writes_vd),
        .vs3(vs3),
        .block_decode(block_decode),
        .busy(busy),
        .ISSUE_REQ(ISSUE_REQ),
        .reserve_valid(reserve_valid),
        .reserve_vd(reserve_vd),
        .stall_IFID(stall_IFID)
      );

    // =================================================
    // STALLING / LSU CONTROL
    // =================================================

    stalling stall_u (
        .clk(clk),
        .reset(reset),
        .ISSUE_REQ(ISSUE_REQ),
        .is_vec_load(is_vec_load),
        .is_vec_store(is_vec_store),
        .is_mul(is_mul),
        .is_div(is_div),
        .mem_done(mem_done),
        .mul_16_done_0(mul_16_done_0),
        .mul_16_done_1(mul_16_done_1),
        .mul_16_done_2(mul_16_done_2),
        .mul_16_done_3(mul_16_done_3),
        .mul_32_done_0(mul_32_done_0),
        .mul_32_done_1(mul_32_done_1),
        .mul_64_done_0(mul_64_done_0),
        .mul_64_done_1(mul_64_done_1),
        .div_16_done_0(div_16_done_0),
        .div_16_done_1(div_16_done_1),
        .div_16_done_2(div_16_done_2),
        .div_16_done_3(div_16_done_3),
        .div_32_done_0(div_32_done_0),
        .div_32_done_1(div_32_done_1),
        .div_64_done_0(div_64_done_0),
        .div_64_done_1(div_64_done_1),
        .busy(busy),
        .start_mem(start_mem),
        .start_mul(start_mul),
        .start_div(start_div)
    );

endmodule

