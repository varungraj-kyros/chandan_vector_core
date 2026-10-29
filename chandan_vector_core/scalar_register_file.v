module scalar_register_file (
                        input clk,
                        input write_en,
			            input reset,
                        input [4:0] write_address,
                        input [4:0] read_address_1,
                        input [4:0] read_address_2, 
                        input [31:0] data_in,
                        output [31:0] read_data_out_1,
                        output [31:0] read_data_out_2
                        );
                        
initial
begin
   $readmemh ("data.hex",mem_reg) ;   
end

integer i;

reg [31:0] mem_reg [0:31] ;

always@(posedge clk or posedge reset)
begin
    if(reset)
    begin
	for(i=0;i<32;i=i+1)
	mem_reg[i] <= 32'd0;
    end

else if (write_en)
mem_reg[write_address] <= data_in ;
end

assign read_data_out_1 =  mem_reg [read_address_1];
assign read_data_out_2 =  mem_reg [read_address_2];

endmodule
