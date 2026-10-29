module   data_memory_top    (
                             input clk                   ,
                             input write_en              , 
                             input [9:0] read_address    ,
                             input [9:0] write_address   , 
                             input [31:0] data_in        ,
                             output [31:0] data_out
                         )                               ;

                         
wire [7:0] data_out_B0    ;
wire [7:0] data_out_B1    ;
wire [7:0] data_out_B2    ;
wire [7:0] data_out_B3    ;

assign data_out  = { data_out_B3  ,  data_out_B2   ,  data_out_B1  ,  data_out_B0 }  ;


data_memory_B0    mem_B0   (
                            .clk(clk)                        ,
                            .write_en_B0(write_en)           ,
                            .read_address_B0(read_address)   ,        
                            .write_address_B0(write_address) ,
                            .data_in_B0(data_in[7:0])        ,
                            .data_out_B0(data_out_B0)        
                            )                                ;


data_memory_B1    mem_B1   (
                            .clk(clk)                        ,
                            .write_en_B1(write_en)           ,
                            .read_address_B1(read_address)   ,        
                            .write_address_B1(write_address) ,
                            .data_in_B1(data_in[15:8])       ,
                            .data_out_B1(data_out_B1)        
                            )                                ;


data_memory_B2    mem_B2   (
                            .clk(clk)                        ,
                            .write_en_B2(write_en)           ,
                            .read_address_B2(read_address)   ,        
                            .write_address_B2(write_address) ,
                            .data_in_B2(data_in[23:16])      ,
                            .data_out_B2(data_out_B2)        
                            )                                ;


data_memory_B3    mem_B3   (
                            .clk(clk)                        ,
                            .write_en_B3(write_en)           ,
                            .read_address_B3(read_address)   ,        
                            .write_address_B3(write_address) ,
                            .data_in_B3(data_in[31:24])      ,
                            .data_out_B3(data_out_B3)        
                            )                                ;


endmodule
