module div_32_logic #
(
    parameter WIDTH = 32
)
(
    input                   clk,
    input                   reset,
    input                   start,
    input      [WIDTH-1:0]  dividend,
    input      [WIDTH-1:0]  divisor,
    output reg [WIDTH-1:0]  quotient,
    output reg [WIDTH-1:0]  remainder,

    output reg              done
);

    // -------- State Registers -------- 
    reg [WIDTH-1:0] Q;
    reg [WIDTH-1:0] B;
    reg [WIDTH:0]   R;

    reg sign_a, sign_q;
    reg [4:0] count;
    reg busy;

    // -------- Next-State Signals -------- 
    reg [WIDTH-1:0] Q_next;
    reg [WIDTH:0]   R_next;

    // -------- Combinational Next-State -------- 
    always @(busy or Q or R or B)
    begin
        Q_next = Q;
        R_next = R;
 
        if (busy)
        begin
            // Shift left (R,Q) 
            R_next = {R[WIDTH-1:0], Q[WIDTH-1]};
            Q_next = {Q[WIDTH-2:0], 1'b0};

            // Subtract 
            if (R_next >= {1'b0, B})
            begin
                R_next = R_next - {1'b0, B};
                Q_next[0] = 1'b1;
            end
        end
    end

    // -------- Sequential Logic -------- 
    always @(posedge clk or posedge reset)
    begin
        if (reset)
        begin
            Q         <= {WIDTH{1'b0}};
            B         <= {WIDTH{1'b0}};
            R         <= {(WIDTH+1){1'b0}};
            quotient  <= {WIDTH{1'b0}};
            remainder <= {WIDTH{1'b0}};
            sign_a    <= 1'b0;
            sign_q    <= 1'b0;
            count     <= 5'd0;
            busy      <= 1'b0;
            done      <= 1'b0;
        end
        else
        begin
            done <= 1'b0;

            // START 
            if (start && !busy)
            begin
                if (divisor == {WIDTH{1'b0}})
    begin
        quotient  <= {WIDTH{1'b1}};
        remainder <= dividend;
        done      <= 1'b1;
        busy      <= 1'b0;
    end
    else
    begin

                busy  <= 1'b1;
                count <= WIDTH[4:0];

                sign_a <= dividend[WIDTH-1];
                sign_q <= dividend[WIDTH-1] ^ divisor[WIDTH-1];

                Q <= dividend[WIDTH-1] ? (~dividend + {{(WIDTH-1){1'b0}},1'b1}) : dividend;
                B <= divisor[WIDTH-1]  ? (~divisor  + {{(WIDTH-1){1'b0}},1'b1}) : divisor;
                R <= {(WIDTH+1){1'b0}};
            end
        end
            // DIVIDE 
            else if (busy)
            begin
                Q <= Q_next;
                R <= R_next;
                count <= count - 5'd1;

                if (count == 5'd1)
                begin
                    busy <= 1'b0;
                    done <= 1'b1;

                    quotient  <= sign_q ? (~Q_next + {{(WIDTH-1){1'b0}},1'b1}) : Q_next;
                    remainder <= sign_a ? (~R_next[WIDTH-1:0] + {{(WIDTH-1){1'b0}},1'b1}) : R_next[WIDTH-1:0];
                end
            end
        end
    end

endmodule

