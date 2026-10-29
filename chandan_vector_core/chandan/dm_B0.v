module data_memory_B0  (
                        input clk                       ,
                        input write_en_B0               ,
                        input [9:0] read_address_B0     ,
                        input [9:0] write_address_B0    ,
                        input [7:0] data_in_B0          , 
                        output [7:0] data_out_B0        

                    )                                   ;

initial begin
    $readmemh("dm_B0.hex",mem_dm_B0)    ;
end

reg  [7:0] mem_dm_B0  [0:1023]          ;

always@(posedge clk)
begin

    if(write_en_B0)
        mem_dm_B0 [write_address_B0]   <=  data_in_B0   ;

end

assign data_out_B0                      =  mem_dm_B0 [read_address_B0]  ;



endmodule
