module alu_top_64   #(
                      parameter N = 64
                  )
                  (
                        input [N-1:0] in_1   ,
                        input [N-1:0] in_2   ,
                        input cin,clk,start_mul, reset ,start_div          ,
                        input [2:0]sew      ,
                        input [4:0] alu_op ,
                        output reg [N-1:0] alu_out ,
                        output  multi_64_done, div_64_done

                        );
wire div_done;
wire mul_done;
wire [N-1:0] temp;
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
assign temp[32] = in_2[32] ^ cin ;
assign temp[33] = in_2[33] ^ cin ;
assign temp[34] = in_2[34] ^ cin ;
assign temp[35] = in_2[35] ^ cin ;
assign temp[36] = in_2[36] ^ cin ;
assign temp[37] = in_2[37] ^ cin ;
assign temp[38] = in_2[38] ^ cin ;
assign temp[39] = in_2[39] ^ cin ;
assign temp[40] = in_2[40] ^ cin ;
assign temp[41] = in_2[41] ^ cin ;
assign temp[42] = in_2[42] ^ cin ;
assign temp[43] = in_2[43] ^ cin ;
assign temp[44] = in_2[44] ^ cin ;
assign temp[45] = in_2[45] ^ cin ;
assign temp[46] = in_2[46] ^ cin ;
assign temp[47] = in_2[47] ^ cin ;
assign temp[48] = in_2[48] ^ cin ;
assign temp[49] = in_2[49] ^ cin ;
assign temp[50] = in_2[50] ^ cin ;
assign temp[51] = in_2[51] ^ cin ;
assign temp[52] = in_2[52] ^ cin ;
assign temp[53] = in_2[53] ^ cin ;
assign temp[54] = in_2[54] ^ cin ;
assign temp[55] = in_2[55] ^ cin ;
assign temp[56] = in_2[56] ^ cin ;
assign temp[57] = in_2[57] ^ cin ;
assign temp[58] = in_2[58] ^ cin ;
assign temp[59] = in_2[59] ^ cin ;
assign temp[60] = in_2[60] ^ cin ;
assign temp[61] = in_2[61] ^ cin ;
assign temp[62] = in_2[62] ^ cin ;
assign temp[63] = in_2[63] ^ cin ;


adder_64_logic add_instance 

                           (
                                 .in_1(in_1),
                                 .in_2(temp),
                                 .cin(cin),
                                 .add_out(add_out)
                             );

and_64_logic and_instance
                           (
                                 .in_1(in_1),
                                 .in_2(in_2),
                                 .and_out(and_out)
                             );

or_64_logic or_instance 
                           (
                                 .in_1(in_1),
                                 .in_2(in_2),
                                 .or_out(or_out)
                             );

xor_64_logic xor_instance 
                           (
                                 .in_1(in_1),
                                 .in_2(in_2),
                                 .xor_out(xor_out)
                             );

sll_64_logic sll_instance 
                           (
                                 .in_1(in_1),
                                 .in_2(in_2[5:0]),
                                 .sew(sew),
                                 .sll_out(sll_out)
                             );

srl_64_logic srl_instance 
                            (
                                 .in_1(in_1),
                                 .in_2(in_2[5:0]),
                                 .sew(sew),
                                 .srl_out(srl_out)
                             );

sra_64_logic sra_instance 
                            (
                                 .in_1(in_1),
                                 .in_2(in_2[5:0]),
			                     .sew(sew),
                                 .sra_out(sra_out)
                             );

vmseq_64_logic vmseq_instance 
                            (
                                 .in_1(in_1),
                                 .in_2(in_2),
                                 .vmseq_out(vmseq_out)
                             );

vmsne_64_logic vmsne_instance
                            (
                                 .in_1(in_1),
                                 .in_2(in_2),
                                 .vmsne_out(vmsne_out)
                             );

vmsltu_64_logic vmsltu_instance 
                             (
                                  .in_1(in_1),
                                  .in_2(in_2),
                                  .vmsltu_out(vmsltu_out)
                              );

vmslt_64_logic vmslt_instance 
                            (
                                 .in_1(in_1),
                                 .in_2(in_2),
                                 .sew(sew),
                                 .vmslt_out(vmslt_out)
                             );

vmsleu_64_logic vmsleu_instance 
                            (
                                 .in_1(in_1),
                                 .in_2(in_2),
                                 .vmsleu_out(vmsleu_out)
                             );


vmsle_64_logic vmsle_instance 
                            (
                                 .in_1(in_1),
                                 .in_2(in_2),
                                 .sew(sew),
                                 .vmsle_out(vmsle_out)
                             );

vmsgtu_64_logic vmsgtu_instance 
                            (
                                 .in_1(in_1),
                                 .in_2(in_2),
                                 .vmsgtu_out(vmsgtu_out)
                             );
vmsgt_64_logic vmsgt_instance 
                            (
                                 .in_1(in_1),
                                 .in_2(in_2),
                                 .sew(sew),
                                 .vmsgt_out(vmsgt_out)
                             );



minu_64_logic minu_instance 
                            (
                                 .in_1(in_1),
                                 .in_2(in_2),
                                 .minu_out(minu_out)
                             );

min_64_logic min_instance 
                            (
                                 .in_1(in_1),
                                 .in_2(in_2),
                                 .sew(sew),
                                 .min_out(min_out)
                             );


maxu_64_logic maxu_instance 
                            (
                                 .in_1(in_1),
                                 .in_2(in_2),
                                 .maxu_out(maxu_out)
                             );

max_64_logic max_instance 
                            (
                                 .in_1(in_1),
                                 .in_2(in_2),
                                 .sew(sew),
                                 .max_out(max_out)
                             );

mul_64_logic mul_instance  
                            (
                                .M_in(in_1[31:0]),
                                .Q_in(in_2[31:0]),
                                .start_mul(start_mul),
                                .clk(clk),
                                .reset(reset),
                                .product(product),
                                .mul_done(mul_done)
                            );

div_64_logic div_instance 
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

        default   :     alu_out     =       64'd0;

    endcase

end

assign multi_64_done = mul_done;
assign div_64_done = div_done;
endmodule



