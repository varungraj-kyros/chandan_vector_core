module vmsle_16_logic   #(
                            parameter N = 16
                        )
                        (
                                
                            input [N-1:0] in_1   ,
                            input [N-1:0] in_2   ,
                            output [N-1:0] vmsle_out     
                        )                           ;

                    assign vmsle_out = (in_1[N-1] ^ in_2[N-1]) ? {N{in_1[N-1]}} : ((in_1 <= in_2 ) ? {{N-1{1'b0}},{1'b1}} : {{N-1{1'b0}},{1'b0}}) ; 


endmodule
