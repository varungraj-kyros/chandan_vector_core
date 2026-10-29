module sll_16_logic #(

                        parameter N = 16
                    )
                    (
                        input [N-1:0] in_1       ,
                        input [3:0] in_2       ,
                        output [N-1:0] sll_out    
                    )                           ;

                    assign sll_out  =   in_1 << in_2 ;

endmodule
