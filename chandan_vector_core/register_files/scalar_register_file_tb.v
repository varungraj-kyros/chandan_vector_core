module scalar_register_tb ;

reg clk;
reg write_en;
reg [4:0] write_address;
reg [4:0] read_address_1;
reg [4:0] read_address_2;
reg [31:0] data_in;
wire [31:0] read_data_out_1;
wire [31:0] read_data_out_2;

scalar_register uut(.clk(clk),
                    .write_en(write_en),
                    .read_address_1(read_address_1),
                    .read_address_2(read_address_2),
                    .data_in(data_in),
                    .read_data_out_1(read_data_out_1),
                    .read_data_out_2(read_data_out_2)
                   );

initial 


clk =  1'b0 ;
always #5 clk = ~clk ;



initial 
begin

    write_en = 0;
    write_address = 5'd0;
    read_address_1 = 5'd0;
    read_address_2 = 5'd0;
    data_in = 32'd0;
#10

    write_en = 1;
    write_address = 5'd6;
    read_address_1 = 5'd2;
    read_address_2 = 5'd4;
    data_in = 32'd1;
#10;

 $finish;

end

initial 
begin
    $shm_open("scalar_reg.shm");
    $shm_probe("ACTMF");
end


endmodule
