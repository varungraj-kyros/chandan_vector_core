module sra_16_logic (

    input  wire [15:0] in_1,
    input  wire [3:0] in_2,
   // input  wire [2:0]  sew,

    output wire [15:0] sra_out

);

//wire [3:0] shamt;


/* shift amount select */

//assign shamt = in_2[3:0];//(sew == 3'b001) ? in_2[3:0] :  in_2[3:0];


/* stage wires */

wire [15:0] s0;
wire [15:0] s1;
wire [15:0] s2;
wire [15:0] s3;
wire [15:0] s4;


/* input mask (same style as 64 code) */

assign s0 =  in_1; // (sew == 3'b001) ? in_1 :  in_1;
                     

/* shift 1 */

assign s1 =  in_2[0] ? {s0[15], s0[15:1]} : s0;


/* shift 2 */

assign s2 = in_2[1] ? {{2{s1[15]}}, s1[15:2]} : s1;


/* shift 4 */

assign s3 = in_2[2] ? {{4{s2[15]}}, s2[15:4]} : s2;


/* shift 8 */

assign s4 = in_2[3] ? {{8{s3[15]}}, s3[15:8]} : s3;


/* output */

assign sra_out = s4;


endmodule


//`timescale 1ns/1ps
/*
module tb_sra_sew16;

reg  [15:0] in_1;
reg  [15:0] in_2;
//reg  [2:0]  sew;

wire [15:0] sra_out;


// DUT //

sra_16_logic dut (
    .in_1(in_1),
    .in_2(in_2),
   // .sew (sew),
    .sra_out (sra_out)
);


initial begin

    $display("---- SRA SEW16 TEST ----");


        // basic shift //
      // sew = 3'b001;

    in_1 = 16'hFFF0;   // -16
    in_2 = 16'h0002;   // shift 2

    #5;

    $display("test1 : in1=%h shift=%h sra_out=%h",
             in_1, in_2, sra_out);



        // positive //
   
    //sew = 3'b001;

    in_1 = 16'h0010;
    in_2 = 16'h0002;

    #5;

    $display("test2 : sra_out=%h", sra_out);



       // shift 1 //
   
    in_1 = 16'h8000;   // negative
    in_2 = 16'h0001;

    #5;

    $display("test3 : sra_out=%h", sra_out);



        // shift 4 //
       in_1 = 16'hF000;
    in_2 = 16'h0004;

    #5;

    $display("test4 : sra_out=%h", sra_out);



        // max shift //
       in_1 = 16'h8000;
    in_2 = 16'h000F;

    #5;

    $display("test5 : sra_out=%h", sra_out);



       // random //
      in_1 = 16'hA55A;
    in_2 = 16'h0003;

    #5;

    $display("test6 : sra_out=%h", sra_out);



    $finish;

end

endmodule*/
