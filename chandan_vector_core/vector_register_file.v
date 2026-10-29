module vector_register_file (
                        input clk,
		            	input reset,
                        input vector_write_en,
                        input [4:0] vector_write_address,
                        input [4:0] vs1_address,
                        input [4:0] vs2_address,
                        input [4:0] vs3_address,
                        input [127:0] vector_write_data_in,
                        output [127:0] vector_vs1_out,
                        output [127:0] vector_vs2_out,
                        output [127:0] vector_vs3_out,
                        output [7:0] vector_v0_out
                    );
                    
initial 
begin
    $readmemh ("vector_data.hex",vector_mem_reg) ;
end

integer i ;

reg [127:0] vector_mem_reg [0:31] ;

always@(posedge clk or posedge reset)
begin

if(reset)
begin

for(i=0;i<32;i=i+1)
vector_mem_reg[i] <= 128'd0 ;

end

else if(vector_write_en)
vector_mem_reg[vector_write_address] <= vector_write_data_in;
end

assign vector_vs1_out = vector_mem_reg [vs1_address] ;
assign vector_vs2_out = vector_mem_reg [vs2_address] ;
assign vector_vs3_out = vector_mem_reg [vs3_address] ;
assign vector_v0_out = vector_mem_reg[0][7:0];

endmodule


