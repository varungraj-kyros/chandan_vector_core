module xor_64_logic    #(
                        parameter N = 64
                    )
                    (
                        input [N-1:0] in_1       ,
                        input [N-1:0] in_2       ,
                        output [N-1:0] xor_out    
                    )                           ;

                    assign xor_out  =   in_1 ^ in_2 ;

endmodule
