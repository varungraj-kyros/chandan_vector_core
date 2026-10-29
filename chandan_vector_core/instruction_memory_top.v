module 		instruction_memory_top		(

							input 		clk 				,
							input 		reset 				,
							input 		write_en 			,
							input 	[31:0] 	data_in 			,
							input 	[7:0] 	read_address 			,
							input 	[7:0] 	write_address 			,
							output 	[31:0] 	instr	

						) 							;

wire 	[7:0] 	instruction_mem_out_B0 	;
wire 	[7:0] 	instruction_mem_out_B1 	;
wire 	[7:0] 	instruction_mem_out_B2 	;
wire 	[7:0] 	instruction_mem_out_B3 	;


assign 	instr 	= { instruction_mem_out_B3, instruction_mem_out_B2 ,instruction_mem_out_B1 ,instruction_mem_out_B0 } 	;



instruction_mem_B0 		instruction_mem_B0_instance 		(

										.clk(clk) 						,
										.reset(reset) 						,
										.write_en_B0(write_en) 					,
										.write_address_B0(write_address) 				,
										.data_in_B0(data_in[7:0]) 					,
										.read_address_B0(read_address) 				,
										.instruction_mem_out_B0(instruction_mem_out_B0)

									) 								;


instruction_mem_B1 		instruction_mem_B1_instance 		(

										.clk(clk) 						,
										.reset(reset) 						,
										.write_en_B1(write_en) 					,
										.write_address_B1(write_address) 				,
										.data_in_B1(data_in[15:8]) 				,
										.read_address_B1(read_address) 				,
										.instruction_mem_out_B1(instruction_mem_out_B1)

									) 								;


instruction_mem_B2 		instruction_mem_B2_instance 		(

										.clk(clk) 						,
										.reset(reset) 						,
										.write_en_B2(write_en) 					,
										.write_address_B2(write_address) 				,
										.data_in_B2(data_in[23:16]) 				,
										.read_address_B2(read_address) 				,
										.instruction_mem_out_B2(instruction_mem_out_B2)

									) 								;


instruction_mem_B3 		instruction_mem_B3_instance 		(

										.clk(clk) 						,
										.reset(reset) 						,
										.write_en_B3(write_en) 					,
										.write_address_B3(write_address) 				,
										.data_in_B3(data_in[31:24]) 				,
										.read_address_B3(read_address) 				,
										.instruction_mem_out_B3(instruction_mem_out_B3)

									) 								;
endmodule





/*
module tb_instruction_memory_top;

    reg  [8:0] addr;
    wire [31:0] instr;

    // DUT
    instruction_memory_top dut (
        .addr(addr),
        .instr(instr)
    );

    initial begin
        // Monitor output
        $monitor("TIME=%0t | addr=%0d | instr=%h",
                  $time, addr, instr);

        // Apply addresses
        addr = 0;
        #10;

        addr = 1;
        #10;

        addr = 2;
        #10;

        addr = 3;
        #10;

        addr = 4;
        #10;

        addr = 5;
        #10;

        // Jump address
        addr = 10;
        #10;

        addr = 20;
        #10;

        $finish;
    end

    initial begin
    $shm_open("instruction_memory_top.shm");
    $shm_probe("ACTMF");
end


endmodule

*/
