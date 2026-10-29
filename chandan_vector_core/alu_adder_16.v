module adder_16_logic    #(
                 
                 parameter N = 16
             )
             (
                 input [N-1:0] in_1      ,
                 input [N-1:0] in_2      ,
                 input  cin ,
                 output [N-1:0] add_out  
             )                          ;

wire [N-2:0] g   ;
wire [N-2:0] p   ;
wire [N-2:0] c   ;


assign g[0]  =   in_1[0]  & in_2[0]    ;
assign g[1]  =   in_1[1]  & in_2[1]    ;
assign g[2]  =   in_1[2]  & in_2[2]    ;
assign g[3]  =   in_1[3]  & in_2[3]    ;
assign g[4]  =   in_1[4]  & in_2[4]    ;
assign g[5]  =   in_1[5]  & in_2[5]    ;
assign g[6]  =   in_1[6]  & in_2[6]    ;
assign g[7]  =   in_1[7]  & in_2[7]    ;
assign g[8]  =   in_1[8]  & in_2[8]    ;
assign g[9]  =   in_1[9]  & in_2[9]    ;
assign g[10] =   in_1[10] & in_2[10]   ;
assign g[11] =   in_1[11] & in_2[11]   ;
assign g[12] =   in_1[12] & in_2[12]   ;
assign g[13] =   in_1[13] & in_2[13]   ;
assign g[14] =   in_1[14] & in_2[14]   ;


assign p[0]  =   in_1[0] ^ in_2[0]    ;
assign p[1]  =   in_1[1] ^ in_2[1]    ;
assign p[2]  =   in_1[2] ^ in_2[2]    ;
assign p[3]  =   in_1[3] ^ in_2[3]    ;
assign p[4]  =   in_1[4] ^ in_2[4]    ;
assign p[5]  =   in_1[5] ^ in_2[5]    ;
assign p[6]  =   in_1[6] ^ in_2[6]    ;
assign p[7]  =   in_1[7] ^ in_2[7]    ;
assign p[8]  =   in_1[8] ^ in_2[8]    ;
assign p[9]  =   in_1[9] ^ in_2[9]    ;
assign p[10] =   in_1[10]^ in_2[10]   ;
assign p[11] =   in_1[11]^ in_2[11]   ;
assign p[12] =   in_1[12]^ in_2[12]   ;
assign p[13] =   in_1[13]^ in_2[13]   ;
assign p[14] =   in_1[14]^ in_2[14]   ;


assign c[0]     =   g[0]  | (p[0] & cin)   ;
assign c[1]     =   g[1]  | (p[1] & c[0])   ;
assign c[2]     =   g[2]  | (p[2] & c[1])   ;
assign c[3]     =   g[3]  | (p[3] & c[2])   ;
assign c[4]     =   g[4]  | (p[4] & c[3])   ;
assign c[5]     =   g[5]  | (p[5] & c[4])   ;
assign c[6]     =   g[6]  | (p[6] & c[5])   ;
assign c[7]     =   g[7]  | (p[7] & c[6])   ;
assign c[8]     =   g[8]  | (p[8] & c[7])   ;
assign c[9]     =   g[9]  | (p[9] & c[8])   ;
assign c[10]     =   g[10]  | (p[10] & c[9])  ;
assign c[11]     =   g[11]  | (p[11] & c[10])  ;
assign c[12]     =   g[12]  | (p[12] & c[11])   ;
assign c[13]     =   g[13]  | (p[13] & c[12])   ;
assign c[14]     =   g[14]  | (p[14] & c[13])   ;


assign add_out[0]   =   in_1[0] ^ in_2[0] ^ cin      ;
assign add_out[1]   =   in_1[1] ^ in_2[1] ^ c[0]    ;
assign add_out[2]   =   in_1[2] ^ in_2[2] ^ c[1]    ;
assign add_out[3]   =   in_1[3] ^ in_2[3] ^ c[2]    ;
assign add_out[4]   =   in_1[4] ^ in_2[4] ^ c[3]    ;
assign add_out[5]   =   in_1[5] ^ in_2[5] ^ c[4]    ;
assign add_out[6]   =   in_1[6] ^ in_2[6] ^ c[5]    ;
assign add_out[7]   =   in_1[7] ^ in_2[7] ^ c[6]    ;
assign add_out[8]   =   in_1[8] ^ in_2[8] ^ c[7]    ;
assign add_out[9]   =   in_1[9] ^ in_2[9] ^ c[8]    ;
assign add_out[10]   =   in_1[10] ^ in_2[10] ^ c[9]    ;
assign add_out[11]   =   in_1[11] ^ in_2[11] ^ c[10]    ;
assign add_out[12]   =   in_1[12] ^ in_2[12] ^ c[11]    ;
assign add_out[13]   =   in_1[13] ^ in_2[13] ^ c[12]    ;
assign add_out[14]   =   in_1[14] ^ in_2[14] ^ c[13]    ;
assign add_out[15]   =   in_1[15] ^ in_2[15] ^ c[14]    ;


endmodule
