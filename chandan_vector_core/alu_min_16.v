module min_16_logic   #(
                            parameter N = 16
                        )
                        (
                                
                            input [N-1:0] in_1   ,
                            input [N-1:0] in_2   ,
                            output [N-1:0] min_out     
                        )                           ;


                        wire sign;

                        assign sign = in_1[15] ^ in_2[15];
                   assign min_out = sign ? (in_1[15]?in_1:in_2) : ((in_2 < in_1) ? in_2 : in_1); 
endmodule

