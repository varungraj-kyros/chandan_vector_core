module write_back (

    input             vd_we,        // vector write enable (valid)
    input             vm,           // 1 = unmasked, 0 = masked
    input   [2:0]     sew,          // 3'b011=64, 3'b010=32, 3'b001=16
    input   [127:0]   wb_vec_data,  // vector result (ALU / LOAD)
    input   [127:0]   vs3_data,     // old vector register value
    input   [7:0]     v0_mask,      // mask bits from v0

    output reg  [127:0]   vd_wdata      // vector write data

);


    always @(vm or vd_we or sew or vs3_data or  wb_vec_data or v0_mask[0] or v0_mask[1] or v0_mask[2] or 
             v0_mask[3] or v0_mask[4] or v0_mask[5] or v0_mask[6] or v0_mask[7]) 
    begin

        vd_wdata = vs3_data;        

        // =================================================
        // VECTOR WRITEBACK
        // =================================================

        if (vd_we) begin
            case (sew)

                // ---------- SEW = 64 (2 elements) ----------
                3'b011: 
                begin
                    if (vm) 
                    begin
                        vd_wdata = wb_vec_data;
                    end 
                    else 
                    begin
                        vd_wdata[63:0]   =    v0_mask[0] ? wb_vec_data[63:0]   : vs3_data[63:0];
                        vd_wdata[127:64] =    v0_mask[1] ? wb_vec_data[127:64] : vs3_data[127:64];
                    end
                end

                // ---------- SEW = 32 (4 elements) ----------
                3'b010:
                begin
                    if (vm) 
                    begin
                        vd_wdata = wb_vec_data;
                    end 
                    else 
                    begin
                        vd_wdata[31:0]   =   v0_mask[0] ? wb_vec_data[31:0]   : vs3_data[31:0];
                        vd_wdata[63:32]  =   v0_mask[1] ? wb_vec_data[63:32]  : vs3_data[63:32];
                        vd_wdata[95:64]  =   v0_mask[2] ? wb_vec_data[95:64]  : vs3_data[95:64];
                        vd_wdata[127:96] =   v0_mask[3] ? wb_vec_data[127:96] : vs3_data[127:96];
                    end
                end

                // ---------- SEW = 16 (8 elements) ----------
                3'b001: 
                begin
                    if (vm) 
                    begin
                        vd_wdata = wb_vec_data;
                    end 
                    else 
                    begin
                        vd_wdata[15:0]    =   v0_mask[0] ? wb_vec_data[15:0]    : vs3_data[15:0];
                        vd_wdata[31:16]   =   v0_mask[1] ? wb_vec_data[31:16]   : vs3_data[31:16];
                        vd_wdata[47:32]   =   v0_mask[2] ? wb_vec_data[47:32]   : vs3_data[47:32];
                        vd_wdata[63:48]   =   v0_mask[3] ? wb_vec_data[63:48]   : vs3_data[63:48];
                        vd_wdata[79:64]   =   v0_mask[4] ? wb_vec_data[79:64]   : vs3_data[79:64];
                        vd_wdata[95:80]   =   v0_mask[5] ? wb_vec_data[95:80]   : vs3_data[95:80];
                        vd_wdata[111:96]  =   v0_mask[6] ? wb_vec_data[111:96]  : vs3_data[111:96];
                        vd_wdata[127:112] =   v0_mask[7] ? wb_vec_data[127:112] : vs3_data[127:112];
                    end
                end

                default: vd_wdata = vs3_data;
            endcase
        end

    end

endmodule

