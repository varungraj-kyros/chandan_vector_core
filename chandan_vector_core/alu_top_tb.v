module alu_top_tb;

reg [127:0] in_1;
reg [127:0] in_2;
reg cin, clk, start_mul, start_div, reset;
reg [2:0]sew;
reg [4:0]alu_op;
wire [127:0]alu_out;
wire mul_16_done_0,mul_16_done_1,mul_16_done_2,mul_16_done_3,mul_32_done_0, mul_32_done_1,mul_64_done_0, mul_64_done_1, div_16_done_0,div_16_done_1,div_16_done_2, div_16_done_3, div_32_done_0, div_32_done_1, div_64_done_0,div_64_done_1;

alu_top uut(.in_1(in_1),.in_2(in_2),.cin(cin),.sew(sew),.alu_op(alu_op),.clk(clk),.start_mul(start_mul),.start_div(start_div),.reset(reset),.alu_out(alu_out),.mul_16_done_0(mul_16_done_0),.mul_16_done_1(mul_16_done_1),.mul_16_done_2(mul_16_done_2),.mul_16_done_3(mul_16_done_3),.mul_32_done_0(mul_32_done_0),.mul_32_done_1(mul_32_done_1),.mul_64_done_0(mul_64_done_0),.mul_64_done_1(mul_64_done_1),.div_16_done_0(div_16_done_0),.div_16_done_1(div_16_done_1),.div_16_done_2(div_16_done_2),.div_16_done_3(div_16_done_3),.div_32_done_0(div_32_done_0),.div_32_done_1(div_32_done_1),.div_64_done_0(div_64_done_0),.div_64_done_1(div_64_done_1));


initial
    clk =1'b0;

always #5 clk = ~clk;

initial begin
    reset = 1'b1;
    //start_div = 1'b1;

#10;
    reset = 1'b0;
  //start_div = 1'b1;
//#10;
  //  start_div = 1'b0;
//initial begin
    in_1 = 128'h00000000_00000000_FF00FF00_FF00FF00;    
    in_2 = 128'h00000000_000000fa_0F0F0F0F_0F0F0F0F;
 //   end 
//initial begin
    
     sew = 3'b011;
     alu_op = 5'b00001;
     cin = 0;
 //    start_div = 1'b1;
#10;
//start_div =1'b0;
     /*
#10;

     sew = 3'b001;
     alu_op = 5'b00000;
     cin = 1;
#10;*/
/*
     sew = 3'b011;
     alu_op = 5'b00001;
     cin = 0;
#10;

     sew = 3'b011;
     alu_op = 5'b00010;
     cin = 0;
#10;

     sew = 3'b011;
     alu_op = 5'b00011;
     cin = 0;
#10;

     sew = 3'b011;
     alu_op = 5'b00100;
     cin = 0;
#10;

     sew = 3'b011;
     alu_op = 5'b00101;
     cin = 0;
#10;

     sew = 3'b011;
     alu_op = 5'b00110;
     cin = 0;
#10

     sew = 3'b011;
     alu_op = 5'b00111;
     cin = 0;
#10;

     sew = 3'b011;
     alu_op = 5'b01000;
     cin = 0;
#10;
     sew = 3'b011;
     alu_op = 5'b01001;
     cin = 0;
#10;

     sew = 3'b011;
     alu_op = 5'b01010;
     cin = 0;
#10;

     sew = 3'b011;
     alu_op = 5'b01011;
     cin = 0;
#10;

     sew = 3'b011;
     alu_op = 5'b01100;
     cin = 0;
#10;

     sew = 3'b011;
     alu_op = 5'b01101;
     cin = 0;
#10;

     sew = 3'b011;
     alu_op = 5'b01110;
     cin = 0;
#10;

     sew = 3'b011;
     alu_op = 5'b01111;
     cin = 0;
#10;
     sew = 3'b011;
     alu_op = 5'b10000;
     cin = 0;
#10;
     start_mul = 1'b1;
     sew = 3'b001;
     alu_op = 5'b10001;
     cin = 0;
     
#10;
//done = 1'b1;
     start_mul = 1'b0;

   //  sew = 3'b011;
    // alu_op = 5'b10010;
     //cin = 0;
//#10;

     sew = 3'b011;
     alu_op = 5'b10011;
     cin = 0;
#10;

     sew = 3'b011;
     alu_op = 5'b10100;
     cin = 0;
#10;

     sew = 3'b011;
     alu_op = 5'b10101;
     cin = 0;
#10;

     sew = 3'b011;
     alu_op = 5'b10110;
     cin = 0;
#10;

     sew = 3'b011;
     alu_op = 5'b10111;
     cin = 0;
#10;

     sew = 3'b011;
     alu_op = 5'b11000;
     cin = 0;
*/
#2000;
$finish;
end

initial begin
    $shm_open("alu_top.shm");
    $shm_probe("ACTMF");
end


endmodule


