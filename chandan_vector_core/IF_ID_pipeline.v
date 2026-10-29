module IF_ID_pipeline (
    input               clk,
    input               reset,
    input               stall_IFID,
    input      [31:0]   instruction,
    output reg [31:0]   IF_ID_instruction
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            IF_ID_instruction <= 32'd0;
        else if (!stall_IFID)
            IF_ID_instruction <= instruction;
        // else: HOLD previous instruction
    end

endmodule


/*
module IF_ID_pipeline_tb;

    reg clk;
    reg reset;
    reg stall_IFID;
    reg [31:0] instruction;
    wire [31:0] IF_ID_instruction;

    // Instantiate DUT
    IF_ID_pipeline uut (
        .clk(clk),
        .reset(reset),
        .stall_IFID(stall_IFID),
        .instruction(instruction),
        .IF_ID_instruction(IF_ID_instruction)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0;
        reset = 1;
        stall_IFID = 0;
        instruction = 32'h00000000;

        // Apply reset
        #10;
        reset = 0;

        // Normal operation
        #10 instruction = 32'h11111111;
        #10 instruction = 32'h22222222;

        // Apply stall (should HOLD 22222222)
        #10 stall_IFID = 1;
        instruction = 32'h33333333;

        #20 stall_IFID = 0;  // Release stall

        // New instruction after stall
        #10 instruction = 32'h44444444;

        #20;
        $finish;
    end
initial begin
        $shm_open("IF_ID_pipeline.shm");
        $shm_probe("ACTMF");
    end

endmodule*/
