module 		instruction_mem_B2		(

							input 		clk 				,
							input 		reset				,
							input 		write_en_B2 			,
							input 	[7:0] 	data_in_B2 			,
							input 	[7:0] 	write_address_B2 		,	  
							input 	[7:0] 	read_address_B2 		,
							output 	[7:0] 	instruction_mem_out_B2 

						) 							;


initial begin
$readmemh("instruction_mem_B2.hex" ,instruction_memory_B2)				;
end


integer 	i 								;

reg 	[7:0] 	instruction_memory_B2 	[0:255] 				;

always@(posedge clk or posedge reset)
begin

if(reset)
begin
for(i=0; i<256 ; i= i+1 )
instruction_memory_B2[i] 		<= 		8'd0 				;
end

else if(write_en_B2)
instruction_memory_B2[write_address_B2] 	<=	data_in_B2 				;

end

assign  	instruction_mem_out_B2 	= 	instruction_memory_B2[read_address_B2] 	;

endmodule
       


