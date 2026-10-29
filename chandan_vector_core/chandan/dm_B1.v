module data_memory_B1  (
                        input clk                       ,
                        input write_en_B1               ,
                        input [9:0] read_address_B1     ,
                        input [9:0] write_address_B1    ,
                        input [7:0] data_in_B1          , 
                        output [7:0] data_out_B1        

                    )                                   ;

initial begin
    $readmemh("dm_B1.hex",mem_dm_B1)    ;
end

reg  [7:0] mem_dm_B1  [0:1023]          ;

always@(posedge clk)
begin

    if(write_en_B1)
        mem_dm_B1 [write_address_B1]   <=  data_in_B1   ;

end

assign data_out_B1                      =  mem_dm_B1 [read_address_B1]  ;



endmodule
