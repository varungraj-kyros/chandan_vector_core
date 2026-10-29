module vector_lsu_nw (
    input               clk,
    input               reset,
    input               start,
    input               is_load,
    input               is_store,
    input   [1:0]       mop,            // 00=unit, 10=strided, 01=indexed
    input   [31:0]      rs1_base_addr,
    input   [31:0]      rs2_stride,
    input   [127:0]     vs2_index,
    input   [127:0]     vs3_store,
    output reg  [127:0] vd_load,
    output reg          done
);

    // ---------------- Memory ----------------
    reg        mem_we;
    reg [31:0] mem_addr;
    reg [31:0] mem_addr_r;
    reg [31:0] mem_wdata;
    wire [31:0] mem_rdata;

    data_memory u_data_mem (
        .clk           (clk)        ,
        .write_en      (mem_we)     ,
        .addr          (mem_addr)   ,
        .write_data    (mem_wdata)  ,
        .read_data     (mem_rdata)
    );

    // ---------------- Internal ----------------
    reg [1:0]  elem_cnt;        // STORE -> elem_cnt
    reg [1:0]  elem_idx_r;      // LOAD  -> elem_idx_r
    reg        active;
    reg        last_cycle;
    reg [31:0] index_offset_r;  // delayed index (LOAD)

    // ---------------- Index select ----------------
    wire [1:0] addr_idx = is_store ? elem_cnt : elem_idx_r;

    // ---------------- Stride offset ----------------
    wire [31:0] stride_offset =
        (addr_idx == 2'd0) ? 32'd0 :
        (addr_idx == 2'd1) ? rs2_stride :
        (addr_idx == 2'd2) ? (rs2_stride << 1) : (rs2_stride + (rs2_stride << 1));

    // ---------------- Indexed STORE offset (FIXED) ----------------

    wire [31:0] index_offset_store =
        (elem_cnt == 2'd0) ? vs2_index[31:0]   :
        (elem_cnt == 2'd1) ? vs2_index[63:32]  :
        (elem_cnt == 2'd2) ? vs2_index[95:64]  :
                             vs2_index[127:96];

    // ---------------- Address generation ----------------

    wire [31:0] curr_addr_w =
        (mop == 2'b00) ? (rs1_base_addr + {28'd0, addr_idx, 2'b00}) :
        (mop == 2'b10) ? (rs1_base_addr + stride_offset) :
        (mop == 2'b01) ? (rs1_base_addr + (is_store ? index_offset_store : index_offset_r)) : rs1_base_addr;

    // Address mux

    always @(is_store or mem_addr_r or curr_addr_w[31:0]) 
    begin
        mem_addr = is_store ? mem_addr_r : curr_addr_w[31:0];
    end

    // ---------------- Sequential ----------------

    always @(posedge clk or posedge reset) begin
        if (reset) 
        begin
            elem_cnt       <= 2'd0;
            elem_idx_r     <= 2'd0;
            mem_we         <= 1'b0;
            mem_addr_r     <= 32'd0;
            mem_wdata      <= 32'd0;
            vd_load        <= 128'd0;
            active         <= 1'b0;
            done           <= 1'b0;
            last_cycle     <= 1'b0;
            index_offset_r <= 32'd0;
        end 
        else 
        begin
            done   <= 1'b0;
            mem_we <= 1'b0;

            // -------- START --------

            if (start && !active) 
            begin
                active     <= 1'b1;
                elem_cnt   <= 2'd0;
                elem_idx_r <= 2'd0;
                last_cycle <= 1'b0;

            end

            // -------- ACTIVE --------

            if (active) begin

                // latch delayed index (LOAD only)

                elem_idx_r <= elem_cnt;

                // ---------------- STORE ----------------
                if (is_store) 
                begin
                    mem_we     <= 1'b1;
                    mem_addr_r <= curr_addr_w[31:0];
                    case (elem_cnt)
                        2'd0: mem_wdata <= vs3_store[31:0];
                        2'd1: mem_wdata <= vs3_store[63:32];
                        2'd2: mem_wdata <= vs3_store[95:64];
                        2'd3: mem_wdata <= vs3_store[127:96];
                    endcase
                end

                // ---------------- LOAD (UNCHANGED) ----------------

                if (is_load) 
                begin
                    case (elem_idx_r)
                        2'd0: vd_load[31:0]   <= mem_rdata;
                        2'd1: vd_load[63:32]  <= mem_rdata;
                        2'd2: vd_load[95:64]  <= mem_rdata;
                        2'd3: vd_load[127:96] <= mem_rdata;
                    endcase
                end


                if (elem_cnt == 2'd3) 
                begin
                    if (is_load && !last_cycle) 
                    begin
                        last_cycle <= 1'b1;
                    end 
                    else 
                    begin
                        active <= 1'b0;
                        done   <= 1'b1;
                    end
                end 
                else 
                begin
                    elem_cnt <= elem_cnt + 2'd1;

                    // prefetch indexed LOAD offsets only

                    if (mop == 2'b01) begin
                        case (elem_cnt)
                            2'd0: index_offset_r <= vs2_index[31:0];
                            2'd1: index_offset_r <= vs2_index[63:32];
                            2'd2: index_offset_r <= vs2_index[95:64];
                            2'd3: index_offset_r <= vs2_index[127:96];
                        endcase
                    end
                end
            end
        end
    end

endmodule


