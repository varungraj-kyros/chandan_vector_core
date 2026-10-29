module data_memory_B2  (
                        input clk                       ,
                        input write_en_B2               ,
                        input [9:0] read_address_B2     ,
                        input [9:0] write_address_B2    ,
                        input [7:0] data_in_B2          , 
                        output [7:0] data_out_B2        

                    )                                   ;

initial begin
    $readmemh("dm_B2.hex",mem_dm_B2)    ;
end

reg  [7:0] mem_dm_B2  [0:1023]          ;

always@(posedge clk)
begin

    if(write_en_B2)
        mem_dm_B2 [write_address_B2]   <=  data_in_B2   ;

end

assign data_out_B2                      =  mem_dm_B2 [read_address_B2]  ;



endmodule
