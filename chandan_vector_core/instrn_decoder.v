module instrn_decoder (
    input [6:0] opcode ,
    input [2:0] funct3 ,

    // ---------------- TYPES ----------------
    output         is_vv,
    output         is_vx,
    output         is_vi,
 
    output         is_vec_load,
    output         is_vec_store,
    output         is_vsetvli ,
    output         writes_vd
);

    // -------------------------------------------------
    // Opcode groups (RISC-V Vector)
    // -------------------------------------------------

    localparam OPC_VEC = 7'b1010111; // Vector arithmetic
    localparam OPC_VLD = 7'b0000111; // Vector load
    localparam OPC_VST = 7'b0100111; // Vector store

    // -------------------------------------------------
    // Vector arithmetic decode
    // -------------------------------------------------

    assign is_vv      = (opcode == OPC_VEC) && (funct3 == 3'b000);
    assign is_vx      = (opcode == OPC_VEC) && (funct3 == 3'b100);
    assign is_vi      = (opcode == OPC_VEC) && (funct3 == 3'b011);
    assign is_vsetvli = (opcode == OPC_VEC) && (funct3 == 3'b111);

    // -------------------------------------------------
    // Load / Store decode
    // -------------------------------------------------

    assign is_vec_load  = (opcode == OPC_VLD);
    assign is_vec_store = (opcode == OPC_VST);

   
    // -------------------------------------------------
    // Scoreboard 
    // - Vector ops write vd except vsetvli
    // - Vector loads write vd
    // -------------------------------------------------
    
    assign writes_vd =
        ((opcode == OPC_VEC) && (funct3 != 3'b111)) ||
        is_vec_load;

endmodule
