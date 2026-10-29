module max_16_logic   #(
                            parameter N = 16
                        )
                        (
                                
                            input [N-1:0] in_1   ,
                            input [N-1:0] in_2   ,
                            output [N-1:0] max_out     
                        )                           ;


                        wire sign;

                        assign sign = in_1[15] ^ in_2[15];
                   assign max_out = sign ? (in_1[15]?in_2:in_1) : ((in_1 > in_2) ? in_1 : in_2); 


endmodule

