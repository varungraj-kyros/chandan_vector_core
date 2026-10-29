module if_stage (
    input          clk,
    input          reset,
    input          rst_inst_mem ,
    input          stall_IFID,
    input  [31:0]  data_in,
    input          write_en,
    input  [7:0]   write_address,


    output  [31:0] IF_ID_instruction
);

    wire [9:0] pc_current;
    wire [9:0] pc_next;
    wire [31:0] instruction;
    

    pc_adder pc_adder_inst (
        .in_1  (pc_current),
        .in_2  (10'd4) ,
	.pc_add_out(pc_next)
    );

    pc_unit pc_unit_inst (
        .clk        (clk),
        .reset      (reset),
        .stall_IFID (stall_IFID),
        .pc_in      (pc_next),
        .pc_out     (pc_current)
    );


instruction_memory_top imem_inst (
    .clk           (clk),
    .reset         (rst_inst_mem),
    .write_en      (write_en),        // IF stage does not write
    .data_in       (data_in),       // unused
    .read_address  (pc_current[9:2]),
    .write_address (write_address),        // unused
    .instr         (instruction)
);
    IF_ID_pipeline if_id_inst (
        .clk              (clk),
        .reset            (reset),
        .stall_IFID       (stall_IFID),
        .instruction      (instruction),
        .IF_ID_instruction(IF_ID_instruction)
    );

endmodule



/*module if_stage_tb;

    // -------------------------
    // TB signals
    // -------------------------
    reg         clk;
    reg         reset;
    reg         stall_IFID;
    reg         rst_inst_mem;

    wire [31:0] IF_ID_instruction;

    // -------------------------
    // DUT
    // -------------------------
    if_stage dut (
        .clk               (clk),
        .reset               (reset),
        .stall_IFID        (stall_IFID),
        .IF_ID_instruction (IF_ID_instruction),
        .rst_inst_mem       (rst_inst_mem)
    );

    // -------------------------
    // Clock: 10 ns period
    // -------------------------
    always #5 clk = ~clk;

    // -------------------------
    // Stimulus
    // -------------------------
    initial begin
        clk        = 0;
        rst_inst_mem = 0;

        reset        = 1;
        stall_IFID = 0;

        // Hold reset
        #10;
        reset = 0;
        //rst_inst_mem = 0;


        // Normal fetch
        #40;

        // Stall pipeline
        stall_IFID = 1;
        #30;

        // Resume
        stall_IFID = 0;
        #40;

        $finish;
    end

    // -------------------------
    // Monitor (peek internal PC)
    // -------------------------
    initial begin
        $monitor(
            "T=%0t | reset=%b stall=%b | PC=%0d | IF/ID Instr=0x%08h",
            $time,
            reset,
            stall_IFID,
            dut.pc_current,     // hierarchical access
            IF_ID_instruction
        );
    end

    initial begin
        $shm_open("if_stage.shm");
        $shm_probe("ACTMF");
    end

endmodule*/

