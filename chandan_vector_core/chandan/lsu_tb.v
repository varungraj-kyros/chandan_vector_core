module tb_vector_lsu_all;

    // ---------------- CLOCK ----------------
    reg clk;
    always #5 clk = ~clk;

    // ---------------- DUT INPUTS ----------------
    reg reset;
    reg start;
    reg is_load;
    reg is_store;
    reg [1:0] mop;

    reg [31:0] rs1_base_addr;
    reg [31:0] rs2_stride;
    reg [127:0] vs2_index;
    reg [127:0] vs3_store;

    // ---------------- DUT OUTPUTS ----------------
    wire [127:0] vd_load;
    wire busy;
    wire done;

    // ---------------- DUT ----------------
    vector_lsu dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .is_load(is_load),
        .is_store(is_store),
        .mop(mop),
        .rs1_base_addr(rs1_base_addr),
        .rs2_stride(rs2_stride),
        .vs2_index(vs2_index),
        .vs3_store(vs3_store),
        .vd_load(vd_load),
        .busy(busy),
        .done(done)
    );

    // ---------------- MEMORY PRELOAD (for LOAD tests) ----------------
/*    initial begin
        // ---------- UNIT LOAD @100 ----------
        dut.data_mem.mem_dm_B0[100] = 8'h11;
        dut.data_mem.mem_dm_B1[100] = 8'h11;
        dut.data_mem.mem_dm_B2[100] = 8'h11;
        dut.data_mem.mem_dm_B3[100] = 8'h11;

        dut.data_mem.mem_dm_B0[104] = 8'h22;
        dut.data_mem.mem_dm_B1[104] = 8'h22;
        dut.data_mem.mem_dm_B2[104] = 8'h22;
        dut.data_mem.mem_dm_B3[104] = 8'h22;

        dut.data_mem.mem_dm_B0[108] = 8'h33;
        dut.data_mem.mem_dm_B1[108] = 8'h33;
        dut.data_mem.mem_dm_B2[108] = 8'h33;
        dut.data_mem.mem_dm_B3[108] = 8'h33;

        dut.data_mem.mem_dm_B0[112] = 8'h44;
        dut.data_mem.mem_dm_B1[112] = 8'h44;
        dut.data_mem.mem_dm_B2[112] = 8'h44;
        dut.data_mem.mem_dm_B3[112] = 8'h44;

        // ---------- STRIDED LOAD @200 stride=8 ----------
        dut.data_mem.mem_dm_B0[200] = 8'hAA;
        dut.data_mem.mem_dm_B1[200] = 8'hAA;
        dut.data_mem.mem_dm_B2[200] = 8'hAA;
        dut.data_mem.mem_dm_B3[200] = 8'hAA;

        dut.data_mem.mem_dm_B0[208] = 8'hBB;
        dut.data_mem.mem_dm_B1[208] = 8'hBB;
        dut.data_mem.mem_dm_B2[208] = 8'hBB;
        dut.data_mem.mem_dm_B3[208] = 8'hBB;

        dut.data_mem.mem_dm_B0[216] = 8'hCC;
        dut.data_mem.mem_dm_B1[216] = 8'hCC;
        dut.data_mem.mem_dm_B2[216] = 8'hCC;
        dut.data_mem.mem_dm_B3[216] = 8'hCC;

        dut.data_mem.mem_dm_B0[224] = 8'hDD;
        dut.data_mem.mem_dm_B1[224] = 8'hDD;
        dut.data_mem.mem_dm_B2[224] = 8'hDD;
        dut.data_mem.mem_dm_B3[224] = 8'hDD;

        // ---------- INDEXED LOAD @300 ----------
        dut.data_mem.mem_dm_B0[300] = 8'h10;
        dut.data_mem.mem_dm_B1[300] = 8'h10;
        dut.data_mem.mem_dm_B2[300] = 8'h10;
        dut.data_mem.mem_dm_B3[300] = 8'h10;

        dut.data_mem.mem_dm_B0[308] = 8'h20;
        dut.data_mem.mem_dm_B1[308] = 8'h20;
        dut.data_mem.mem_dm_B2[308] = 8'h20;
        dut.data_mem.mem_dm_B3[308] = 8'h20;

        dut.data_mem.mem_dm_B0[316] = 8'h30;
        dut.data_mem.mem_dm_B1[316] = 8'h30;
        dut.data_mem.mem_dm_B2[316] = 8'h30;
        dut.data_mem.mem_dm_B3[316] = 8'h30;

        dut.data_mem.mem_dm_B0[324] = 8'h40;
        dut.data_mem.mem_dm_B1[324] = 8'h40;
        dut.data_mem.mem_dm_B2[324] = 8'h40;
        dut.data_mem.mem_dm_B3[324] = 8'h40;
    end
*/
    // ---------------- TEST SEQUENCE ----------------
    initial begin
        // INIT
        clk = 0;
        reset = 1;
        start = 0;
        is_load = 0;
        is_store = 0;
        mop = 0;
        rs1_base_addr = 0;
        rs2_stride = 0;
        vs2_index = 0;
        vs3_store = 0;

        #20 reset = 0;

        // ==================================================
        // 1) UNIT LOAD
        // ==================================================
        $display("\n=== UNIT LOAD ===");
        @(posedge clk);
        rs1_base_addr =0000;
        mop = 2'b00;
        is_load = 1; start = 1;
        @(posedge clk) start = 0;
        wait(done); is_load = 0;
        $display("vd_load = %h", vd_load);

        // ==================================================
        // 2) UNIT STORE
        // ==================================================
        $display("\n=== UNIT STORE ===");
        @(posedge clk);
        rs1_base_addr = 0000;
        vs3_store = 128'h44444444_33333333_22222222_11111111;
        mop = 2'b00;
        is_store = 1; start = 1;
        @(posedge clk) start = 0;
        wait(done); is_store = 0;

       /* $display("Mem[400] = %h", {dut.data_mem.mem_dm_B3[400],
                                  dut.data_mem.mem_dm_B2[400],
                                  dut.data_mem.mem_dm_B1[400],
                                  dut.data_mem.mem_dm_B0[400]});
*/
        // ==================================================
        // 3) STRIDED LOAD
        // ==================================================
        $display("\n=== STRIDED LOAD ===");
        @(posedge clk);
        rs1_base_addr = 200;
        rs2_stride = 16;
        mop = 2'b01;
        is_load = 1; start = 1;
        @(posedge clk) start = 0;
        wait(done); is_load = 0;
        $display("vd_load = %h", vd_load);

        // ==================================================
        // 4) STRIDED STORE
        // ==================================================
        $display("\n=== STRIDED STORE ===");
        @(posedge clk);
        rs1_base_addr = 500;
        rs2_stride = 8;
        vs3_store = 128'hAAAAAAAA_BBBBBBBB_CCCCCCCC_DDDDDDDD;
        mop = 2'b01;
        is_store = 1; start = 1;
        @(posedge clk) start = 0;
        wait(done); is_store = 0;

       /* $display("Mem[500] = %h", {dut.data_mem.mem_dm_B3[500],
                                  dut.data_mem.mem_dm_B2[500],
                                  dut.data_mem.mem_dm_B1[500],
                                  dut.data_mem.mem_dm_B0[500]});
*/
        // ==================================================
        // 5) INDEXED LOAD
        // ==================================================
        $display("\n=== INDEXED LOAD ===");
        @(posedge clk);
        rs1_base_addr = 100;
        vs2_index = {32'd16,32'd8,32'd4,32'd0};
        mop = 2'b10;
        is_load = 1; start = 1;
        @(posedge clk) start = 0;
        wait(done); is_load = 0;
        $display("vd_load = %h", vd_load);

        // ==================================================
        // 6) INDEXED STORE
        // ==================================================
        $display("\n=== INDEXED STORE ===");
        @(posedge clk);
        rs1_base_addr = 600;
        vs2_index = {32'd24,32'd16,32'd8,32'd0};
        vs3_store = 128'h11112222_33334444_55556666_77778888;
        mop = 2'b10;
        is_store = 1; start = 1;
        @(posedge clk) start = 0;
        wait(done); is_store = 0;

        /*$display("Mem[600] = %h", {dut.data_mem.mem_dm_B3[600],
                                  dut.data_mem.mem_dm_B2[600],
                                  dut.data_mem.mem_dm_B1[600],
                                  dut.data_mem.mem_dm_B0[600]});
*/
        #20;
        $display("\n*** ALL LOAD & STORE TESTS COMPLETED ***");
        $finish;
    end
    initial begin
        $shm_open("lsu.shm");
        $shm_probe("ACTMF");
    end

endmodule

