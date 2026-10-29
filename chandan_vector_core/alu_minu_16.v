module minu_16_logic   #(
                            parameter N = 16
                        )
                        (
                                
                            input [N-1:0] in_1   ,
                            input [N-1:0] in_2   ,
                            output [N-1:0] minu_out     
                        )                           ;

                   assign minu_out = (in_1 < in_2) ? in_1 : in_2 ;

endmodule

