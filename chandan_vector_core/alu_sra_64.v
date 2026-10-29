module sra_64_logic (

    input  wire [63:0] in_1,
    input  wire [5:0] in_2,
    input  wire [2:0]  sew,

    output wire [63:0] sra_out

);

wire [5:0] shamt;

/* shift amount select */

assign shamt =
    (sew == 3'b001) ? {2'b00, in_2[3:0]} :
    (sew == 3'b010) ? {1'b0 , in_2[4:0]} :
                      in_2[5:0];



/* stage wires */

wire [63:0] s0;
wire [63:0] s1;
wire [63:0] s2;
wire [63:0] s3;
wire [63:0] s4;
wire [63:0] s5;
wire [63:0] s6;


/* input mask based on sew */

assign s0 = (sew == 3'b001) ? {{48{in_1[15]}}, in_1[15:0]} :
    (sew == 3'b010) ? {{32{in_1[31]}}, in_1[31:0]} : in_1 ;
                    

/* shift 1 */

assign s1 =
    shamt[0] ? {s0[63], s0[63:1]} : s0;


/* shift 2 */

assign s2 =
    shamt[1] ?{{2{s1[63]}}, s1[63:2]} : s1;


/* shift 4 */

assign s3 =
    shamt[2] ?{{4{s2[63]}}, s2[63:4]} : s2;


/* shift 8 */

assign s4 =
    shamt[3] ?{{8{s3[63]}}, s3[63:8]} : s3;


/* shift 16 */

assign s5 =
    shamt[4] ? {{16{s4[63]}}, s4[63:16]} : s4;


/* shift 32 */

assign s6 =
    shamt[5] ? {{32{s5[63]}}, s5[63:32]} : s5;



/* output mask */

assign sra_out =
    (sew == 3'b001) ? {{48{s6[15]}}, s6[15:0]} :
    (sew == 3'b010) ? {{32{s6[31]}}, s6[31:0]} : s6;


endmodule



/*module tb_sra_sew;

reg  [63:0] in_1;
reg  [63:0] in_2;
reg  [2:0]  sew;

wire [63:0] out;


// DUT //

sra_sew dut (
    .in_1(in_1),
    .in_2(in_2),
    .sew (sew),
    .out (out)
);


initial begin

    $display("---- SRA TEST ----");


       // 16 bit test //
        sew = 3'b001;

    in_1 = 64'h0000_0000_0000_FFF0;  // -16 (16-bit)
    in_2 = 64'h0000_0000_0000_0002;  // shift 2

    #5;

    $display("16-bit : in1=%h shift=%h out=%h",
             in_1, in_2, out);



        // 32 bit test //
   
    sew = 3'b010;

    in_1 = 64'h0000_0000_FFFFFFF0;   // -16 (32-bit)
    in_2 = 64'h0000_0000_0000_0003;  // shift 3

    #5;

    $display("32-bit : in1=%h shift=%h out=%h",
             in_1, in_2, out);



       // 64 bit test //
       sew = 3'b011;

    in_1 = 64'hFFFFFFFFFFFFFFF0;   // -16 (64-bit)
    in_2 = 64'h0000000000000004;   // shift 4

    #5;

    $display("64-bit : in1=%h shift=%h out=%h",
             in_1, in_2, out);



   
    // 16-bit positive //
 
    sew = 3'b001;

    in_1 = 64'h0000_0000_0000_0010;
    in_2 = 64'h0000_0000_0000_0002;

    #5;

    $display("16-bit pos : %h", out);



      // random test //
  
    sew = 3'b011;

    in_1 = 64'h8000000000000000;
    in_2 = 64'h0000000000000001;

    #5;

    $display("64-bit neg : %h", out);


    $finish;

end

endmodule*/
