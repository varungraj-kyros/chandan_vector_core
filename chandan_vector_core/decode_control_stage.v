module decode_control_stage (

    
    // From decode stage

    input          writes_vd,            // instruction writes a vector dest
    input   [4:0]  vs3,                  // destination vector register (vd)

    // -------------------------------
    // From scoreboard
    // -------------------------------

    input          block_decode,        // RAW / WAW hazard detected

    // -------------------------------
    // From LSU control
    // -------------------------------

    input          busy,                // LSU currently executing

    // -------------------------------
    // To execution / LSU control
    // ------------------------------
    
    output         ISSUE_REQ,           // instruction is allowed to issue

    // -------------------------------
    // To scoreboard
    // -------------------------------

    output reg         reserve_valid,
    output reg  [4:0]  reserve_vd,

    // -------------------------------
    // Pipeline stall controls
    // -------------------------------
    output wire        stall_IFID

   );

    // -------------------------------------------------
    // ISSUE decision
    // -------------------------------------------------

    wire ISSUE_REQ_INT ;
    assign ISSUE_REQ_INT = !block_decode&& !busy;
    assign ISSUE_REQ = ISSUE_REQ_INT ;

    // -------------------------------------------------
    // Pipeline stall logic (SINGLE SOURCE OF STALLS)
    // -------------------------------------------------

    assign stall_IFID = block_decode || busy;
    
    // -------------------------------------------------
    // Scoreboard reservation (only when instruction issues)
    // -------------------------------------------------

    always @(ISSUE_REQ_INT or writes_vd or vs3) begin
        reserve_valid = 1'b0;
        reserve_vd    = 5'd0;

        if (ISSUE_REQ_INT && writes_vd) begin
            reserve_valid = 1'b1;
            reserve_vd    = vs3;
        end
    end
endmodule


