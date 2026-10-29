module sll_32_logic #(
                
                parameter N = 32
)(
    input  [N-1:0] in_1,
    input  [4:0]   in_2,
    input  [2:0]   sew,      // 001 = 16-bit, 010 = 32-bit, 011 = 64-bit
    output [N-1:0] sll_out
);

assign sll_out = (sew == 3'b001) ? (in_1 << in_2[3:0]) :   // shift amount 0 to 15
                 (sew == 3'b010) ? (in_1 << in_2[4:0]) :   // shift amount 0 to 31
                 {N{1'b0}};              // default

endmodule


/*module sll_32_logic #(

                        parameter N = 32
                    )
                    (
                        input [N-1:0] in_1       ,
                        input [N-1:0] in_2       ,
                        output [N-1:0] sll_out    
                    )                           ;

                    assign sll_out  =   in_1 << in_2 ;

endmodule*/
