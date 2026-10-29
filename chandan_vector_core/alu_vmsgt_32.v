module vmsgt_32_logic   #(
                            parameter N = 32
                        )
                        (
                                
                            input [N-1:0] in_1   ,
                            input [N-1:0] in_2   ,
                            input [2:0] sew      ,
                            output reg [N-1:0] vmsgt_out     
                        )                           ;

                     // assign vmsgt_out = (in_1[N-1] ^ in_2[N-1]) ? {N{~in_1[N-1]}} : ((in_1 > in_2 ) ? {N{1'b1}} : {N{1'b0}}) ; 
always@(sew or in_1 or in_2)
begin

case(sew)

3'b001: vmsgt_out = (in_1[15] ^ in_2[15]) ? {{31{1'b0}},{{~in_1[15]}}} : ((in_1 > in_2 ) ?{{31{1'b0}},{1'b1}} : {{31{1'b0}},{1'b0}});
3'b010: vmsgt_out = (in_1[31] ^ in_2[31]) ? {{31{1'b0}},{{~in_1[31]}}} : ((in_1 > in_2 ) ?{{31{1'b0}},{1'b1}} : {{31{1'b0}},{1'b0}});
//3'b011: vmsgt_out = (in_1[63] ^ in_2[63]) ? {{63{1'b0}},{{~in_1[63]}}} : ((in_1 > in_2 ) ?{{63{1'b0}},{1'b1}} : {{63{1'b0}},{1'b0}});
default: vmsgt_out = 32'd0 ;

endcase

end

endmodule

