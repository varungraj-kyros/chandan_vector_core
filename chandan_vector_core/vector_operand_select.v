module vector_operand_select (

    input   [31:0]  rs1_data,
    input   [127:0] vs1_data,
    input   [127:0] vs2_data,
    input   [4:0]  imm,
    input   [2:0] sew,
    input   is_vv,
    input   is_vx,
    input   is_vi,

    output reg [127:0] alu_in1,
    output reg [127:0] alu_in2

);

reg [127:0] scalar_expand;
reg [127:0] imm_expand;
wire [31:0] immediate ;

    assign immediate = {{27{imm[4]}},imm} ;

    always @(is_vv or is_vx or is_vi or sew or vs1_data or vs2_data or rs1_data or immediate) 
    begin

    alu_in1 = 128'd0;
    alu_in2 = 128'd0;
    scalar_expand = 128'd0;
    imm_expand = 128'd0;

        case(sew)

        3'b001: // SEW = 16
        begin 
        scalar_expand = {8{rs1_data[15:0]}};
        imm_expand    = {8{immediate[15:0]}};
        end

        3'b010: // SEW = 32
        begin
        scalar_expand = {4{rs1_data}};
        imm_expand    = {4{immediate}};
        end

        3'b011: // SEW = 64
        begin 
        scalar_expand = {2{{32{rs1_data[31]}}, rs1_data}};
        imm_expand    = {2{{32{immediate[31]}}, immediate}};
        end

        default: 
        begin
        scalar_expand = 128'd0;
        imm_expand    = 128'd0;
        end

        endcase


        // operand select
        if (is_vv) 
        begin
        alu_in1 = vs1_data;
        alu_in2 = vs2_data;
        end

        else if (is_vx) 
        begin
        alu_in1 = vs2_data;
        alu_in2 = scalar_expand;
        end

        else if (is_vi)
        begin
        alu_in1 = vs2_data;
        alu_in2 = imm_expand;
        end

    end

endmodule

