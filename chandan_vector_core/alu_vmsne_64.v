module vmsne_64_logic   #(
                            parameter N = 64
                        )
                        (
                                
                            input [N-1:0] in_1   ,
                            input [N-1:0] in_2   ,
                            output [N-1:0] vmsne_out     
                        )                           ;

                   assign vmsne_out = (in_2 != in_1) ?  {{N-1{1'b0}},{1'b1}} : {{N-1{1'b0}},{1'b0}} ;


endmodule

