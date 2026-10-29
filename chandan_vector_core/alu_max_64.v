module max_64_logic   #(
                            parameter N = 64
                        )
                        (
                                
                            input [N-1:0] in_1   ,
                            input [N-1:0] in_2   ,
				input [2:0] sew ,
                            output reg [N-1:0] max_out     
                        )                           ;

                        //wire sign;

                        //assign sign = in_1[63] ^ in_2[63];
                   //assign max_out = sign ? (in_1[63]?in_2:in_1) : ((in_1 > in_2) ? in_1 : in_2); 


always@(sew or in_1 or in_2)
begin

case(sew)

3'b001: max_out = in_1[15] ^ in_2[15] ? (in_1[15]? in_2: in_1) : ((in_1 > in_2) ? in_1 : in_2);
3'b010: max_out = in_1[31] ^ in_2[31] ? (in_1[31]? in_2: in_1) : ((in_1 > in_2) ? in_1 : in_2);
3'b011: max_out = in_1[63] ^ in_2[63] ? (in_1[63]? in_2: in_1) : ((in_1 > in_2) ? in_1 : in_2);
default: max_out = 64'd0 ;

endcase

end

endmodule

