module alu_top_32   #(
                      parameter N = 32
                  )
                  (
                        input              cin,clk, start_div, reset,start_mul    ,
                        input [N-1:0]      in_1                                   ,
                        input [N-1:0]      in_2                                   ,
                        input [2:0]        sew                                      ,
                        input [4:0]        alu_op                                   ,
                        output reg [N-1:0] alu_out ,
                        output             multi_32_done, div_32_done

                        );
wire mul_done;
wire div_done;
wire [N-1:0] temp ;
wire [N-1:0] add_out;
wire [N-1:0] and_out;
wire [N-1:0] or_out;
wire [N-1:0] xor_out;
wire [N-1:0] sll_out;
wire [N-1:0] srl_out;
wire [N-1:0] sra_out;
wire [N-1:0] vmseq_out;
wire [N-1:0] vmsne_out;
wire [N-1:0] vmsltu_out;
wire [N-1:0] vmslt_out;
wire [N-1:0] vmsleu_out;
wire [N-1:0] vmsle_out;
wire [N-1:0] minu_out;
wire [N-1:0] min_out;
wire [N-1:0] maxu_out;
wire [N-1:0] max_out;
wire [N-1:0] product;
wire [N-1:0] quotient;
wire [N-1:0] remainder;
wire [N-1:0] vmsgtu_out;
wire [N-1:0] vmsgt_out;
assign temp[0] = in_2[0] ^ cin ;
assign temp[1] = in_2[1] ^ cin ;
assign temp[2] = in_2[2] ^ cin ;
assign temp[3] = in_2[3] ^ cin ;
assign temp[4] = in_2[4] ^ cin ;
assign temp[5] = in_2[5] ^ cin ;
assign temp[6] = in_2[6] ^ cin ;
assign temp[7] = in_2[7] ^ cin ;
assign temp[8] = in_2[8] ^ cin ;
assign temp[9] = in_2[9] ^ cin ;
assign temp[10] = in_2[10] ^ cin ;
assign temp[11] = in_2[11] ^ cin ;
assign temp[12] = in_2[12] ^ cin ;
assign temp[13] = in_2[13] ^ cin ;
assign temp[14] = in_2[14] ^ cin ;
assign temp[15] = in_2[15] ^ cin ;
assign temp[16] = in_2[16] ^ cin ;
assign temp[17] = in_2[17] ^ cin ;
assign temp[18] = in_2[18] ^ cin ;
assign temp[19] = in_2[19] ^ cin ;
assign temp[20] = in_2[20] ^ cin ;
assign temp[21] = in_2[21] ^ cin ;
assign temp[22] = in_2[22] ^ cin ;
assign temp[23] = in_2[23] ^ cin ;
assign temp[24] = in_2[24] ^ cin ;
assign temp[25] = in_2[25] ^ cin ;
assign temp[26] = in_2[26] ^ cin ;
assign temp[27] = in_2[27] ^ cin ;
assign temp[28] = in_2[28] ^ cin ;
assign temp[29] = in_2[29] ^ cin ;
assign temp[30] = in_2[30] ^ cin ;
assign temp[31] = in_2[31] ^ cin ;




adder_32_logic add_instance 

                   (
                       .in_1(in_1),
                       .in_2(temp),
                       .cin(cin),
                       .add_out(add_out)
                   );

and_32_logic and_instance
                    (
                        .in_1(in_1),
                        .in_2(in_2),
                        .and_out(and_out)
                    );

or_32_logic or_instance 
                    (
                            .in_1(in_1),
                            .in_2(in_2),
                            .or_out(or_out)
                    );

xor_32_logic xor_instance 
                    (
                        .in_1(in_1),
                        .in_2(in_2),
                        .xor_out(xor_out)
                    );

sll_32_logic sll_instance 
                    (
                        .in_1(in_1),
                        .in_2(in_2[4:0]),
                        .sew(sew),
                        .sll_out(sll_out)
                    );

srl_32_logic srl_instance 
                    (
                        .in_1(in_1),
                        .in_2(in_2[4:0]),
                        .sew(sew),
                        .srl_out(srl_out)
                    );

sra_32_logic sra_instance 
                    (
                        .in_1(in_1),
                        .in_2(in_2[4:0]),
			.sew(sew),
                        .sra_out(sra_out)
                    );

vmseq_32_logic vmseq_instance 
                        (
                        .in_1(in_1),
                        .in_2(in_2),
                        .vmseq_out(vmseq_out)
                    );

vmsne_32_logic vmsne_instance
                            (
                                 .in_1(in_1),
                                 .in_2(in_2),
                                 .vmsne_out(vmsne_out)
                             );

vmsltu_32_logic vmsltu_instance 
                             (
                                  .in_1(in_1),
                                  .in_2(in_2),
                                  .vmsltu_out(vmsltu_out)
                              );

vmslt_32_logic vmslt_instance 
                            (
                                 .in_1(in_1),
                                 .in_2(in_2),
                                 .sew(sew),
                                 .vmslt_out(vmslt_out)
                             );

vmsleu_32_logic vmsleu_instance 
                            (
                                 .in_1(in_1),
                                 .in_2(in_2),
                                 .vmsleu_out(vmsleu_out)
                             );


vmsle_32_logic vmsle_instance 
                            (
                                 .in_1(in_1),
                                 .in_2(in_2),
                                 .sew(sew),
                                 .vmsle_out(vmsle_out)
                             );

vmsgtu_32_logic vmsgtu_instance 
                            (
                                 .in_1(in_1),
                                 .in_2(in_2),
                                 .vmsgtu_out(vmsgtu_out)
                             );
vmsgt_32_logic vmsgt_instance 
                            (
                                 .in_1(in_1),
                                 .in_2(in_2),
                                 .sew(sew),
                                 .vmsgt_out(vmsgt_out)
                             );



minu_32_logic minu_instance 
                            (
                                 .in_1(in_1),
                                 .in_2(in_2),
                                 .minu_out(minu_out)
                             );

min_32_logic min_instance 
                            (
                                 .in_1(in_1),
                                 .in_2(in_2),
                                 .sew(sew),
                                 .min_out(min_out)
                             );


maxu_32_logic maxu_instance 
                            (
                                 .in_1(in_1),
                                 .in_2(in_2),
                                 .maxu_out(maxu_out)
                             );

max_32_logic max_instance 
                            (
                                 .in_1(in_1),
                                 .in_2(in_2),
                                 .sew(sew),
                                 .max_out(max_out)
                             );


mul_32_logic mul_instance  
                            (
                                .M_in(in_1[15:0]),
                                .Q_in(in_2[15:0]),
                                .start_mul(start_mul),
                                .clk(clk),
                                .reset(reset),
                                .product(product),
                                .mul_done(mul_done)
                            );

div_32_logic div_instance 
                            (
                                .dividend(in_1),
                                .divisor(in_2),
                                .start(start_div),
                                .clk(clk),
                                .reset(reset),
                                .done(div_done),
                                .quotient(quotient),
                                .remainder(remainder)
                            );



always@(alu_op
         or add_out or and_out or or_out or xor_out
         or sll_out or srl_out or sra_out
         or vmseq_out or vmsne_out
         or vmsltu_out or vmslt_out
         or vmsleu_out or vmsle_out
         or minu_out or min_out
         or maxu_out or max_out
         or product 
         or quotient 
         or remainder 
         or vmsgtu_out or vmsgt_out)
begin

    case(alu_op)

        5'b00000:     alu_out     =       add_out;
        5'b00001:     alu_out     =       and_out;
        5'b00010:     alu_out     =       or_out;
        5'b00011:     alu_out     =       xor_out;
        5'b00100:     alu_out     =       sll_out;
        
        5'b00101:     alu_out     =       srl_out;
        5'b00110:     alu_out     =       sra_out;
        5'b00111:     alu_out     =       vmseq_out;
        5'b01000:     alu_out     =       vmsne_out;
        5'b01001:     alu_out     =       vmsltu_out;

        
        5'b01010:     alu_out     =       vmslt_out;
        5'b01011:     alu_out     =       vmsleu_out;
        5'b01100:     alu_out     =       vmsle_out;
        5'b01101:     alu_out     =       minu_out;
        5'b01110:     alu_out     =       min_out;
        
        5'b01111:     alu_out     =       maxu_out;
        5'b10000:     alu_out     =       max_out;
        5'b10001:     alu_out     =       product;

        5'b10100:     alu_out     =       quotient;
        5'b10101:     alu_out     =       remainder;
        5'b10111:     alu_out     =       vmsgtu_out;
        5'b11000:     alu_out     =       vmsgt_out;
        default   :     alu_out     =       32'd0;

    endcase

end

assign multi_32_done = mul_done;
assign div_32_done = div_done;
endmodule














     
     

