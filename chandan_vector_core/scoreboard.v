module scoreboard (
    input         clk,
    input        reset,

    // Source & destination register indices

    input   [4:0]  vs1,
    input   [4:0]  vs2,
    input   [4:0]  vs3, //destination register

    // Instruction type

    input          is_vv,   // vector-vector
    input          is_vx,   // vector-scalar
    input          is_vi,   // vector-immediate

    // Reservation / release interface

    input          reserve_valid,
    input   [4:0]  reserve_vd,

    input          release_valid,
    input   [4:0]  release_vd,

    // To decode

    output         block_decode
);

    // -------------------------------------------------
    // Busy register file (1 bit per vector register)
    // -------------------------------------------------

    reg [31:0] busy;
    reg [31:0] busy_next;

    // -------------------------------------------------
    // NEXT-STATE LOGIC (combinational)
    // -------------------------------------------------

    always @(busy or release_valid or release_vd or
             reserve_valid or reserve_vd) 
        begin
        busy_next = busy;

        // RELEASE FIRST (older instruction completes)
        if (release_valid)
            busy_next[release_vd] = 1'b0;

        // RESERVE AFTER (new instruction issues)
        if (reserve_valid)
            busy_next[reserve_vd] = 1'b1;
    end

    // -----------------------------------wb_vector_we--
    // SEQUENTIAL STATE
    // -------------------------------------------------

    always @(posedge clk or posedge reset) begin
        if (reset)
            busy <= 32'b0;
        else
            busy <= busy_next;
    end

    // -------------------------------------------------
    // INTERNAL busy wires (USED INTERNALLY ONLY)
    // -------------------------------------------------
    wire vs1_busy_i;
    wire vs2_busy_i;
    wire vs3_busy_i;

    assign vs1_busy_i = busy[vs1];
    assign vs2_busy_i = busy[vs2];
    assign vs3_busy_i  = busy[vs3];

    // -------------------------------------------------
    // Decode hazard logic (pure combinational)
    // -------------------------------------------------

    assign block_decode =
        // Vector-Vector: reads vs1, vs2, writes vd
        (is_vv && (vs1_busy_i || vs2_busy_i || vs3_busy_i)) ||

        // Vector-Scalar: reads vs2, writes vd
        (is_vx && (vs2_busy_i || vs3_busy_i)) ||

        // Vector-Immediate: writes vd only
        (is_vi && vs3_busy_i);
endmodule


/*module scoreboard_tb;

    reg clk;
    reg reset;

    reg [4:0] vs1, vs2, vd;
    reg is_vv, is_vx, is_vi;

    reg reserve_valid;
    reg [4:0] reserve_vd;

    reg release_valid;
    reg [4:0] release_vd;

    wire block_decode;

    // Instantiate DUT
    scoreboard uut (
        .clk(clk),
        .reset(reset),
        .vs1(vs1),
        .vs2(vs2),
        .vd(vd),
        .is_vv(is_vv),
        .is_vx(is_vx),
        .is_vi(is_vi),
        .reserve_valid(reserve_valid),
        .reserve_vd(reserve_vd),
        .release_valid(release_valid),
        .release_vd(release_vd),
        .block_decode(block_decode)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        // Initialize inputs
        vs1 = 0; vs2 = 0; vd = 0;
        is_vv = 0; is_vx = 0; is_vi = 0;
        reserve_valid = 0; release_valid = 0;
        reserve_vd = 0; release_vd = 0;

        // Apply reset
        #10;
        reset = 0;

        // ----------------------------
        // Test 1: Reserve register 5
        // ----------------------------
        #10;
        reserve_valid = 1;
        reserve_vd = 5;

        #10;
        reserve_valid = 0;

        // ----------------------------
        // Test 2: Try to use same register (should block)
        // ----------------------------
        #10;
        vs1 = 5;
        vd  = 6;
        is_vv = 1;

        #10;

        // ----------------------------
        // Test 3: Release register 5
        // ----------------------------
        #10;
        is_vv = 0;
        release_valid = 1;
        release_vd = 5;

        #10;
        release_valid = 0;

        // ----------------------------
        // Test 4: Try again (should not block)
        // ----------------------------
        #10;
        is_vv = 1;

        #20;
        $finish;
    end
 initial begin
        $shm_open("scoreboard.shm");
        $shm_probe("ACTMF");
    end

endmodule*/


/*module tb_scoreboard;

    // ---------------- Clock / Reset ----------------
    reg clk;
    reg reset;

    // ---------------- DUT Inputs -------------------
    reg        reserve_valid;
    reg [4:0]  reserve_vd;

    reg        release_valid;
    reg [4:0]  release_vd;

    reg [4:0]  vs1;
    reg [4:0]  vs2;
    reg [4:0]  vd;

    // ---------------- DUT Outputs ------------------
  //  wire vs1_busy;
  //  wire vs2_busy;
  //  wire vd_busy;
    wire block_decode;

    // ---------------- Instantiate DUT --------------
    scoreboard dut (
        .clk(clk),
        .is_vv(is_vv),
        .is_vx(is_vx),
        .is_vi(is_vi),
        .reset(reset),
        .reserve_valid(reserve_valid),
        .reserve_vd(reserve_vd),
        .release_valid(release_valid),
        .release_vd(release_vd),
        .vs1(vs1),
        .vs2(vs2),
        .vd(vd),
     //   .vs1_busy(vs1_busy),
     //   .vs2_busy(vs2_busy),
     //   .vd_busy(vd_busy),
        .block_decode(block_decode)
    );

    // ---------------- Clock generation --------------
    always #5 clk = ~clk;   // 100 MHz

    // ---------------- Test sequence -----------------
    initial begin
        $display("===== SCOREBOARD TEST START =====");

        // Init
        clk = 0;
        reset = 1;

        reserve_valid = 0;
        release_valid = 0;
        reserve_vd = 5'd0;
        release_vd = 5'd0;

        vs1 = 5'd0;
        vs2 = 5'd0;
        vd  = 5'd0;

        // ---------------- Reset ----------------
        #10;
        reset = 0;

        // ==================================================
        // STEP 1: Reserve v5  (simulate issue of instr)
        // ==================================================
        @(posedge clk);
        reserve_valid = 1'b1;
        reserve_vd    = 5'd5;   // v5 RESERVED

        @(posedge clk);
        reserve_valid = 1'b0;

        // ==================================================
        // STEP 2: RAW hazard on vs1 (vs1 = v5)
        // ==================================================
        vs1 = 5'd5;
        vs2 = 5'd2;
        vd  = 5'd6;

        #1;
        $display("RAW vs1  | vs1_busy=%b vs2_busy=%b vd_busy=%b block=%b",
                  block_decode);

        // ==================================================
        // STEP 3: RAW hazard on vs2 (vs2 = v5)
        // ==================================================
        vs1 = 5'd1;
        vs2 = 5'd5;
        vd  = 5'd6;

        #1;
        $display("RAW vs2  | vs1_busy=%b vs2_busy=%b vd_busy=%b block=%b",
                  block_decode);

        // ==================================================
        // STEP 4: WAW hazard (vd = v5)
        // ==================================================
        vs1 = 5'd1;
        vs2 = 5'd2;
        vd  = 5'd5;

        #1;
        $display("WAW      | vs1_busy=%b vs2_busy=%b vd_busy=%b block=%b",
                  block_decode);

        // ==================================================
        // STEP 5: Release v5 (simulate writeback)
        // ==================================================
        @(posedge clk);
        release_valid = 1'b1;
        release_vd    = 5'd5;   // v5 RELEASED

        @(posedge clk);
        release_valid = 1'b0;

        // ==================================================
        // STEP 6: No hazard after release
        // ==================================================
        vs1 = 5'd5;
        vs2 = 5'd2;
        vd  = 5'd6;

        #1;
        $display("AFTER WB | vs1_busy=%b vs2_busy=%b vd_busy=%b block=%b",
                  block_decode);

        $display("===== SCOREBOARD TEST END =====");
        $finish;
    end

    initial begin
        $shm_open("scoreboard.shm");
        $shm_probe("ACTMF");
    end

endmodule*/

