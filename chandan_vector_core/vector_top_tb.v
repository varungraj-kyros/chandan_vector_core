module vector_top_tb;
reg clk;
reg reset;
reg [31:0]instruction_data_in;
reg [7:0] instruction_write_address;
reg instruction_write_en;
reg rst_inst_mem;
reg rst_scal_register_file;
reg rst_vector_register_file;
reg [4:0] scalar_write_address;
reg scalar_write_en;
reg [31:0] scalar_data_in;

wire [4:0] top_vector_address;
wire [127:0] top_vector_data;
wire top_vector_en ;
   
vector_top dut (
        .clk (clk),
        .reset (reset),
.instruction_data_in(instruction_data_in),
.instruction_write_address(instruction_write_address),
.instruction_write_en(instruction_write_en),
.rst_inst_mem(rst_inst_mem),
.rst_scal_register_file(rst_scal_register_file),
.rst_vector_register_file(rst_vector_register_file),
.top_vector_address(top_vector_address),
.top_vector_data(top_vector_data),
.top_vector_en(top_vector_en),
.scalar_write_address(scalar_write_address),
.scalar_write_en(scalar_write_en),
.scalar_data_in(scalar_data_in)
    );

initial
    clk = 0;
    always #5 clk = ~clk;
    
initial begin
rst_inst_mem=0;
rst_scal_register_file=0;
rst_vector_register_file=0;
instruction_data_in = 0;
instruction_write_address = 0;
instruction_write_en = 0;
scalar_write_address = 0;
scalar_write_en = 0;
scalar_data_in = 0;
end

    initial begin
        reset = 1'b1;
        #10;
        reset = 1'b0;

    end

    initial begin
    #6000;
	$finish;        
    end

    initial begin
        $shm_open("vector_top.shm");
        $shm_probe("ACTMF");
    end

endmodule

