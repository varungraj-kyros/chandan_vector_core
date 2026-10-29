module and_64_logic    #(
                        parameter N = 64
                    )
                    (
                        input [N-1:0] in_1       ,
                        input [N-1:0] in_2       ,
                        output [N-1:0]and_out    
                    )                           ;

                    assign and_out  =   in_1 & in_2 ;

endmodule
