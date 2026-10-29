module data_memory_B3  (
                        input clk                       ,
                        input write_en_B3               ,
                        input [9:0] read_address_B3     ,
                        input [9:0] write_address_B3    ,
                        input [7:0] data_in_B3          , 
                        output [7:0] data_out_B3        

                    )                                   ;

initial begin
    $readmemh("dm_B3.hex",mem_dm_B3)    ;
end

reg  [7:0] mem_dm_B3  [0:1023]          ;

always@(posedge clk)
begin

    if(write_en_B3)
        mem_dm_B3 [write_address_B3]   <=  data_in_B3   ;

end

assign data_out_B3                      =  mem_dm_B3  [read_address_B3]  ;



endmodule
