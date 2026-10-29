module vector_register_tb ;

reg clk;
reg vector_write_en ;
reg [4:0] vector_write_address ;
reg [4:0] vs1_address ;
reg [4:0] vs2_address ;
reg [4:0] vs3_address ;
reg [127:0] vector_write_data_in ;
wire [127:0] vector_vs1_out ;
wire [127:0] vector_vs2_out ;
wire [127:0] vector_vs3_out ;


vector_register uut(.clk(clk),
                    .vector_write_en(vector_write_en),
                    .vector_write_address(vector_write_address),
                    .vs1_address(vs1_address),
                    .vs2_address(vs2_address),
                    .vs3_address(vs3_address),
                    .vector_write_data_in(vector_write_data_in),
                    .vector_vs1_out(vector_vs1_out),
                    .vector_vs2_out(vector_vs2_out),
                    .vector_vs3_out(vector_vs3_out)
                ) ;

initial 

    clk = 1'b0;
    always #5 clk = ~clk ;


initial begin

       vector_write_en        =     0      ;  
       vector_write_address   =     5'd0   ;    
       vs1_address            =     5'd0   ;
       vs2_address            =     5'd0   ;
       vs3_address            =     5'd0   ;
       vector_write_data_in   =     128'd0 ;

#10;
       
       vector_write_en        =     1       ; 
       vector_write_address   =     5'd31   ;  
       vs1_address            =     5'd30   ;
       vs2_address            =     5'd29   ;
       vs3_address            =     5'd28   ;
       vector_write_data_in   =     128'd10 ;

#10; $finish;

end

initial
begin
    
    $shm_open("vector_register.shm");
    $shm_probe("ACTMF");

end


endmodule
      

