module min_32_logic   #(
                            parameter N = 32
                        )
                        (
                                
                            input [N-1:0] in_1   ,
                            input [N-1:0] in_2   ,
                            input [2:0] sew      ,
                            output reg [N-1:0] min_out     
                        )                           ;

              
always@(sew or in_1 or in_2)
begin

case(sew)

3'b001: min_out = in_1[15] ^ in_2[15] ? (in_1[15]? in_1: in_2) : ((in_2 < in_1) ? in_2 : in_1);
3'b010: min_out = in_1[31] ^ in_2[31] ? (in_1[31]? in_1: in_2) : ((in_2 < in_1) ? in_2 : in_1);
//3'b011: min_out = in_1[63] ^ in_2[63] ? (in_1[63]? in_1: in_2) : ((in_2 > in_1) ? in_2 : in_1);
default: min_out = 32'd0 ;

endcase

end

endmodule

