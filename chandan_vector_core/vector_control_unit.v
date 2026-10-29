module vector_control_unit(
    input  [6:0] opcode,
    input  [2:0] funct3,
    input  [5:0] funct6,

    output reg reg_write_vector,
    output reg [4:0] alu_op,
    output reg mem_write,
    output reg wbdata,      // 0 = ALU result, 1 = memory data
    output reg alu_cin,
    output is_mul,
    output is_div
);

    // -------------------------------------------------
    // Operand type decode (from funct3)
    // -------------------------------------------------
    wire is_vv       = (funct3 == 3'b000);
    wire is_vx       = (funct3 == 3'b100);
    wire is_vi       = (funct3 == 3'b011);


    // -------------------------------------------------
    // Default values
    // -------------------------------------------------

    always @(opcode or funct6 or is_vv or is_vx or is_vi) 
    begin
   
    reg_write_vector = 1'b0;
    alu_op           = 5'b11111;
    mem_write        = 1'b0;
    wbdata           = 1'b0;
    alu_cin          = 1'b0;

    case (opcode)

    // =================================================
    // VECTOR ARITHMETIC (VV / VX / VI )
    // =================================================
    7'b1010111: 
    begin

    if (is_vv || is_vx || is_vi)
    begin
    reg_write_vector = 1'b1;
    wbdata = 1'b0;

        case (funct6)                       //Arithmetic operations

               6'b000000:                   //Add
               begin
                    alu_op  = 5'b00000;
                    alu_cin = 1'b0;
                end

                
                6'b000001: begin            //sub
                    alu_op  = 5'b00000;     // reuse adder
                    alu_cin = 1'b1;
                end

               
                6'b000010: alu_op = 5'b00001; //AND                
                6'b000011: alu_op = 5'b00010; //OR               
                6'b000100: alu_op = 5'b00011; //XOR

                
                6'b000101: alu_op = 5'b00100; // sll
                6'b000110: alu_op = 5'b00101; // srl
                6'b000111: alu_op = 5'b00110; // sra


                6'b001000: alu_op = 5'b00111; // vmseq               
                6'b001001: alu_op = 5'b01000; // vmsne              
                6'b001010: alu_op = 5'b01001; // vmsltu
                6'b001011: alu_op = 5'b01010; // vmslt
                6'b001100: alu_op = 5'b01011; // vmsleu
                6'b001101: alu_op = 5'b01100; // vmsle


                6'b001110: alu_op = 5'b01101; // minu
                6'b001111: alu_op = 5'b01110; // min
                6'b010000: alu_op = 5'b01111; // maxu  
                6'b010001: alu_op = 5'b10000; // max  
                
                6'b010010: alu_op = 5'b10001; // mul
                6'b010101: alu_op = 5'b10100; // divide
                6'b010110: alu_op = 5'b10101; // remainder

                6'b011000: alu_op = 5'b10111; // vmsgtu
                6'b011001: alu_op = 5'b11000; // vmsgt  
 
                default: begin
                    alu_op  = 5'b11111;
                    alu_cin = 1'b0;
                end
            endcase
        end
    end

    // =================================================
    // VECTOR LOAD
    // =================================================
    7'b0000111: begin
        reg_write_vector = 1'b1;
        wbdata           = 1'b1;     // memory ? writeback
        alu_op           = 5'b00000; // address add
        alu_cin          = 1'b0;
    end

    // =================================================
    // VECTOR STORE
    // =================================================
    7'b0100111: begin
        mem_write = 1'b1;
        wbdata    = 1'b0;            // don't care
        alu_op    = 5'b00000;        // address add
        alu_cin   = 1'b0;
    end

    default: begin
        
        reg_write_vector = 1'b0; 
        alu_op = 5'b11111; 
        mem_write = 1'b0; 
        wbdata = 1'b0;     
    end

    endcase
end

assign is_mul = (funct6 == 6'b010010);
assign is_div = (funct6 == 6'b010101) || (funct6 == 6'b010110);

endmodule
