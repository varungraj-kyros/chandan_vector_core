module data_memory (

    input               clk,
    input               write_en,
    input      [31:0]   addr,
    input      [31:0]   write_data,
    output     [31:0]   read_data

);

///////////////////////////////////////////////////////////
// MEMORY
///////////////////////////////////////////////////////////

reg [7:0] mem [0:4095];

initial begin
	$readmemh("data_mem.hex", mem);
end

wire [11:0] addr_idx;
assign addr_idx = addr[11:0];

wire addr_valid;
assign addr_valid = (addr[31:12] == 20'd0);

///////////////////////////////////////////////////////////
// READ and WRITE 
///////////////////////////////////////////////////////////


assign read_data[7:0] = addr_valid ? mem[addr_idx] : 8'd0 ;
assign read_data[15:8] = addr_valid ? mem[addr_idx + 12'd1] : 8'd0 ;
assign read_data[23:16] = addr_valid ? mem[addr_idx + 12'd2] : 8'd0 ;
assign read_data[31:24] = addr_valid ? mem[addr_idx + 12'd3] : 8'd0 ;



    always @(posedge clk )
    begin
        if(write_en && addr_valid && addr_idx <= 12'd4092)
            begin
                 mem[addr_idx]     <= write_data[7:0];
                 mem[addr_idx + 12'd1] <= write_data[15:8];
                 mem[addr_idx + 12'd2] <= write_data[23:16];
                 mem[addr_idx + 12'd3] <= write_data[31:24];
            end
    end
endmodule



