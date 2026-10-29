module vector_lsu (
    input  wire         clk,
    input  wire         reset,

    input  wire         start,
    input  wire         is_load,
    input  wire         is_store,

    input  wire [1:0]   mop,            // 00=unit, 01=strided, 10=indexed
    input  wire [31:0]  rs1_base_addr,
    input  wire [31:0]  rs2_stride,
    input  wire [127:0] vs2_index,
    input  wire [127:0] vs3_store,

    output reg  [127:0] vd_load,
    output reg          busy,
    output reg          done
);

    // ---------------- Memory ----------------
    reg        mem_we;
    reg [11:0] mem_addr;
    reg [11:0] mem_addr_r;
    reg [31:0] mem_wdata;
    wire [31:0] mem_rdata;

    data_memory_top data_mem (
        .clk           (clk),
        .write_en      (mem_we),
        .read_address  (mem_addr[11:2]),
        .write_address (mem_addr),
        .data_in       (mem_wdata),
        .data_out      (mem_rdata)
    );

    // ---------------- Internal ----------------
    reg [1:0]  elem_cnt;
    reg [31:0] curr_addr;
    reg        active;
    reg        last_cycle;
    reg [31:0] index_offset_r;   // PREFETCHED index

    // ---------------- Address generation ----------------
    always @(*) begin
        case (mop)
            2'b00: curr_addr = rs1_base_addr + (elem_cnt << 2);
            2'b01: curr_addr = rs1_base_addr + (elem_cnt * rs2_stride);
            2'b10: curr_addr = rs1_base_addr + index_offset_r;
            default: curr_addr = rs1_base_addr;
        endcase
    end

    always @(*) begin
        mem_addr = is_store ? mem_addr_r : curr_addr[11:0];
    end

    // ---------------- Sequential ----------------
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            elem_cnt       <= 0;
            mem_we         <= 0;
            mem_addr_r     <= 0;
            mem_wdata      <= 0;
            vd_load        <= 0;
            active         <= 0;
            busy           <= 0;
            done           <= 0;
            last_cycle     <= 0;
            index_offset_r <= 0;
        end else begin
            done   <= 0;
            mem_we <= 0;

            // -------- START --------
            if (start && !active) begin
                active     <= 1;
                busy       <= 1;
                elem_cnt   <= 0;
                last_cycle <= 0;

                // PREFETCH index[0]
                if (mop == 2'b10)
                    index_offset_r <= vs2_index[0 +: 32];
            end

            // -------- ACTIVE --------
            if (active) begin

                // STORE
                if (is_store) begin
                    mem_we     <= 1;
                    mem_wdata  <= vs3_store[elem_cnt*32 +: 32];
                    mem_addr_r <= curr_addr[11:0];
                end

                // LOAD
                if (is_load) begin
                    vd_load[elem_cnt*32 +: 32] <= mem_rdata;
                end

                // CONTROL
                if (elem_cnt == 2'd3) begin
                    if (is_load && !last_cycle) begin
                        last_cycle <= 1;
                        elem_cnt   <= elem_cnt; // HOLD
                    end else begin
                        active <= 0;
                        busy   <= 0;
                        done   <= 1;
                    end
                end else begin
                    // ADVANCE ELEMENT
                    elem_cnt <= elem_cnt + 1;

                    // PREFETCH NEXT INDEX
                    if (mop == 2'b10)
                        index_offset_r <= vs2_index[(elem_cnt+1)*32 +: 32];
                end
            end
        end
    end

endmodule
