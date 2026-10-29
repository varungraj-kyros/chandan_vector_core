module alu_top (
                input         clk           , 
                input         reset         , 
                input         start_mul     , 
                input         start_div     ,
                input [127:0] in_1          ,
                input [127:0] in_2          ,
                input         cin           ,
		        input [2:0]   sew           ,
                input [4:0]   alu_op        ,

                output reg [127:0] alu_out  ,
                output mul_16_done_0,mul_16_done_1,mul_16_done_2,mul_16_done_3,mul_32_done_0, mul_32_done_1,mul_64_done_0, mul_64_done_1, 
                div_16_done_0,div_16_done_1,div_16_done_2, div_16_done_3, div_32_done_0, div_32_done_1, div_64_done_0,div_64_done_1

               );


wire [63:0]    alu_out_64_0 ;
wire [63:0]    alu_out_64_1 ;
wire [31:0]    alu_out_32_0 ;
wire [31:0]    alu_out_32_1 ;
wire [15:0]    alu_out_16_0 ;
wire [15:0]    alu_out_16_1 ;
wire [15:0]    alu_out_16_2 ;
wire [15:0]    alu_out_16_3 ;

reg [63:0] alu_64_0_in_1 ;
reg [63:0] alu_64_0_in_2 ;
reg [63:0] alu_64_1_in_1 ;
reg [63:0] alu_64_1_in_2 ;
reg [31:0] alu_32_0_in_1 ;
reg [31:0] alu_32_0_in_2 ;
reg [31:0] alu_32_1_in_1 ;
reg [31:0] alu_32_1_in_2 ;
reg [15:0] alu_16_0_in_1 ;
reg [15:0] alu_16_0_in_2 ;
reg [15:0] alu_16_1_in_1 ;
reg [15:0] alu_16_1_in_2 ;
reg [15:0] alu_16_2_in_1 ;
reg [15:0] alu_16_2_in_2 ;
reg [15:0] alu_16_3_in_1 ;
reg [15:0] alu_16_3_in_2 ;




alu_top_64 instance_64_0 (
                            .in_1(alu_64_0_in_1),
                            .in_2(alu_64_0_in_2),
                            .cin(cin),
                            .clk(clk),
                            .reset(reset),
                            .start_mul(start_mul),
                            .start_div(start_div),
                            .sew(sew),
                            .alu_op(alu_op),
                            .alu_out(alu_out_64_0),
                            .multi_64_done(mul_64_done_0),
                            .div_64_done(div_64_done_0)
                        );


alu_top_64 instance_64_1 (
                            .in_1(alu_64_1_in_1),
                            .in_2(alu_64_1_in_2 ),
                            .cin(cin),
                            .clk(clk),
                            .reset(reset),
                            .start_mul(start_mul),
                            .start_div(start_div),
                            .sew(sew),
                            .alu_op(alu_op),
                            .alu_out(alu_out_64_1),
                            .multi_64_done(mul_64_done_1),
                            .div_64_done(div_64_done_1)

                        );


alu_top_32 instance_32_0 (
                            .in_1(alu_32_0_in_1),
                            .in_2(alu_32_0_in_2),
                            .cin(cin),
                            .clk(clk),
                            .reset(reset),
                            .start_mul(start_mul),
                            .multi_32_done(mul_32_done_0),
                            .div_32_done(div_32_done_0),
                            .start_div(start_div),
                            .sew(sew),
                            .alu_op(alu_op),
                            .alu_out(alu_out_32_0)
                        );

alu_top_32 instance_32_1 (
                            .in_1(alu_32_1_in_1),
                            .in_2(alu_32_1_in_2),
                            .cin(cin),
                            .clk(clk),
                            .reset(reset),
                            .start_mul(start_mul),
                            .multi_32_done(mul_32_done_1),
                            .div_32_done(div_32_done_1),
                            .start_div(start_div),
                            .sew(sew),
                            .alu_op(alu_op),
                            .alu_out(alu_out_32_1)
                        );


alu_top_16 instance_16_0 (
                            .in_1(alu_16_0_in_1),
                            .in_2(alu_16_0_in_2),
                            .cin(cin),
                            .clk(clk),
                            .reset(reset),
                            .start_mul(start_mul),
                            .multi_16_done(mul_16_done_0),
                            .div_16_done(div_16_done_0),
                            .start_div(start_div),
                            .alu_op(alu_op),
                            .alu_out(alu_out_16_0)
                        );

alu_top_16 instance_16_1 (
                            .in_1(alu_16_1_in_1),
                            .in_2(alu_16_1_in_2),
                            .cin(cin),
                            .clk(clk),
                            .reset(reset),
                            .start_mul(start_mul),
                            .multi_16_done(mul_16_done_1),
                            .div_16_done(div_16_done_1),
                            .start_div(start_div),
                            .alu_op(alu_op),
                            .alu_out(alu_out_16_1)
                        );

alu_top_16 instance_16_2 (
                            .in_1(alu_16_2_in_1),
                            .in_2(alu_16_2_in_2),
                            .cin(cin),
                            .clk(clk),
                            .reset(reset),
                            .start_mul(start_mul),
                            .multi_16_done(mul_16_done_2),
                            .div_16_done(div_16_done_2),
                            .start_div(start_div),
                            .alu_op(alu_op),
                            .alu_out(alu_out_16_2)
                        );

alu_top_16 instance_16_3 (
                            .in_1(alu_16_3_in_1),
                            .in_2(alu_16_3_in_2),
                            .cin(cin),
                            .clk(clk),
                            .reset(reset),
                            .start_mul(start_mul),
                            .multi_16_done(mul_16_done_3),
                            .div_16_done(div_16_done_3),
                            .start_div(start_div),
                            .alu_op(alu_op),
                            .alu_out(alu_out_16_3)
                        );



always@(alu_out_16_3 or alu_out_16_2 or alu_out_16_1 or alu_out_16_0 or alu_out_32_1 or alu_out_32_0 or alu_out_64_1 or alu_out_64_0 or sew)
begin

    case(sew)

        3'b001:alu_out = { alu_out_16_3,alu_out_16_2,alu_out_16_1,alu_out_16_0,alu_out_32_1[15:0],alu_out_32_0[15:0],alu_out_64_1[15:0],alu_out_64_0[15:0] } ;
        3'b010:alu_out = { alu_out_32_1,alu_out_32_0,alu_out_64_1[31:0],alu_out_64_0[31:0] } ;
        3'b011:alu_out = { alu_out_64_1,alu_out_64_0 } ;
        default :alu_out = 128'd0 ;

    endcase
end

always@(sew or in_1 or in_2)
begin

    case(sew)
        3'b001:begin

alu_64_0_in_1 = {{48{in_1[15]}},in_1[15:0]} ;
alu_64_0_in_2 = {{48{in_2[15]}},in_2[15:0]} ;
alu_64_1_in_1 = {{48{in_1[31]}},in_1[31:16]} ;
alu_64_1_in_2 = {{48{in_2[31]}},in_2[31:16]} ;
alu_32_0_in_1 = {{16{in_1[47]}},in_1[47:32]} ;
alu_32_0_in_2 = {{16{in_2[47]}},in_2[47:32]} ;
alu_32_1_in_1 = {{16{in_1[63]}},in_1[63:48]} ;
alu_32_1_in_2 = {{16{in_2[63]}},in_2[63:48]} ;        
alu_16_0_in_1 = in_1[79:64] ;
alu_16_0_in_2 = in_2[79:64] ;
alu_16_1_in_1 = in_1[95:80] ;
alu_16_1_in_2 = in_2[95:80] ;
alu_16_2_in_1 = in_1[111:96] ;
alu_16_2_in_2 = in_2[111:96] ;
alu_16_3_in_1 = in_1[127:112] ;
alu_16_3_in_2 = in_2[127:112] ;

end

3'b010:begin

alu_64_0_in_1 = {{32{in_1[31]}},in_1[31:0]} ;
alu_64_0_in_2 = {{32{in_2[31]}},in_2[31:0]} ;
alu_64_1_in_1 = {{32{in_1[63]}},in_1[63:32]} ;
alu_64_1_in_2 = {{32{in_2[63]}},in_2[63:32]} ;
alu_32_0_in_1 = in_1[95:64] ;
alu_32_0_in_2 = in_2[95:64] ;
alu_32_1_in_1 = in_1[127:96] ;
alu_32_1_in_2 = in_2[127:96] ;
alu_16_0_in_1 = in_1[79:64] ;
alu_16_0_in_2 = in_2[79:64] ;
alu_16_1_in_1 = in_1[95:80] ;
alu_16_1_in_2 = in_2[95:80] ;
alu_16_2_in_1 = in_1[111:96] ;
alu_16_2_in_2 = in_2[111:96] ;
alu_16_3_in_1 = in_1[127:112] ;
alu_16_3_in_2 = in_2[127:112] ;

end

3'b011:begin

alu_64_0_in_1 = in_1[63:0] ;
alu_64_0_in_2 = in_2[63:0] ;
alu_64_1_in_1 = in_1[127:64] ;
alu_64_1_in_2 = in_2[127:64] ;
alu_32_0_in_1 = in_1[95:64] ;
alu_32_0_in_2 = in_2[95:64] ;
alu_32_1_in_1 = in_1[127:96] ;
alu_32_1_in_2 = in_2[127:96] ;
alu_16_0_in_1 = in_1[79:64] ;
alu_16_0_in_2 = in_2[79:64] ;
alu_16_1_in_1 = in_1[95:80] ;
alu_16_1_in_2 = in_2[95:80] ;
alu_16_2_in_1 = in_1[111:96] ;
alu_16_2_in_2 = in_2[111:96] ;
alu_16_3_in_1 = in_1[127:112] ;
alu_16_3_in_2 = in_2[127:112] ;

end

default: begin

alu_64_0_in_1 = 64'd0 ;
alu_64_0_in_2 = 64'd0 ;
alu_64_1_in_1 = 64'd0 ;
alu_64_1_in_2 = 64'd0 ;
alu_32_0_in_1 = 32'd0 ;
alu_32_0_in_2 = 32'd0 ;
alu_32_1_in_1 = 32'd0 ;
alu_32_1_in_2 = 32'd0 ;
alu_16_0_in_1 = 16'd0 ;
alu_16_0_in_2 = 16'd0 ;
alu_16_1_in_1 = 16'd0 ;
alu_16_1_in_2 = 16'd0 ;
alu_16_2_in_1 = 16'd0 ;
alu_16_2_in_2 = 16'd0 ;
alu_16_3_in_1 = 16'd0 ;
alu_16_3_in_2 = 16'd0 ;

end

endcase

end

endmodule




