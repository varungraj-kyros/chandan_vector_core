module xor_32_logic    #(
                        parameter N = 32
                    )
                    (
                        input [N-1:0] in_1       ,
                        input [N-1:0] in_2       ,
                        output [N-1:0] xor_out    
                    )                           ;

                    assign xor_out  =   in_1 ^ in_2 ;

endmodule
