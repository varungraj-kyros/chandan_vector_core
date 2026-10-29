module sra_32_logic (

    input  wire [31:0] in_1,
    input  wire [4:0] in_2,
    input  wire [2:0]  sew,

    output wire [31:0] sra_out

);

wire [4:0] shamt;


/* shift amount */

assign shamt = (sew == 3'b001) ? {1'b0, in_2[3:0]} : in_2[4:0];



/* stage wires */

wire [31:0] s0;
wire [31:0] s1;
wire [31:0] s2;
wire [31:0] s3;
wire [31:0] s4;
wire [31:0] s5;


/* input mask */

assign s0 = (sew == 3'b001) ? {{16{in_1[15]}}, in_1[15:0]} : in_1;



/* shift 1 */

assign s1 = shamt[0] ? {s0[31], s0[31:1]} : s0;

/* shift 2 */

assign s2 = shamt[1] ? {{2{s1[31]}}, s1[31:2]} : s1;


/* shift 4 */

assign s3 = shamt[2] ? {{4{s2[31]}}, s2[31:4]} : s2;


/* shift 8 */

assign s4 = shamt[3] ? {{8{s3[31]}}, s3[31:8]} : s3;


/* shift 16 */

assign s5 = shamt[4] ? {{16{s4[31]}}, s4[31:16]} : s4;



/* sra_output mask */

assign sra_out = (sew == 3'b001) ? {{16{s5[15]}}, s5[15:0]} : s5;


endmodule


//`timescale 1ns/1ps

/*module tb_sra_sew32;

reg  [31:0] in_1;
reg  [31:0] in_2;
reg  [2:0]  sew;

wire [31:0] out;


// DUT //

sra_sew32 dut (
    .in_1(in_1),
    .in_2(in_2),
    .sew (sew),
    .out (out)
);


initial begin

    $display("---- SRA SEW32 TEST ----");


      // 16-bit test //
  
    sew = 3'b001;

    in_1 = 32'h0000_FFF0;   // -16 (16-bit)
    in_2 = 32'h0000_0002;   // shift 2

    #5;

    $display("16-bit  : in1=%h shift=%h out=%h",
             in_1, in_2, out);



       // 32-bit test //
    
    sew = 3'b010;

    in_1 = 32'hFFFFFFF0;   // -16 (32-bit)
    in_2 = 32'h00000003;   // shift 3

    #5;

    $display("32-bit  : in1=%h shift=%h out=%h",
             in_1, in_2, out);



       // 16-bit positive //
    
    sew = 3'b001;

    in_1 = 32'h0000_0010;
    in_2 = 32'h0000_0002;

    #5;

    $display("16-bit + : out=%h", out);



       // 32-bit positive //
    
    sew = 3'b010;

    in_1 = 32'h00000010;
    in_2 = 32'h00000004;

    #5;

    $display("32-bit + : out=%h", out);



       // sign extend test //
    

    sew = 3'b001;

    in_1 = 32'h0000_8000;  // negative 16-bit
    in_2 = 32'h0000_0001;

    #5;

    $display("16-bit sign : out=%h", out);



      // max shift //
        sew = 3'b010;

    in_1 = 32'h80000000;
    in_2 = 32'h00000010;

    #5;

    $display("32-bit max shift : out=%h", out);



    $finish;

end

endmodule*/
